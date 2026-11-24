# CLAUDE.md: labo2-ejercicios

Study repo for August's **Laboratorio II** final (Universidad de Palermo, Ingeniería Informática). Target exam date: ~2026-12-15. Chat in Spanish (rioplatense); study material is in Spanish, tooling and README in English.

## Start of every session
1. Read `ROADMAP.md` (the checked boxes show progress) and `correcciones.md` (recurring mistakes).
2. `lab status`; if Oracle is down, run `lab up`.
3. Ask what day of the roadmap they're on only if the checkboxes don't make it obvious.

## Correcting exercises ("corregime ...")
- Answers live in `soluciones/<guide>/ejNN.sql`; statements live in `ejercicios/<guide>.md`.
- **Run their code** (`lab run file.sql </dev/null`; for `&` prompts, create a temp copy with the values substituted) and compare with the statement and the ✅ expected results.
- Append the feedback to `correcciones.md` under a dated heading: what is right, what is wrong and why, the fixed version only for the broken part, and the concept to review. Keep the tone of `~/Java-ejercicios/correcciones.md`.
- Don't rewrite their files. Don't hand out full solutions before they try; give hints first.
- After corrections, `lab reset` if their scripts changed data.
- Check the roadmap boxes they finished; commit with explicit paths (never `git add -A`).

## Facts
- DB: Oracle 23ai Free in Docker, `labo/labo@//localhost:1521/FREEPDB1`; SYS/SYSTEM password `labo2admin`.
- Schemas: BDEMOBLD (`db/oracle/schema/bdemobld.sql`, the course one; hire dates are 2004–2006, not 1985 like the guides) and GREMIO (`gremio.sql`, generated, mirrors BDEMOBLD).
- Course material (PDF, mp4) is at `/media/august/TODO/Ingenieria/13 - Laboratorio II/` and must NOT be committed (public repo). Some files there are corrupted (zero-filled): `04-Tablas-Bdemobld(1).sql`; `TablasBdemobldmodificado.txt` is the good copy.
- Exam format still unconfirmed (practical in SQL Developer is likely); mock exams are designed for SQL Developer.
