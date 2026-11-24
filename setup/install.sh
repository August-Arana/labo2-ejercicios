#!/usr/bin/env bash
# Labo II environment installer (Ubuntu/Debian). Idempotent: safe to re-run.
#
#   git clone git@github.com:August-Arana/labo2-ejercicios.git ~/labo2-ejercicios
#   ~/labo2-ejercicios/setup/install.sh
#
# Installs: Docker + Compose, a JDK 17+, SQL Developer, SQLcl, the `lab` CLI,
# the Neovim integration, and starts Oracle with both schemas loaded.
set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
OPT="$HOME/.local/opt"
CACHE="$HOME/.cache/labo2"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/labo2"
SQLDEV_VERSION="26.2.0.186.2220"
SQLDEV_ZIP="sqldeveloper-${SQLDEV_VERSION}-no-jre.zip"
SQLDEV_URL="https://download.oracle.com/otn_software/java/sqldeveloper/${SQLDEV_ZIP}"
SQLCL_URL="https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip"

step() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
mkdir -p "$OPT" "$CACHE" "$CONF_DIR" "$HOME/.local/bin" "$HOME/.local/share/applications"

# ---------------------------------------------------------------- packages
step "System packages (docker, compose, unzip, curl)"
missing=()
for p in docker.io docker-compose-v2 unzip curl; do
  dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
done
# Docker CE from docker.com also works; don't fight it.
if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
  missing=("${missing[@]/docker.io}"); missing=("${missing[@]/docker-compose-v2}")
fi
missing=($(printf '%s\n' "${missing[@]}" | grep -v '^$' || true))
if [ ${#missing[@]} -gt 0 ]; then
  sudo apt-get update
  sudo apt-get install -y "${missing[@]}"
fi
sudo systemctl enable --now docker >/dev/null 2>&1 || true
if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "Added $USER to the docker group (takes effect on next login; 'lab' works meanwhile)."
fi

# ---------------------------------------------------------------- java
step "JDK 17+ for SQL Developer / SQLcl"
java_major() { "$1/bin/java" -version 2>&1 | awk -F'"' '/version/ {split($2,v,"."); print v[1]}'; }
JH=""
# Prefer an LTS 17/21 (what SQL Developer is certified on), then anything >= 17.
for cand in "$HOME"/.sdkman/candidates/java/17* "$HOME"/.sdkman/candidates/java/21* \
            /usr/lib/jvm/java-17-openjdk-* /usr/lib/jvm/java-21-openjdk-* \
            /usr/lib/jvm/temurin-17* /usr/lib/jvm/temurin-21*; do
  [ -x "$cand/bin/java" ] && { JH="$cand"; break; }
done
if [ -z "$JH" ]; then
  sudo apt-get install -y openjdk-21-jdk
  JH="$(ls -d /usr/lib/jvm/java-21-openjdk-* | head -1)"
fi
echo "Using JDK $(java_major "$JH") at $JH"
echo "LABO2_JAVA_HOME=$JH" > "$CONF_DIR/env"

# ---------------------------------------------------------------- SQLcl
step "SQLcl"
if [ ! -x "$OPT/sqlcl/bin/sql" ]; then
  [ -f "$CACHE/sqlcl-latest.zip" ] || curl -fL --progress-bar -o "$CACHE/sqlcl-latest.zip" "$SQLCL_URL"
  (cd "$OPT" && unzip -q -o "$CACHE/sqlcl-latest.zip")
fi
ln -sf "$OPT/sqlcl/bin/sql" "$HOME/.local/bin/sql"
echo "SQLcl $(awk -F= '/^RELEASE=/{print $2}' "$OPT/sqlcl/bin/version.txt" 2>/dev/null)"

# ---------------------------------------------------------------- SQL Developer
step "SQL Developer $SQLDEV_VERSION"
if ! grep -q "VER_FULL=$SQLDEV_VERSION" "$OPT/sqldeveloper/sqldeveloper/bin/version.properties" 2>/dev/null; then
  [ -f "$CACHE/$SQLDEV_ZIP" ] || curl -fL --progress-bar -o "$CACHE/$SQLDEV_ZIP" "$SQLDEV_URL"
  rm -rf "$OPT/sqldeveloper"
  (cd "$OPT" && unzip -q -o "$CACHE/$SQLDEV_ZIP")
fi
chmod +x "$OPT/sqldeveloper/sqldeveloper.sh"
VER_SHORT="$(awk -F= '/^VER=/{print $2}' "$OPT/sqldeveloper/sqldeveloper/bin/version.properties")"
mkdir -p "$HOME/.sqldeveloper/$VER_SHORT"
cat > "$HOME/.sqldeveloper/$VER_SHORT/product.conf" <<EOF
# Written by labo2-ejercicios/setup/install.sh
SetJavaHome $JH
AddVMOption -Dawt.useSystemAAFontSettings=lcd
AddVMOption -Dswing.aatext=true
AddVMOption -Xmx2g
EOF
# Uncomment for a HiDPI/4K screen:
# echo 'AddVMOption -Dsun.java2d.uiScale=2' >> "$HOME/.sqldeveloper/$VER_SHORT/product.conf"

# Pre-load the "labo2" connection (password is asked on first connect: labo).
CONN_DIR="$HOME/.sqldeveloper/system${SQLDEV_VERSION}/o.jdeveloper.db.connection"
mkdir -p "$CONN_DIR"
if [ ! -f "$CONN_DIR/connections.json" ]; then
  cp "$REPO/setup/sqldeveloper/connections.json" "$CONN_DIR/connections.json"
else
  echo "SQL Developer already has connections; import setup/sqldeveloper/connections.json manually if 'labo2' is missing."
fi

cat > "$HOME/.local/share/applications/sqldeveloper.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=SQL Developer
Comment=Oracle SQL Developer (Labo II)
Exec=$OPT/sqldeveloper/sqldeveloper.sh
Icon=$OPT/sqldeveloper/icon.png
Terminal=false
Categories=Development;Database;
StartupWMClass=oracle-ide-osgi-boot-OracleIdeLauncher
EOF
ln -sf "$OPT/sqldeveloper/sqldeveloper.sh" "$HOME/.local/bin/sqldeveloper"

# ---------------------------------------------------------------- lab CLI + nvim
step "lab CLI and Neovim integration"
chmod +x "$REPO/bin/lab"
ln -sf "$REPO/bin/lab" "$HOME/.local/bin/lab"
mkdir -p "$HOME/.local/share/nvim/site/plugin"
ln -sf "$REPO/nvim/labo2.lua" "$HOME/.local/share/nvim/site/plugin/labo2.lua"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "NOTE: add ~/.local/bin to your PATH";; esac

# ---------------------------------------------------------------- database
step "Starting Oracle (first start creates the DB and loads BDEMOBLD + GREMIO; ~1-2 min)"
"$REPO/bin/lab" up

step "Smoke test"
printf 'select count(*) employees from employee;\nselect count(*) aventureros from aventurero;\n' > "$CACHE/smoke.sql"
"$REPO/bin/lab" run "$CACHE/smoke.sql" </dev/null || true

cat <<EOF

All set.
  lab help            -> every command
  lab sqldev          -> SQL Developer (connection "labo2", password: labo)
  nvim file.sql       -> <space>lr runs the file inside the repo
  lab up nosql        -> also starts Neo4j (http://localhost:7474) and MongoDB
EOF
