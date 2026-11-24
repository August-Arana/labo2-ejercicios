# 04 · Interacción con la BD y cursores (Unidad 3)

Apuntes: *03 - Cursores* y *03 - Sentencias DML*. Material de repaso de la cursada: `repaso_cursores.sql`.
⚠️ Varios ejercicios hacen UPDATE/DELETE: cerrá cada uno con `ROLLBACK` (o `lab reset` al final).

---

## Parte A: SELECT INTO, DML en bloques y cursores implícitos

### 🏛️ Ejercitación 2, ej. 1 a 5

**Ej. 1:** Pedí un número de empleado y aumentale la **comisión** según su sueldo:
- sueldo < 1300 → +10 %
- 1300 ≤ sueldo ≤ 1500 → +15 %
- sueldo > 1500 → +20 %
- La comisión puede ser NULL.
- Si el empleado no existe, mostrá un mensaje de error.

💀 Tu solución de la cursada tiene **tres bugs**. Encontralos antes de escribir la tuya:
1. Usaba `IF SQL%FOUND` después del `SELECT INTO` para detectar "no existe". ¿Qué pasa realmente cuando no existe? (Probá con el empleado 1.)
2. `ELSIF v_sueldo > 1300 AND v_sueldo < 1500`: ¿qué le pasa a alguien que gana exactamente 1300 o 1500?
3. Si la comisión es NULL, no hacía nada. ¿Qué debería pasar? (Decidí una regla razonable, por ejemplo que el aumento se calcule sobre 0 o sobre el sueldo, y justificala en un comentario.)

**Ej. 2:** Lo mismo, pero para **todos** los empleados en una pasada, informando cuántos se actualizaron con cada criterio. Hacelo con **tres UPDATE** y `SQL%ROWCOUNT` después de cada uno. 🎲 ¿Cuánto da la suma de los tres? ¿Por qué 32?

**Ej. 3:** Pedí un `job_id` y borralo de `JOB`. Informá con `SQL%ROWCOUNT` si se borró o si no existía. 💀 Probá con 667 (CLERK). ¿Qué pasa? (Lo manejás bien en la U4.)

**Ej. 4:** Insertá un cargo nuevo:
- `job_id` = `MAX(job_id) + 1` (guardalo primero en una variable).
- `function` desde `'&cargo'` (por ejemplo "Becario"), **guardado en mayúsculas**.
- `COMMIT`. Después consultá `JOB` desde SQL Developer.
- 📜 ¿Qué problema tiene `MAX + 1` si dos usuarios ejecutan esto al mismo tiempo? ¿Qué objeto de Oracle lo resuelve?

**Ej. 5: 🐉 Jefe del día 8: repricing**
Pedí un producto. Contá cuántas veces se vendió (filas en `ITEM`) y bajá su precio de lista **vigente** (`END_DATE IS NULL`):
- nunca se vendió → −50 %
- 1 o 2 veces → −10 %
- más de 2 veces → −20 %

Mostrá el precio anterior y el nuevo. 🎲 Probá con 105126 (nunca vendido) y con 100860. 💀 ¿Qué pasa si el producto no tiene precio vigente?

### Extras
**Ej. 6:** 🎲 Del repaso de la cursada: en un bloque, `SELECT COUNT(*) INTO v_cant FROM employee WHERE department_id = 95;` y después `SQL%ROWCOUNT`. ¿Cuánto vale `v_cant`? ¿Y `SQL%ROWCOUNT`? 📜 ¿Por qué no son iguales?

**Ej. 7:** 📜 Completá la tabla de memoria:

| Atributo | Después de un UPDATE que tocó 3 filas | Después de un UPDATE que no tocó ninguna | Después de un SELECT INTO exitoso |
|---|---|---|---|
| `SQL%FOUND` | | | |
| `SQL%NOTFOUND` | | | |
| `SQL%ROWCOUNT` | | | |
| `SQL%ISOPEN` | | | |

---

## Parte B: Cursores explícitos

### 🏛️ Ejercitación 2, ej. 6 a 10

**Ej. 8 (cátedra 6):** Con un cursor sobre `SALES_ORDER` + `ITEM`: listado de todas las órdenes con `order_id`, `order_date` y `product_id`. Hacelo **dos veces**: con `OPEN/FETCH/CLOSE` + `LOOP` y con `FOR rec IN cursor LOOP`. 📜 ¿Qué te ahorra el FOR?

**Ej. 9 (cátedra 7):** Pedí un código de cliente y mostrá número y fecha de cada orden suya, con la descripción de los productos ordenados (`SALES_ORDER`, `ITEM`, `PRODUCT`). Usá un **cursor con parámetro** (`CURSOR c_ordenes(p_cliente NUMBER)`). ✅ El cliente 201 tiene 10 órdenes. Si el cliente no tiene órdenes, informalo.

**Ej. 10 (cátedra 8):** Candidatos a aumento:
- Pedí un `department_id`.
- Traé apellido, nombre y salario de los empleados de ese depto cuyo cargo sea `'CLERK'`, ordenados por apellido.
- salario < 1000 → `APELLIDO, Nombre candidato a un aumento`.
- salario ≥ 1000 → `APELLIDO, Nombre no es candidato a un aumento`.
- Si en el depto no hay CLERK: `El departamento X no tiene candidatos a aumento de salario`.

✅ Hay CLERK en los deptos 10, 12, 13, 20, 23 y 30. Probá con el 20 (dos CLERK) y con el 14 (ninguno). 💀 Fijate que el cargo es `JOB.function`, no `JOB_ID`: necesitás un join.

**Ej. 11 (cátedra 9):** Los 5 productos más caros (precio vigente). Hacelo con un cursor y un contador que corte en 5 (`EXIT WHEN c%ROWCOUNT > 5` o similar). 🎲 ¿Qué devuelve `%ROWCOUNT` en un cursor explícito?

**Ej. 12 (cátedra 10): 🐉 Jefe del día 9: dos cursores**
Con un cursor de departamentos y otro **parametrizado** de empleados, generá exactamente este formato (ordenado por depto y por nombre del empleado):
```
10 - ACCOUNTING - NEW YORK
     CLARK,CAROL 08-Aug-2004
     KING,FRANCIS 16-Jan-2005
     MILLER,BARBARA 24-Mar-2005
12 - RESEARCH - NEW YORK
     ALBERTS,CHRIS 05-Jun-2004
     ...
```
(La guía muestra fechas de 1985; los datos actuales son de 2004 a 2006, así que vale el formato, no la fecha.) Para el depto 40, que no tiene empleados, mostrá `     (sin empleados)`.

### Extras
**Ej. 13:** 💀 Encontrá los errores sin ejecutar:
```sql
DECLARE
  CURSOR c_emp IS SELECT last_name, salary FROM employee WHERE department_id = 30;
  v_nombre employee.last_name%TYPE;
  v_sal    employee.salary%TYPE;
BEGIN
  LOOP
    FETCH c_emp INTO v_nombre, v_sal;
    DBMS_OUTPUT.PUT_LINE(v_nombre || ' ' || v_sal);
    EXIT WHEN c_emp%NOTFOUND;
  END LOOP;
END;
/
```
(Hay tres: uno da error y dos son de lógica.)

**Ej. 14:** Cursor con `%ROWTYPE` del cursor: `rec c_emp%ROWTYPE`. Recorré los empleados con columnas calculadas en el SELECT (`salary * 12 AS anual`). 💀 ¿Qué pasa si la columna calculada no tiene alias?

---

## Parte C: Avanzado + ⚔️ Gremio

**Ej. 15: FOR UPDATE / WHERE CURRENT OF.** Recorré los SALESPERSON con `FOR UPDATE OF commission` y a cada uno subile la comisión 50 usando `WHERE CURRENT OF`. 📜 ¿Qué bloquea `FOR UPDATE` y hasta cuándo?

**G1: Planilla del gremio.** Con dos cursores anidados (gremios → miembros), mostrá cada gremio con su ciudad, sus miembros ordenados por nivel descendente con su rango, y al final de cada gremio el total de oro (con NVL) y la cantidad de miembros. Los gremios sin miembros deben aparecer.

**G2: Cobro de recompensas.** Por cada misión COMPLETADA, repartí la `recompensa` en partes iguales entre sus participantes (sumándola a `oro`; el oro nulo cuenta como 0). Informá cuánto cobró cada uno por misión y el total repartido. ✅ Para controlar: el total repartido tiene que dar 13675 (la suma de las recompensas de las misiones completadas).

**G3: 🐉 Jefe del día 10: el reparto del botín**
Por cada misión COMPLETADA (cursor 1), recorré su botín (cursor 2 con parámetro) y asignale cada objeto a un participante (cursor 3 con parámetro):
- El **LIDER** elige primero: se queda con el objeto de mayor rareza (LEGENDARIA > EPICA > RARA > COMUN; si empatan, el de menor `nro`).
- El resto se reparte en ronda (round robin) entre los demás participantes.
- Como no existe una tabla de inventario, imprimí el reparto: `Misión 1003 - Recuperar el caliz robado: Hacha de batalla enana x1 → Vex (LIDER)`.
- Al final: cuántos objetos recibió cada aventurero en total (pista: acumulalo en una variable de tipo `TABLE OF NUMBER INDEX BY PLS_INTEGER`, que se ve en la U6; si todavía no la viste, hacelo con una consulta al final).
