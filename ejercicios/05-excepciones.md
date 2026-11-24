# 05 · Manejo de excepciones (Unidad 4)

Apunte: *04 - Excepciones*.

Los tres tipos, de memoria:

| Tipo | ¿Se declara? | ¿Quién la lanza? | Ejemplo |
|---|---|---|---|
| Predefinida | No | Oracle | `NO_DATA_FOUND`, `TOO_MANY_ROWS`, `DUP_VAL_ON_INDEX`, `ZERO_DIVIDE`, `VALUE_ERROR`, `INVALID_NUMBER`, `CURSOR_ALREADY_OPEN`, `INVALID_CURSOR` |
| No predefinida | Sí + `PRAGMA EXCEPTION_INIT(e, -NNNN)` | Oracle | ORA-02292 (FK hija), ORA-02291 (FK padre), ORA-01400 (NOT NULL) |
| Definida por el usuario | Sí | Vos, con `RAISE` | `e_dpto_invalido` |

Y además: `RAISE_APPLICATION_ERROR(-20000..-20999, 'mensaje')`, `SQLCODE` y `SQLERRM`.

---

## Parte A: Actividad Excepciones de la cátedra 🏛️

**Ej. 1:** Mostrá el nombre del departamento 10 contemplando las excepciones posibles. Probalo también con el 99.

**Ej. 2:** Insertá un producto nuevo (id y descripción con `&`), contemplando las excepciones. Probá con un id que ya existe (`DUP_VAL_ON_INDEX`) y con una descripción de 40 caracteres. 🎲 ¿Qué excepción salta con la descripción larga?

💀 Tu versión de la cursada no compilaba: `... || v_description '. Con id: ' || ...`. Encontrá el error.

**Ej. 3:** Pedí nombre y apellido y mostrá el `employee_id`. Contemplá `NO_DATA_FOUND`, `TOO_MANY_ROWS` y `OTHERS`.
💀 Tu versión de la cursada tenía tres problemas: `&v_emp_name` sin comillas, `dbms_output.putline` (sin el guion bajo) y que **nunca imprimía el id**. Rehacelo bien. Para forzar un `TOO_MANY_ROWS` en BDEMOBLD no hay dos empleados con el mismo nombre y apellido, así que buscá solo por apellido con `LIKE '&ape%'` e ingresá `S`.

**Ej. 4:** Pedí un id y mostrá nombre y apellido. Creá una excepción **asociada con PRAGMA** para el caso en que el id ingresado no respete el tipo de la columna. 🎲 Probá ingresar `12345` (la columna es NUMBER(4)) y `abc`. ¿Saltan los mismos errores? ¿En qué momento salta cada uno: al asignar o en el SELECT? 📜 ¿-6502 es VALUE_ERROR? ¿Entonces para qué sirve el PRAGMA en este caso?

**Ej. 5:** Actualizá nombre y apellido de un empleado según su id. Si el UPDATE no encuentra a nadie, **cancelá con error** (`RAISE_APPLICATION_ERROR`). 📜 ¿Qué diferencia hay entre "cancelar por error" y mostrar un mensaje con DBMS_OUTPUT? ¿Qué ve el que llamó al bloque en cada caso?

**Ej. 6:** Eliminar el departamento 10: ¿se puede? ¿por qué? Hacé un bloque que lo intente y, si falla por la FK, cancele con un mensaje claro: `'No se puede borrar el depto 10: tiene empleados asignados'`.
💀 Tu versión de la cursada usaba `RAISE_APPLICATION_ERROR(-20000002, ...)`. ¿Por qué ese número es inválido? ¿Y por qué tu bloque **nunca llegaba** a ese IF?
Pista: declará `e_hijos EXCEPTION; PRAGMA EXCEPTION_INIT(e_hijos, -2292);`.

---

## Parte B: Más allá de la guía

**Ej. 7: SQLCODE y SQLERRM.** Hacé un bloque que provoque, en sub-bloques separados, `ZERO_DIVIDE`, `VALUE_ERROR` (asignar 'abc' a un NUMBER), `INVALID_NUMBER` (`TO_NUMBER('abc')` **dentro de un SELECT**) y `DUP_VAL_ON_INDEX`. Cada sub-bloque atrapa con `WHEN OTHERS` y muestra `SQLCODE` y `SQLERRM`. 📜 ¿Por qué 'abc' → NUMBER da errores distintos en PL/SQL y en SQL?

**Ej. 8:** Excepción de usuario con `RAISE`: pedí un `employee_id` y un porcentaje de aumento. Si el porcentaje es mayor a 30, lanzá `e_aumento_excesivo`; si el empleado es el PRESIDENT, lanzá `e_no_se_toca`. Manejá cada una con su mensaje, y `NO_DATA_FOUND` también.

**Ej. 9: 🐉 Jefe del día 11: propagación** 🎲
Predecí **exactamente** qué se imprime y después ejecutá:
```sql
DECLARE
  e_a EXCEPTION;
  e_b EXCEPTION;
BEGIN
  DBMS_OUTPUT.PUT_LINE('1');
  BEGIN
    DBMS_OUTPUT.PUT_LINE('2');
    RAISE e_a;
    DBMS_OUTPUT.PUT_LINE('3');
  EXCEPTION
    WHEN e_a THEN
      DBMS_OUTPUT.PUT_LINE('4');
      RAISE e_b;
  END;
  DBMS_OUTPUT.PUT_LINE('5');
EXCEPTION
  WHEN e_a THEN DBMS_OUTPUT.PUT_LINE('6');
  WHEN e_b THEN DBMS_OUTPUT.PUT_LINE('7');
END;
/
```
Después hacé 3 variantes cambiando una sola línea cada vez y predecí de nuevo: (a) el handler interno hace `RAISE;` en lugar de `RAISE e_b`; (b) el handler interno no hace ningún RAISE; (c) el bloque externo no tiene `WHEN e_b`. 📜 Regla: ¿a dónde va una excepción que no se atrapa en el bloque donde ocurre? ¿Y una que ocurre **dentro** de la sección EXCEPTION?

**Ej. 10:** 💀 ¿Por qué esto es mala práctica? Reescribilo bien.
```sql
EXCEPTION
  WHEN OTHERS THEN NULL;
```

**Ej. 11:** 📜 ¿Qué pasa con las filas modificadas antes de que salte una excepción no manejada en un bloque anónimo? ¿Y si la manejás? Probalo con un UPDATE seguido de un `1/0`.

---

## Parte C: ⚔️ Gremio

**G1:** Pedí el **nombre** de un aventurero y mostrá su ficha. Probá con "Thorin" (TOO_MANY_ROWS: mostrá los dos Thorin con sus apodos usando un cursor dentro del handler), con "Gandalf" (NO_DATA_FOUND) y con "Seraphine".

**G2: Lanzar hechizo.** Pedí un aventurero y un costo de HP. Si no es MAGO ni CLERIGO: `e_no_es_lanzador`. Si está muerto (hp = 0): `e_esta_muerto`. Si el costo lo deja en negativo, dejá que salte el CHECK de la tabla (`aventurero_hp_ck`, ORA-02290) y atrapalo con PRAGMA como `e_sin_energia`. Si todo va bien, descontá el HP.

**G3: 🐉 Integración.** Bloque que da de alta una misión (id, título, gremio, dificultad, recompensa) con estas validaciones y **un handler para cada caso**:
- el gremio no existe (ORA-02291 con PRAGMA),
- la dificultad fuera de 1..5 (ORA-02290 con PRAGMA),
- el id duplicado (`DUP_VAL_ON_INDEX`),
- la recompensa menor que `dificultad * 200` (excepción de usuario),
- cualquier otro error: `RAISE_APPLICATION_ERROR(-20099, 'Error inesperado: ' || SQLERRM)`.
