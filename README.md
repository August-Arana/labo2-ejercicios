# labo2-ejercicios

Study environment and exercise set for the **Laboratorio II** final (Oracle SQL, PL/SQL, packages, ORM, NoSQL, JSON, graph and columnar databases).

- **Study plan:** [`ROADMAP.md`](ROADMAP.md) (21 days, in Spanish)
- **Exercises:** [`ejercicios/`](ejercicios) · **Mock exams:** [`simulacros/`](simulacros) · **Theory:** [`teoria/`](teoria)
- **Your answers:** `soluciones/<guide>/ejNN.sql` · **Feedback log:** [`correcciones.md`](correcciones.md)

## What you get

| Piece | Details |
|---|---|
| Oracle Database 23ai Free | Docker (`gvenzl/oracle-free`), `localhost:1521/FREEPDB1`, user `labo` / `labo` |
| Schemas | `BDEMOBLD` (the course schema: EMPLOYEE, DEPARTMENT, …) and `GREMIO` (D&D-themed practice schema mirroring it) |
| SQL Developer 26.2 | `~/.local/opt/sqldeveloper`, desktop entry, JDK 17, preloaded connection `labo2` |
| SQLcl | `~/.local/opt/sqlcl`, `sql` on the PATH |
| `lab` CLI | start/stop/reset the DB, run scripts, open tools |
| Neovim integration | `<space>lr` runs the current `.sql` file against Oracle |
| Neo4j 5 + MongoDB 8 | optional, `lab up nosql` (units 8–10) |
| Hibernate project | `orm/`, maps the course tables (unit 7) |

## Install (desktop or laptop, Ubuntu/Debian)

```bash
git clone git@github.com:August-Arana/labo2-ejercicios.git ~/labo2-ejercicios
~/labo2-ejercicios/setup/install.sh
```

The installer is idempotent. It needs `sudo` once (Docker packages and the docker group) and downloads ~1 GB (Oracle image, SQL Developer, SQLcl). If you've just been added to the `docker` group, `lab` still works through `sg`; log out and back in when convenient.

## Daily use

```bash
lab up                 # start Oracle (waits until it is ready)
lab sqldev             # SQL Developer → connection "labo2", password: labo
lab run file.sql       # run a script (DBMS_OUTPUT on, &variables prompt you)
lab sql                # interactive SQLcl
lab reset              # reload BDEMOBLD + GREMIO after DML exercises (also: reset bdemobld|gremio)
lab up nosql           # + Neo4j (http://localhost:7474, neo4j/labo2neo4j) and MongoDB
lab cypher | lab mongo # shells for those
lab down               # stop everything (data is kept)
lab help
```

### Writing in Neovim, running anywhere

Write your exercises in nvim inside this repo. In any `.sql` buffer here:

| Key | Action |
|---|---|
| `<space>lr` | save and run the whole file (output in a bottom split; answer `&` prompts there) |
| `<space>ls` | run the visual selection (a trailing `/` is added after `END;`) |
| `<space>lq` | interactive SQLcl session |
| `<space>ld` | launch SQL Developer |
| `<space>lc` | close the output split |

The plugin lives in `nvim/labo2.lua` and is symlinked into `~/.local/share/nvim/site/plugin/`, so your nvim config repo is untouched.

**SQL Developer still matters:** the exam is probably taken in it. Open the same files there (File → Open). Enable *Tools → Preferences → Environment → Automatically Reload Externally Modified Files* so edits made in nvim show up there.

Conventions that make files run in both tools:
- End every PL/SQL block with a `/` on its own line.
- Use `&var` (substitution) for input, not `:var` (binds aren't prompted in SQLcl).

### Troubleshooting

- **Connection "labo2" missing in SQL Developer:** right-click *Connections* → *Import Connections…* → `setup/sqldeveloper/connections.json`.
- **Tiny UI on a HiDPI screen:** add `AddVMOption -Dsun.java2d.uiScale=2` to `~/.sqldeveloper/26.2.0/product.conf`.
- **Oracle won't start:** `lab logs`. To start over completely: `lab nuke && lab up` (drops your stored procedures too).
- **Port 1521 busy:** another Oracle is running; stop it or change the port in `docker-compose.yml`.

## Layout

```
bin/lab                    CLI
docker-compose.yml         Oracle (+ Neo4j, MongoDB under the "nosql" profile)
db/oracle/schema/          bdemobld.sql (course), gremio.sql (practice)
db/oracle/init/            first-start scripts (grants + schema load)
db/neo4j/, db/mongo/       NoSQL seeds
setup/install.sh           installer · setup/sqlcl/ SQLcl defaults · setup/sqldeveloper/ connection
nvim/labo2.lua             Neovim integration
orm/                       Maven + Hibernate starter
ejercicios/ simulacros/ teoria/   study material (Spanish)
soluciones/                your answers
```

Course PDFs and videos are **not** in this repo (it is public, and they belong to the university). They live in `/media/august/TODO/Ingenieria/13 - Laboratorio II/`.
