#!/bin/bash
# Runs once, on the first start of an empty Oracle volume.
# Loads the course schema (BDEMOBLD) and the practice schema (GREMIO) into LABO.
set -e
for f in bdemobld.sql gremio.sql; do
  echo "[labo2] loading $f"
  sqlplus -s -L "labo/labo@//localhost/FREEPDB1" <<SQL
set echo off feedback off termout off
@/opt/labo2/schema/$f
exit
SQL
done
echo "[labo2] schemas loaded"
