# Roadmap: Final de Laboratorio II (Bases de Datos)

**Plan de 21 días:** del martes 24/11 al lunes 14/12, con el final estimado para el **martes 15/12**.
Si la fecha real es otra, corré los días pero no saltees las semanas: cada una se apoya en la anterior.

Todo el contenido de la materia está cubierto: las 10 unidades del campus, las guías de ejercicios de la cátedra (reescritas) y bastante práctica extra.

| Semana | Tema central | Unidades | Cierre |
|---|---|---|---|
| 1 | **SQL** y primeros bloques PL/SQL | U1, U2, DML de U3 | Simulacro 1 (domingo 29/11) |
| 2 | **PL/SQL de verdad**: cursores, excepciones, procedimientos y funciones | U3, U4, U5 | Simulacro 2 (domingo 6/12) |
| 3 | **Paquetes** + teoría (ORM, NoSQL, JSON, grafos, columnares) | U6 a U10 | Simulacro final (domingo 13/12) |

> **Ritmo sugerido:** entre 2,5 y 3,5 h por día. Cada día tiene un bloque de **teoría** (apunte del campus), uno de **práctica** (ejercicios del repo) y un **jefe** 🐉, el ejercicio integrador del día. Si un día no llegás, hacé al menos el jefe.

---

## Cómo se trabaja

1. Leés el apunte indicado (está en `/media/august/TODO/Ingenieria/13 - Laboratorio II/`).
2. Abrís la guía del día (`ejercicios/NN-*.md`) y resolvés cada ejercicio en `soluciones/NN-*/ejXX.sql`.
3. Escribís en **Neovim** y ejecutás con `<espacio>lr`. El output aparece abajo.
4. Cada tanto repetís un ejercicio en **SQL Developer**, porque probablemente rindas ahí: tenés que conocer F5 contra Ctrl+Enter, el panel de DBMS Output y las variables `&`.
5. Cuando terminás un bloque, le pedís a Claude: *"corregime soluciones/04-cursores"*. Las correcciones se acumulan en `correcciones.md`.
6. Si un ejercicio de DML te desarmó los datos, corrés `lab reset`.

### Iconos
- 🏛️ **Cátedra**: ejercicio de las guías oficiales (reescrito). Estos tienen que salir sí o sí.
- ⚔️ **Side quest**: el mismo concepto aplicado al esquema `GREMIO` (aventureros, misiones, botín).
- 🎲 **Predecí**: escribí en un comentario qué va a pasar *antes* de ejecutar.
- 💀 **Trampa**: algo falla o da un resultado raro a propósito. Hay que explicar por qué.
- 📜 **Oral**: respondé en 2 o 3 líneas, como si te lo preguntaran en el final.
- 🐉 **Jefe**: ejercicio integrador.

---

## SEMANA 1: SQL y primeros bloques

### Día 1 · mar 24/11: Entorno y modelo de datos
- [ ] Leer `README.md` y dejar funcionando `lab up`, `lab sqldev` y `<espacio>lr` en nvim.
- [ ] Apunte: *01 - Introducción a Oracle y uso de SQL* (págs. 1 a 16: tipos de datos, SELECT, operadores, NULL).
- [ ] `ejercicios/00-entorno.md` completo. Ahí dibujás el DER de BDEMOBLD **a mano**: lo vas a usar todo el mes.
- [ ] `ejercicios/01-sql.md`: Nivel 1 (ej. 1 a 8).
- 🐉 Jefe: ej. 8 (precedencia de operadores, 22 contra 12 filas).

### Día 2 · mié 25/11: Funciones de fila simple
- [ ] Apunte: *01 - Introducción...* (págs. 24 a 32) + *Material adicional (2)*: formatos de fecha y número.
- [ ] `01-sql.md`: Nivel 2 (ej. 9 a 15).
- 🐉 Jefe: ej. 15 (reporte de clientes con teléfono formateado y NVL).

### Día 3 · jue 26/11: Joins
- [ ] Apunte: *01 - Introducción...* (págs. 17 a 21: natural, inner, outer, `(+)`, full, recursivo).
- [ ] `01-sql.md`: Nivel 3 (ej. 16 a 23) y side quests G1 a G4.
- 🐉 Jefe: ej. 23 (los cuatro tipos de outer join sobre el mismo par de tablas).

### Día 4 · vie 27/11: Agrupamiento, subconsultas y DDL
- [ ] Apunte: *01 - Introducción...* (págs. 22 a 23 y 33 a 37) + *Material adicional (3)*: CREATE TABLE y constraints.
- [ ] `01-sql.md`: Niveles 4 y 5 (ej. 24 a 36) y side quests G5 a G8.
- 🐉 Jefe: ej. 36 (tabla `DIRECTIVOS` con las 5 constraints, rompiendo cada una a propósito).

### Día 5 · sáb 28/11: DML, transacciones e integridad referencial
- [ ] Apunte: *03 - Sentencias DML*.
- [ ] `ejercicios/02-dml-transacciones.md` completo (incluye la Ejercitación 1 de la cátedra entera).
- [ ] `lab reset` al terminar.
- 🐉 Jefe: el "duelo de sesiones" (dos conexiones a la vez y el COMMIT que nadie hizo).

### Día 6 · sáb 28/11 (tarde) o dom 29/11 (mañana): Bloques PL/SQL
- [ ] Apuntes: *02 - Lenguaje procedural PL/SQL: Bloques* y *Características de las variables*.
- [ ] `ejercicios/03-bloques.md` completo (guía de la cátedra de la U2 + extras).
- 🐉 Jefe: la "tirada de iniciativa" (bucles, IF/CASE, `%TYPE`).

### Día 7 · dom 29/11: Simulacro 1 + repaso
- [ ] `simulacros/simulacro-1.md`: **90 minutos cronometrados**, sin mirar nada. Hacelo en SQL Developer.
- [ ] Pedí la corrección y anotá en `correcciones.md` los errores que se repiten.
- [ ] `teoria/preguntas-oral.md`: sección U1 y U2.

---

## SEMANA 2: PL/SQL de verdad

### Día 8 · lun 30/11: SELECT INTO, DML en bloques y cursores implícitos
- [ ] Apunte: *03 - Cursores* (primera mitad: cursores implícitos y `SQL%ROWCOUNT`, `%FOUND`, `%NOTFOUND`).
- [ ] `ejercicios/04-cursores.md`: Parte A (ej. 1 a 7; incluye los ej. 1 a 5 de la Ejercitación 2).
- 🐉 Jefe: ej. 5 (repricing de productos según ventas: el precio vigente es el de `END_DATE` nulo).

### Día 9 · mar 1/12: Cursores explícitos
- [ ] Apunte: *03 - Cursores* (segunda mitad: OPEN/FETCH/CLOSE, FOR LOOP, parámetros, cursores anidados).
- [ ] `04-cursores.md`: Parte B (ej. 8 a 14; incluye los ej. 6 a 10 de la Ejercitación 2).
- 🐉 Jefe: ej. 10 de la cátedra (listado departamento → empleados con dos cursores, formato exacto).

### Día 10 · mié 2/12: Cursores avanzados y side quests
- [ ] `04-cursores.md`: Parte C (FOR UPDATE / WHERE CURRENT OF, registros `%ROWTYPE`) y side quests ⚔️.
- 🐉 Jefe: "el reparto del botín" (cursor anidado + UPDATE con reglas de reparto).

### Día 11 · jue 3/12: Excepciones
- [ ] Apunte: *04 - Excepciones*.
- [ ] `ejercicios/05-excepciones.md` completo (incluye la Actividad Excepciones entera).
- 🐉 Jefe: ej. 9 (propagación entre bloques anidados: predecir qué handler atrapa qué).

### Día 12 · vie 4/12: Procedimientos y funciones (I)
- [ ] Apuntes: *05 - Procedimientos y funciones en la BD* y *Material adicional*.
- [ ] `ejercicios/06-procedimientos-funciones.md`: Parte A (procedimientos, IN/OUT/IN OUT, `USER_ERRORS`).
- 🐉 Jefe: `alta_precio` (cierra el precio vigente y abre uno nuevo, con manejo de FK).

### Día 13 · sáb 5/12: Procedimientos y funciones (II)
- [ ] `06-procedimientos-funciones.md`: Parte B (funciones, funciones usadas desde SQL, combinaciones) y side quests.
- 🐉 Jefe: "el tablón de misiones" (función más procedimiento más excepción de usuario más bitácora).

### Día 14 · dom 6/12: Simulacro 2 + repaso
- [ ] `simulacros/simulacro-2.md`: **2 horas cronometradas**, en SQL Developer.
- [ ] Corrección y repaso de `correcciones.md`.
- [ ] `teoria/preguntas-oral.md`: U3 a U5.

---

## SEMANA 3: Paquetes y teoría

### Día 15 · lun 7/12: Paquetes (I)
- [ ] Apunte: *06 - Paquetes* (spec/body, público/privado, sobrecarga, DROP).
- [ ] `ejercicios/07-paquetes.md`: Parte A.
- 🐉 Jefe: paquete `PKG_PRODUCTOS` con sobrecarga "bien hecha" (una versión core que llaman las demás).

### Día 16 · mar 8/12: Paquetes (II): estado, one-time-only y colecciones
- [ ] Apunte: *06 - Paquetes* (tablas dinámicas, bloque one-time-only, BULK COLLECT, FIRST/NEXT/EXISTS).
- [ ] `07-paquetes.md`: Parte B y side quest `PKG_GREMIO`.
- 🐉 Jefe: caché de departamentos en memoria cargada en el bloque one-time-only.

### Día 17 · mié 9/12: ORM
- [ ] Apunte: *07 - Conceptos sobre ORM*.
- [ ] `ejercicios/08-orm.md` (mini proyecto Hibernate en `orm/` contra tu Oracle: entidades, HQL, transacciones).
- 📜 Preguntas de oral de la U7.

### Día 18 · jue 10/12: NoSQL y JSON
- [ ] Apuntes: *08 - Bases NoSQL* y *10 - Formato JSON*. Video del profesor sobre SQL contra NoSQL.
- [ ] `ejercicios/09-nosql-json.md`: modelado JSON (la actividad de la cátedra), CAP, MongoDB y JSON dentro de Oracle.
- 🐉 Jefe: modelar en JSON el esquema GREMIO, embebiendo y referenciando, y justificar cada decisión.

### Día 19 · vie 11/12: Grafos y columnares
- [ ] Apuntes: *09 - Bases columnares y grafos* y *Tutorial Neo4J*.
- [ ] `ejercicios/10-grafos-columnares.md` (Neo4j con `lab up nosql` y diseño de tablas tipo Cassandra).
- 🐉 Jefe: el grafo del gremio (mentores, misiones) y las consultas de caminos.

### Día 20 · sáb 12/12: Repaso integrador
- [ ] Rehacer **sin mirar** los 🐉 jefes de los días 9, 11, 13 y 16.
- [ ] `teoria/chuleta-plsql.md`: reescribirla de memoria en papel y comparar.
- [ ] `teoria/preguntas-oral.md` completo.

### Día 21 · dom 13/12: Simulacro final
- [ ] `simulacros/simulacro-final.md`: **2,5 horas**, condiciones de examen.
- [ ] Corrección. Lo que falle se repasa el lunes.

### Lunes 14/12: Descanso activo
- [ ] Solo `correcciones.md` y la chuleta. Nada nuevo. Dormir bien.

---

## Antes del final: preguntá esto

- ¿El final es **práctico en máquina** (SQL Developer), **escrito** o **mixto con oral**? El plan prepara los tres, pero si es en máquina, los simulacros tienen que ser **siempre** en SQL Developer.
- ¿Se puede llevar la chuleta? ¿Se usa el esquema BDEMOBLD de la cursada? (Casi seguro que sí: todas las guías lo usan.)
- ¿Hay que entregar algo antes (TPs, actividades pendientes)?

## Errores clásicos que te van a restar puntos
1. `= NULL` en lugar de `IS NULL`; aritmética con NULL sin `NVL`.
2. `SELECT ... INTO` sin manejar `NO_DATA_FOUND` / `TOO_MANY_ROWS`.
3. Olvidar `SET SERVEROUTPUT ON` y "no ver nada".
4. Columnas en el SELECT que no están en el GROUP BY; `WHERE AVG(...)` en lugar de `HAVING`.
5. Usar `SQL%ROWCOUNT` después de un `SELECT INTO` esperando el COUNT (devuelve 1).
6. Olvidar el `/` al final de un bloque cuando ejecutás como script (F5).
7. Funciones sin `RETURN` en todos los caminos (ORA-06503).
8. Cursor explícito sin `CLOSE`, o `EXIT WHEN %NOTFOUND` puesto después de usar la variable.
9. Crear el body de un paquete sin crear primero la spec.
10. Comparar strings sin `UPPER` cuando los datos están en mayúsculas ('Clerk' ≠ 'CLERK').
