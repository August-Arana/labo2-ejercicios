# 06 · Procedimientos y funciones (Unidad 5)

Apuntes: *05 - Procedimientos y funciones en la base de datos* y *Material adicional*.

Checklist de herramientas:
- Compilar: `CREATE OR REPLACE PROCEDURE ... / ` y si hay errores, `SHOW ERRORS` (SQLcl/SQL Developer) o `SELECT * FROM user_errors WHERE name = 'X';`.
- Ver el código guardado: `SELECT text FROM user_source WHERE name = 'X' ORDER BY line;`
- Estado: `SELECT object_name, object_type, status FROM user_objects WHERE object_type IN ('PROCEDURE','FUNCTION');`
- Ejecutar: `EXEC proc(1, 2);` o dentro de un bloque `BEGIN proc(1, 2); END;`
- Borrar: `DROP PROCEDURE x;` / `DROP FUNCTION x;`

📜 Tabla del apunte, de memoria: bloque anónimo contra procedimiento contra función (nombre, compilación, almacenamiento, invocación, retorno, parámetros).

---

## Parte A: Procedimientos

**Ej. 1:** `saludar`: sin parámetros, imprime un mensaje. Ejecutalo con `EXEC` y desde un bloque anónimo. Buscalo en el explorador de objetos de SQL Developer.

**Ej. 2:** 💀 Creá a propósito un procedimiento con un error de sintaxis. 🎲 ¿Se crea o no? Mirá su `status` en `USER_OBJECTS`, leé `SHOW ERRORS`, y después intentá ejecutarlo. (El apunte lo menciona: "se crea, pero con una cruz roja".)

**Ej. 3:** `sumar(p_a IN NUMBER, p_b IN NUMBER, p_total OUT NUMBER)`. Llamalo desde un bloque y mostrá el total. 🎲 ¿Qué pasa si dentro del procedimiento intentás `p_a := 0;`? ¿Y si lo llamás `sumar(15, 25, 40)`?

**Ej. 4:** `al_cubo(p_n IN OUT NUMBER)`: recibe un número y lo devuelve al cubo **en el mismo parámetro**. 📜 ¿Cuándo usarías IN OUT en lugar de un IN y un OUT?

**Ej. 5:** 🏛️ `aumentar_salarios(p_depto, p_funcion, p_porcentaje)`: aumenta el salario de los empleados de ese departamento con esa función (`JOB.function`). Si no hay ninguno: `RAISE_APPLICATION_ERROR(-20001, ...)`. Si hay, informá cuántos actualizó. Llamalo desde un bloque que **atrape** ese -20001 con PRAGMA y muestre un mensaje amable.

**Ej. 6: 🐉 Jefe del día 12: `alta_precio`** 🏛️
`alta_precio(p_product_id price.product_id%TYPE, p_list_price price.list_price%TYPE, p_min_price price.min_price%TYPE)`:
1. Cierra el precio vigente del producto (`END_DATE = SYSDATE`). Usá `SQL%ROWCOUNT` para saber si había uno.
2. Inserta el nuevo precio con `START_DATE = SYSDATE` y `END_DATE` nulo.
3. Si el producto no existe (ORA-02291 en el INSERT), atrapalo con PRAGMA y cancelá con `-20010`.
4. 🎲 Si `p_min_price > p_list_price`, ¿qué constraint de PRICE salta? Atrapala también.
5. Decidí si el procedimiento hace `COMMIT` o lo deja al que lo llama. 📜 Justificá: ¿quién debería controlar la transacción?

**Ej. 7: Notación de parámetros.** Llamá a `alta_precio` con notación posicional, nombrada (`p_list_price => 10`) y mixta. Agregale a un procedimiento un parámetro con `DEFAULT` y llamalo omitiéndolo.

---

## Parte B: Funciones

**Ej. 8:** `fn_sumar(p_a, p_b) RETURN NUMBER`. Usala: (a) asignándola a una variable en un bloque, (b) en un `SELECT fn_sumar(salary, commission) FROM employee`. 🎲 ¿Qué devuelve para los que tienen comisión nula?

**Ej. 9:** 🏛️ `fn_id_producto(p_desc product.description%TYPE) RETURN product.product_id%TYPE`: busca el id por descripción. Manejo de excepciones: `NO_DATA_FOUND` → `RAISE_APPLICATION_ERROR(-20020, ...)`, `TOO_MANY_ROWS` → `-20021`. 📜 ¿Por qué en una función conviene cancelar con error en lugar de devolver -1 o NULL?

**Ej. 10:** 🏛️ `fn_proximo_producto RETURN NUMBER`: devuelve `MAX(product_id) + 1`. Después creá `SEQUENCE seq_producto START WITH ...` y una función `fn_proximo_producto_seq`. 📜 Compará las dos.

**Ej. 11:** `fn_grado(p_salary NUMBER) RETURN NUMBER`: devuelve el `grade_id` de `SALARY_GRADE`. Usala en un SELECT sobre `EMPLOYEE` y compará con el non-equijoin del ej. 21 de la U1.

**Ej. 12:** 💀 Creá `fn_sin_return(p NUMBER) RETURN NUMBER` con un IF que solo hace `RETURN` cuando `p > 0`. Compila. Llamala con -1. ¿Qué error da (ORA-06503)?

**Ej. 13:** 💀 Una función que hace un UPDATE adentro. Usala en un `SELECT ... FROM dual`. ¿Qué error da (ORA-14551)? 📜 ¿Por qué Oracle no te deja? ¿Y desde un bloque PL/SQL sí funciona?

**Ej. 14: Procedimiento que usa función que usa cursor.** `informe_cliente(p_customer_id)`: imprime nombre del cliente, cantidad de órdenes, total gastado (una función `fn_total_cliente`) y la orden más cara. Si el cliente no existe, error -20030. Si existe pero no tiene órdenes, informalo sin error.

---

## Parte C: ⚔️ Gremio

Creá una secuencia `seq_bitacora` para llenar `BITACORA`.

**G1:** `fn_rango(p_nivel) RETURN VARCHAR2`: devuelve el título del rango. Usala en `SELECT nombre, nivel, fn_rango(nivel) FROM aventurero`.

**G2:** `registrar(p_evento VARCHAR2)`: inserta en `BITACORA` con la secuencia. A partir de acá, **todo** procedimiento del gremio que modifique datos llama a `registrar`.

**G3:** `subir_nivel(p_aventurero_id, p_niveles DEFAULT 1)`: sube el nivel (máximo 20), aumenta `hp_max` en `dado_golpe` de su clase por cada nivel y cura al máximo. Si ya era nivel 20: error -20101. Registrá en bitácora `"Pip subio de 3 a 4"`.

**G4:** `inscribir(p_mision_id, p_aventurero_id, p_rol)` con validaciones, cada una con su error -201xx:
- la misión debe estar ABIERTA,
- el aventurero debe estar vivo y pertenecer al gremio de la misión,
- no puede haber dos LIDER en la misma misión,
- la combinación no puede repetirse (PK de PARTICIPACION → `DUP_VAL_ON_INDEX`).

**G5: 🐉 Jefe del día 13: el tablón de misiones**
`cerrar_mision(p_mision_id, p_exito BOOLEAN)`:
- Si `p_exito`: estado COMPLETADA, `fecha_cierre = SYSDATE`, reparte la recompensa entre los participantes (reusá el ej. G2 de la U3) y cada participante sube 1 nivel (llamá a `subir_nivel`).
- Si no: estado FALLIDA y cada participante pierde el 25 % de su hp actual (redondeá hacia abajo).
- Todo queda en bitácora.
- Si la misión no estaba ABIERTA: error. Si no tiene participantes: error.
- Probalo con la misión 1024 y mirá la bitácora. Después `lab reset gremio`.

📜 `BOOLEAN` como parámetro: ¿podés llamar a este procedimiento desde SQL Developer con `EXEC cerrar_mision(1024, TRUE)`? ¿Y a una función con un parámetro BOOLEAN desde un SELECT? (Probalo: Oracle 23ai trae novedades acá.)
