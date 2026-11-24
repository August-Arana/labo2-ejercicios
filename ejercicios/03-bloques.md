# 03 · Bloques PL/SQL (Unidad 2)

Apuntes: *02 - Lenguaje procedural PL/SQL: Bloques*, *Características de las variables* y *Material adicional - Bloques*.

Recordatorios:
- Usá `&variable` para pedir datos (funciona en SQL Developer, SQLcl y nvim). Para textos: `'&nombre'`.
- Terminá cada bloque con `/` en una línea sola.
- Nomenclatura de la cátedra: `v_` variable, `c_` constante, `p_` parámetro, `cur_` cursor, `rec_` registro, `e_` excepción.

---

## Parte A: Guía de la cátedra 🏛️

Ya hiciste esta guía en la cursada con `:variables`. Rehacela **desde cero** con `&` y sin mirar la versión vieja.

**Ej. 1:** 🎲 ¿Cuáles de estas declaraciones son válidas? Primero respondé y después probalo en un bloque con `BEGIN NULL; END;`.
```sql
v_var          NUMBER(8,3);
v_a, v_b       NUMBER;
v_fec_ingreso  DATE := SYSDATE + 2;
v_nombre       VARCHAR2(30) NOT NULL;
v_logico       BOOLEAN DEFAULT 'TRUE';
```
💀 Tu respuesta de la cursada decía V, V, F, V, F. **Esa respuesta tiene tres errores.** Encontralos ejecutando y anotá el código PLS- de cada uno.

**Ej. 2:** Mostrá `Hola, soy <tu usuario de Oracle>` (pista: `USER`) y `Hoy es: 24 - Nov - 2026` con ese formato exacto (`TO_CHAR`).

**Ej. 3:** Pedí un número n y mostrá los números de 1 a n con un `FOR`.

**Ej. 4:** Igual que el 3, pero si el número es mayor a 12 mostrá `'El número es mayor a 12'`; si no, mostrá `i + 2*i - 3`.

**Ej. 5:** Los primeros n múltiplos de 3. Si n > 10, mostrá una advertencia y **terminá el bloque** sin imprimir nada más (probá `RETURN` dentro del bloque anónimo).

**Ej. 6:** Pedí una letra de la A a la E y después el nombre de un animal que empiece con esa letra. Validá: (a) que la letra esté en el rango, (b) que el animal **realmente** empiece con esa letra (`UPPER`, `SUBSTR`). Usá `CASE` en lugar de una cadena de `OR`.

**Ej. 7 y 8:** 💀 Los ejercicios del "ingresá 1 o 0 en cada vuelta del ciclo" **no se pueden hacer** en PL/SQL como lo pide el enunciado. 📜 Explicá por qué (pista: ¿cuándo reemplaza la herramienta las variables `&`? ¿Cuántas veces te pregunta si la misma `&x` aparece dos veces?). Después simulalo: pedí una sola cadena tipo `'1101110'` y recorrela con `SUBSTR` como si fueran los ingresos del usuario, cortando al primer 0 o a las 10 vueltas. Mostrá `'Programa finalizado por el usuario'` o `'... por alcanzar el máximo de iteraciones'`.

**Ej. 9:** Pedí dos números, restalos e indicá si el resultado es positivo, negativo o cero (`IF/ELSIF/ELSE`). Después hacelo con `CASE` como expresión: `v_cartel := CASE WHEN ... END;`.

**Ej. 10:** Pedí un apellido en una variable de tipo `employee.last_name%TYPE`. Mostralo 3 veces, salvo que sea "Perez", en cuyo caso mostralo una sola vez. 💀 ¿Qué pasa si ingresás `perez` en minúscula? Arreglalo.

**Ej. 11:** Nombre por defecto `'Pedro'`. Pedí edad y sueldo bruto; si la edad es menor a 18, pedí un nombre. Calculá la jubilación (17 %, como **constante**) y mostrá el nombre, la edad y el sueldo neto. 💀 ¿Qué pasa si querés asignarle un valor a la constante en el `BEGIN`?

---

## Parte B: Variables y tipos a fondo

**Ej. 12: `%TYPE` contra `%ROWTYPE`.** Declará `v_emp employee%ROWTYPE`, cargalo con `SELECT * INTO v_emp FROM employee WHERE employee_id = 7839;` y mostrá tres campos. 📜 ¿Qué ganás con `%TYPE`/`%ROWTYPE` si mañana alguien hace `ALTER TABLE employee MODIFY last_name VARCHAR2(40)`?

**Ej. 13: Alcance de variables (bloques anidados).** 🎲 Predecí la salida:
```sql
DECLARE
  v_x NUMBER := 10;
BEGIN
  DECLARE
    v_x NUMBER := 20;
    v_y NUMBER := 5;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('interno x=' || v_x || ' y=' || v_y);
  END;
  DBMS_OUTPUT.PUT_LINE('externo x=' || v_x);
  -- DBMS_OUTPUT.PUT_LINE('externo y=' || v_y);   -- 💀 descomentá y explicá
END;
/
```
Bonus: ¿cómo accedés a la `v_x` externa desde el bloque interno? (pista: etiquetas `<<externo>>`).

**Ej. 14: Los tres loops.** Mostrá la tabla del 7 (7×1 a 7×10) tres veces: con `LOOP ... EXIT WHEN`, con `WHILE` y con `FOR`. Después recorré con `FOR i IN REVERSE 1..10`.

**Ej. 15: 🎲 NULL en condiciones.**
```sql
DECLARE
  v_a NUMBER;          -- NULL
BEGIN
  IF v_a = NULL   THEN DBMS_OUTPUT.PUT_LINE('1'); END IF;
  IF v_a IS NULL  THEN DBMS_OUTPUT.PUT_LINE('2'); END IF;
  IF NOT (v_a > 5) THEN DBMS_OUTPUT.PUT_LINE('3'); ELSE DBMS_OUTPUT.PUT_LINE('4'); END IF;
  IF v_a + 1 > 0  THEN DBMS_OUTPUT.PUT_LINE('5'); ELSE DBMS_OUTPUT.PUT_LINE('6'); END IF;
END;
/
```
📜 Explicá la lógica de tres valores (TRUE, FALSE, NULL).

---

## Parte C: ⚔️ Side quests: Gremio

**G1: Tirada de dados.** Pedí `&cantidad` y `&caras` y tirá esos dados (`DBMS_RANDOM.VALUE(1, caras + 1)` con `TRUNC`). Mostrá cada tirada, el total, el máximo, y un mensaje si sale crítico (todas las tiradas con el máximo valor).

**G2: Ficha de personaje.** Pedí un `aventurero_id`, traé la fila a un `aventurero%ROWTYPE` y mostrá una ficha:
```
=== Seraphine "La Docta" ===
Raza: ELFA        Nivel: 19
HP: 90/90  [##########]
Oro: 22,000.00
```
La barra de HP tiene 10 caracteres y se llena en proporción (`RPAD`, `LPAD`). Si `oro` es nulo, mostrá `"bolsillos vacíos"`.

**G3: 🐉 Jefe: tirada de iniciativa.**
Pedí el id de dos aventureros. Para cada uno: tirada d20 + modificador, donde el modificador es `TRUNC(nivel / 4)`. Gana el mayor; si empatan, gana el de más nivel; si siguen empatados, se repite la tirada (`LOOP`) hasta 5 veces. Mostrá el relato de cada ronda. Usá `%TYPE`, una constante para el máximo de rondas, `CASE` y un `LOOP` con `EXIT WHEN`.
