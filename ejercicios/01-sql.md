# 01 · SQL (Unidad 1)

Apuntes: *01 - Introducción a Oracle y uso de SQL* + *Material adicional (1), (2), (3)*.
Resolvé cada ejercicio en `soluciones/01-sql/ejNN.sql`. Los ✅ son el resultado esperado contra los datos originales (si algo no coincide, `lab reset bdemobld`).

---

## Nivel 1: SELECT, WHERE, ORDER BY, NULL

**Ej. 1:** Apellido, nombre y salario de los empleados del departamento 20, del que más gana al que menos. ✅ 5 filas, empieza con SCOTT/FORD (3000).

**Ej. 2:** Lo mismo que el 1, pero con alias: `"Apellido"`, `"Nombre"`, `"Sueldo mensual"`. 🎲 ¿Podés usar el alias `"Sueldo mensual"` en el `ORDER BY`? ¿Y en el `WHERE`? Probá las dos.

**Ej. 3:** Nombres de departamento **sin repetir**, ordenados alfabéticamente. ✅ 4 filas.

**Ej. 4:** 🎲 Predecí cuántas filas devuelve cada una y después ejecutá:
```sql
SELECT COUNT(*) FROM employee WHERE commission = NULL;
SELECT COUNT(*) FROM employee WHERE commission IS NULL;
SELECT COUNT(commission) FROM employee;
SELECT COUNT(*) FROM employee;
```
✅ 0 · 22 · 10 · 32. 📜 Explicá por qué la primera da 0 y por qué `COUNT(commission)` ≠ `COUNT(*)`.

**Ej. 5:** Empleados cuyo apellido tiene una **A como segunda letra**. ✅ 5 filas. Después, los que **terminan** en S y los que **contienen** "ON".

**Ej. 6:** Empleados con salario **entre 1250 y 1500** (inclusive) que sean CLERK o SALESPERSON. Usá `BETWEEN` e `IN`, y resolvelo primero con los `job_id` a mano (667, 670). ✅ 11 filas.

**Ej. 7:** Lista de empleados con una sola columna `empleado` con el formato `KING, Francis` (apellido en mayúsculas, nombre con inicial mayúscula). Pista: `||` e `INITCAP`.

**Ej. 8: 🐉 Jefe: precedencia** 🎲
```sql
-- A
SELECT employee_id, last_name, salary, commission FROM employee
 WHERE commission IS NULL OR salary > 2000 AND salary < 2500;
-- B
SELECT employee_id, last_name, salary, commission FROM employee
 WHERE (commission IS NULL OR salary > 2000) AND salary < 2500;
```
Antes de ejecutar, escribí en castellano qué pide cada una. ✅ A = 22 filas, B = 12 filas. 📜 ¿En qué orden evalúa Oracle NOT, AND y OR? Escribí una versión C que devuelva lo mismo que A pero con paréntesis explícitos.

---

## Nivel 2: Funciones de fila simple

**Ej. 9:** Salario anual de cada empleado (`salary * 12 + commission * 12`). 💀 ¿Qué pasa con los que tienen comisión nula? Arreglalo con `NVL`. ✅ Top 3 con NVL: KING 60000, ALBERTS 36000, SCOTT 36000.

**Ej. 10:** 🎲 Predecí los resultados y comprobá con `FROM DUAL`:
```sql
ROUND(45.978, 2), ROUND(45.923, 0), ROUND(45.923, -1),
TRUNC(45.978, 2), TRUNC(45.923),    TRUNC(45.923, -1),
MOD(17, 5), CEIL(4.1), FLOOR(-4.1), POWER(2, 10), SIGN(-7)
```

**Ej. 11:** Para cada empleado: apellido, fecha de ingreso con el formato `Monday 16, February 2004` y fecha con el formato `16/02/2004`. 💀 Probá `'Day'` contra `'fmDay'`: ¿de dónde salen los espacios de más?

**Ej. 12:** Antigüedad de cada empleado en **años completos** al día de hoy (`MONTHS_BETWEEN`, `TRUNC`). Agregá la fecha en que cumple (o cumplió) 20 años en la empresa (`ADD_MONTHS`).

**Ej. 13:** Fechas útiles sobre `SYSDATE` (con `DUAL`): el último día del mes, el próximo viernes, el primer día del año (`TRUNC(SYSDATE, 'YYYY')`) y el primer día del mes. 📜 ¿Qué devuelve `SYSDATE + 1`? ¿Y `SYSDATE + 1/24`?

**Ej. 14:** Conversiones:
- `TO_CHAR(salary, '$9,999.00')` para todos los empleados.
- `TO_NUMBER('1.500,75', ...)`: 💀 ¿por qué falla sin máscara?
- `TO_DATE('25/12/2026', 'DD/MM/YYYY') - SYSDATE`: ¿cuántos días faltan para Navidad?
- 📜 Diferencia entre conversión **implícita** y **explícita**. Nombrá un caso donde la implícita te traiciona.

**Ej. 15: 🐉 Jefe: reporte de clientes**
Para cada cliente: nombre con `INITCAP`, ciudad, estado, teléfono con el formato `(415) 555-1234` (usando `area_code` y `phone_number`), y límite de crédito con formato moneda; si el límite es nulo, `'SIN LIMITE'`. 💀 Pista: no podés poner un texto en una columna numérica; pensá en qué orden convertir.

---

## Nivel 3: Joins

**Ej. 16:** Apellido del empleado, nombre de su departamento y ciudad (`regional_group`). Hacelo de las dos formas: con join en el `WHERE` (estilo Oracle) y con `JOIN ... ON`. ✅ 32 filas. 📜 ¿Cuántos joins como mínimo necesitás con 3 tablas? ¿Qué pasa si te olvidás uno?

**Ej. 17:** 💀 Ejecutá `SELECT COUNT(*) FROM employee, department;` y explicá el número que da (352).

**Ej. 18:** Repetí el ej. 16 con `NATURAL JOIN` y con `JOIN ... USING`. 💀 ¿Qué pasa si querés escribir `e.department_id` cuando usás `USING (department_id)`?

**Ej. 19:** Todos los departamentos con la cantidad de empleados, **incluyendo los que no tienen ninguno**. Hacelo con `LEFT JOIN` y con `(+)`. ✅ 11 filas, el 40 (OPERATIONS) con 0. 💀 ¿Por qué `COUNT(*)` te da 1 en el depto 40 y `COUNT(e.employee_id)` te da 0?

**Ej. 20:** Self join: apellido del empleado y apellido de su jefe. ✅ 31 filas. Después hacé que aparezca KING con el jefe `'(sin jefe)'`. ✅ 32 filas.

**Ej. 21:** Non-equijoin: cada empleado con su `grade_id` según `SALARY_GRADE`. ✅ Grados 1 a 5 con 6, 9, 5, 11 y 1 empleados. Después contá cuántos hay por grado.

**Ej. 22:** Para la orden 610: fecha, nombre del cliente y, por cada ítem, la descripción del producto, la cantidad, el precio real y el total. (4 tablas.)

**Ej. 23: 🐉 Jefe: los cuatro outer joins**
Con `EMPLOYEE` y `DEPARTMENT`:
1. `LEFT OUTER JOIN` (todos los empleados).
2. `RIGHT OUTER JOIN` (todos los departamentos).
3. `FULL OUTER JOIN`.
4. El mismo FULL pero con la sintaxis vieja `(+)`. Pista: no existe `(+)` de los dos lados; el apunte usa `UNION`.

📜 ¿Por qué hay que poner el `(+)` "del lado donde pueden aparecer nulos"?

### ⚔️ Side quests: Gremio
- **G1:** Cada aventurero con su clase y su gremio, **incluidos los que no tienen gremio** (mostrá `'(lobo solitario)'`). ✅ 26 filas.
- **G2:** El rango (`RANGO.titulo`) de cada aventurero según su nivel. ✅ NOVATO 5, VETERANO 12, HEROE 6, LEYENDA 3.
- **G3:** Aventurero y su mentor (self join). Después, el **árbol completo** con `CONNECT BY` e indentación con `LPAD` (es extra, no está en el apunte, pero está buenísimo para entender la recursión).
- **G4:** Ciudades sin gremio, gremios sin miembros y clases que nadie usa: tres consultas, cada una con un outer join **y** otra versión con `NOT EXISTS`. ✅ Islas Sal · Compania del Grifo Roto · DRUIDA.

---

## Nivel 4: Grupos y subconsultas

**Ej. 24:** Por departamento: cantidad de empleados, salario promedio, máximo y mínimo. Ordenado por promedio descendente.

**Ej. 25:** Lo mismo, pero solo los departamentos con promedio **mayor a 2000**. ✅ 4 deptos (10, 12, 14, 20). 💀 Ejecutá primero la versión con `WHERE AVG(salary) > 2000` y leé el error.

**Ej. 26:** 🎲 `AVG(commission)` contra `AVG(NVL(commission, 0))`. ✅ 670 contra 209.375. 📜 ¿Cuál es "el promedio de comisión de la empresa"? Depende de la pregunta: justificá.

**Ej. 27:** 💀 Encontrá el error sin ejecutar y después corregilo:
```sql
SELECT department_id, job_id, SUM(salary) FROM employee GROUP BY department_id;
```

**Ej. 28:** 🏛️ Clientes que generaron **más de 5 órdenes** (nombre y cantidad). ✅ 5 clientes (201, 202, 204, 206, 208).

**Ej. 29:** El o los empleados contratados más recientemente. ✅ MURRAY (17-MAR-2006). Hacelo con subconsulta. 🎲 ¿Por qué no alcanza con `ORDER BY hire_date DESC` y quedarse con la primera?

**Ej. 30:** 🏛️ Subconsulta **sincronizada** (correlacionada): empleados que ganan más que el promedio **de su propio departamento**. ✅ 11 filas. 📜 ¿Cuántas veces se ejecuta la subconsulta?

**Ej. 31:** Productos que **nunca se vendieron**. Resolvelo con `NOT IN`, con `NOT EXISTS` y con `LEFT JOIN ... IS NULL`. ✅ 2 productos (105126, 105128). 💀 Investigá: ¿qué pasaría con `NOT IN` si la subconsulta devolviera un `NULL`? Probalo con `WHERE 1 NOT IN (2, NULL)`.

**Ej. 32:** Los 5 productos más caros según su precio de lista **vigente** (`END_DATE IS NULL`). Hacelo con `FETCH FIRST 5 ROWS ONLY` y con `ROWNUM`. 💀 ¿Por qué `WHERE ROWNUM <= 5 ORDER BY ...` está mal? ✅ Arranca con DUNK BASKETBALL PROFESSIONAL (58.3).

### ⚔️ Side quests
- **G5:** Oro total y promedio de cada gremio (todos los gremios). 🎲 ¿Coinciden `AVG(oro)` y `AVG(NVL(oro, 0))` en Escudos de Hierro? ✅ 4850 contra 4041.67: hay un aventurero con oro nulo.
- **G6:** Precio **vigente** de cada objeto. Después, los objetos sin ningún precio y los que nunca aparecieron en un botín. ✅ Sin precio: Escudo de torre. Nunca saqueados: Anillo de los tres deseos y Escudo de torre.
- **G7:** Por gremio, cuántas misiones hay COMPLETADAS, FALLIDAS y ABIERTAS, cada estado en **una columna** (`SUM(CASE ...)`). ✅ Escudos de Hierro 6/1/0.
- **G8:** Aventureros que **nunca** participaron en una misión. ✅ Bolg y Galen. 💀 Buscá a "Thorin" por nombre: ¿cuántos hay? Tenelo en cuenta para la U4 (`TOO_MANY_ROWS`).

---

## Nivel 5: DDL y constraints

**Ej. 33:** 📜 Nombrá los 5 tipos de constraint y decí cuáles se pueden definir a nivel de columna y cuáles solo a nivel de tabla.

**Ej. 34:** Creá `EMP_BACKUP` como copia de los empleados del depto 30 usando `CREATE TABLE ... AS SELECT`. 🎲 ¿Se copian las constraints? Verificalo en `USER_CONSTRAINTS`.

**Ej. 35:** Sobre `EMP_BACKUP`: agregá una columna `email VARCHAR2(50)`, completala con `LOWER(first_name) || '.' || LOWER(last_name) || '@empresa.com'`, agregale un `UNIQUE` y después borrá la tabla.

**Ej. 36: 🐉 Jefe: DIRECTIVOS**
Creá la tabla `DIRECTIVOS` con estas reglas, poniéndole **nombre** a cada constraint:
- `emp_no` NUMBER(4), clave primaria.
- `apellido` VARCHAR2(16), obligatorio.
- `oficio` VARCHAR2(10): solo puede ser DIRECTOR, GERENTE o PRESIDENTE.
- `fecha_alt` DATE, por defecto la fecha del día.
- `nro_documento` NUMBER(8), obligatorio y sin repetirse.
- `salario` NUMBER(9), obligatorio.
- `adicionales` NUMBER(9), por defecto 0, y nunca más del 60 % del salario (pensá si va a nivel columna o tabla).
- `department_id` NUMBER(2), FK a `DEPARTMENT`.

Después **rompé cada constraint a propósito**, con un INSERT por constraint, y anotá el código de error: ORA-00001, ORA-01400, ORA-02290, ORA-02291. Por último, intentá borrar un departamento que tenga un directivo (ORA-02292).
📜 ¿Qué diferencia hay entre ORA-02291 y ORA-02292?
