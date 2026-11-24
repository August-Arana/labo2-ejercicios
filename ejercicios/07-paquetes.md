# 07 · Paquetes (Unidad 6)

Apunte: *06 - Paquetes*.

Orden de compilación: **primero la SPEC y después el BODY.** Lo que está en la spec es público; lo que está solo en el body es privado.

```sql
CREATE OR REPLACE PACKAGE pkg_x IS        -- spec
  PROCEDURE p(a NUMBER);
  FUNCTION  f RETURN NUMBER;
END pkg_x;
/
CREATE OR REPLACE PACKAGE BODY pkg_x IS   -- body
  PROCEDURE p(a NUMBER) IS BEGIN NULL; END p;
  FUNCTION  f RETURN NUMBER IS BEGIN RETURN 1; END f;
BEGIN
  NULL;   -- bloque one-time-only (opcional): corre una vez por sesión
END pkg_x;
/
```

---

## Parte A: Spec, body, público y privado, sobrecarga

**Ej. 1:** 🏛️ Reproducí el paquete `PKG_UTIL` del apunte:
- `fn_sumar(a, b) RETURN NUMBER`
- `fn_max_producto RETURN NUMBER` (máximo `product_id`)
- `al_cubo(p IN OUT NUMBER)`
- `saludar` (imprime un mensaje)

Llamá a cada uno desde un bloque: `pkg_util.fn_sumar(1, 2)`.

**Ej. 2:** 🎲 Compilá **solo el body** de un paquete nuevo sin spec. ¿Qué error da? Después compilá la spec, mirá el estado del body (`USER_OBJECTS`) y recompilalo: `ALTER PACKAGE pkg COMPILE BODY;`.

**Ej. 3: Privado.** Agregale a `PKG_UTIL` una función `fn_formatear(n NUMBER) RETURN VARCHAR2` que exista **solo en el body**, y usala desde `saludar`. 💀 Intentá llamar a `pkg_util.fn_formatear` desde afuera. ¿Qué error da? 💀 ¿Qué pasa si `saludar` está escrito **antes** que `fn_formatear` en el body? (Pista: *forward declaration*.)

**Ej. 4:** 🏛️ Sobrecarga en un **bloque anónimo**: tres procedimientos locales `mostrar` (sin parámetros, con un NUMBER, con un NUMBER y un VARCHAR2). Llamalos a los tres. 📜 ¿Por qué no podés hacer esto con tres `CREATE PROCEDURE mostrar` sueltos?

**Ej. 5:** 💀 Probá sobrecargas **inválidas** y anotá qué error da cada una y en qué momento (al compilar o al llamar):
- dos versiones que solo difieren en el nombre del parámetro,
- dos que solo difieren en el modo (IN contra OUT),
- `NUMBER` contra `INTEGER` (subtipos de la misma familia).

**Ej. 6: 🐉 Jefe del día 15: `PKG_PRODUCTOS`** 🏛️
- `alta(p_desc VARCHAR2, p_id NUMBER)`: **versión core**; inserta. `DUP_VAL_ON_INDEX` → error -20201.
- `alta(p_desc VARCHAR2)`: calcula el id con una función **privada** `fn_proximo_id` y llama a la versión core. **Sin repetir código** (el apunte muestra primero la versión "mala" que duplica el INSERT: no la copies).
- `baja(p_id NUMBER)`: borra el producto. Si tiene precios o ventas (ORA-02292), error -20202 explicando por qué.
- `precio_vigente(p_id NUMBER) RETURN NUMBER`: devuelve el precio vigente o NULL.
- `precio_vigente(p_desc VARCHAR2) RETURN NUMBER`: sobrecarga por descripción.
- Probá cada uno, incluidos los caminos de error.
- `DROP PACKAGE BODY pkg_productos;` → 🎲 ¿qué queda en `USER_OBJECTS`? ¿Se puede llamar algo? Después `DROP PACKAGE pkg_productos;`.

---

## Parte B: Estado, one-time-only y colecciones

**Ej. 7: Variables de paquete (estado de sesión).** `PKG_CONTADOR` con una variable **pública** `g_llamadas NUMBER := 0` en la spec y un procedimiento `tick` que la incrementa e imprime.
- Ejecutá `tick` 3 veces en la misma sesión. 🎲 ¿Qué imprime?
- Desde **otra** sesión (SQL Developer contra `lab sql`): ¿qué valor ve?
- Desde la **sesión 2** recompilá el body (`ALTER PACKAGE pkg_contador COMPILE BODY;`). Volvé a la **sesión 1** y ejecutá `tick`. 🎲 ¿Qué pasa? (ORA-04068.) ¿Y si lo ejecutás una segunda vez?
- 📜 El apunte dice "datos compartidos en memoria durante toda la sesión". ¿Compartidos con quién?

**Ej. 8: Colecciones a mano.** En un bloque anónimo:
```sql
TYPE t_nombres IS TABLE OF employee.last_name%TYPE INDEX BY PLS_INTEGER;
v t_nombres;
```
Cargá los apellidos del depto 30 usando el `employee_id` **como índice**. Recorrela con `FIRST` / `NEXT` (no con `FOR i IN 1..COUNT`: 🎲 ¿por qué fallaría?). Usá `EXISTS(7499)` y `COUNT`.

**Ej. 9: BULK COLLECT.** Lo mismo, pero con un `TYPE ... IS TABLE OF employee%ROWTYPE` (sin INDEX BY) cargado con `SELECT * BULK COLLECT INTO v FROM employee WHERE ... ORDER BY last_name`. 📜 Diferencia entre cargar con cursor y con BULK COLLECT (el apunte la explica: índice elegido por vos contra índice automático).

**Ej. 10: 🐉 Jefe del día 16: caché de departamentos** 🏛️
Adaptación de la "tabla dinámica de países" del apunte, con las tablas de BDEMOBLD:
- En el body de `PKG_DEPTOS`: un `TYPE tr_depto IS RECORD (department_id, name, regional_group, cant_empleados)`, una tabla de ese record y una variable privada `t_deptos`.
- **Bloque one-time-only** al final del body: carga `t_deptos` con `BULK COLLECT` desde `DEPARTMENT` + `LOCATION` + `EMPLOYEE` (outer join, `COUNT`), **ordenado por nombre**. Agregá un `DBMS_OUTPUT.PUT_LINE('cargando caché...')` para ver cuándo corre.
- `fn_cant_empleados(p_depto_id) RETURN NUMBER`: busca **en la colección**, no en la tabla.
- `fn_id_por_nombre(p_nombre, p_ciudad) RETURN NUMBER`: recorre con `FIRST`/`NEXT` y corta apenas se pasa alfabéticamente (como el `getPaisId` del apunte); si no existe, error -20001.
- `listar`: imprime la caché.
- 🎲 Llamá a dos funciones seguidas: ¿cuántas veces aparece "cargando caché..."? ¿Y en otra sesión?
- 💀 El `getPaisId` del apunte tiene un bug: `NOT T_countries.EXISTS(C_ID)` usa la variable equivocada, y además puede indexar una `fila` nula. Explicá el problema y escribilo bien.

---

## Parte C: ⚔️ `PKG_GREMIO`

Juntá lo que hiciste en la U5 (G1 a G5) en un paquete:
- **Público:** `inscribir`, `cerrar_mision`, `subir_nivel`, `fn_rango`, y la sobrecarga `ficha(p_id NUMBER)` / `ficha(p_nombre VARCHAR2)`.
- **Privado:** `registrar` (bitácora), `fn_dado_golpe(p_clase_id)`.
- **Estado:** `g_eventos_sesion NUMBER` (cuántos eventos registró esta sesión) y la función pública `fn_eventos_sesion`.
- **One-time-only:** cargar en una colección los rangos (`RANGO`), para que `fn_rango` no consulte la tabla.
- **Constantes públicas** en la spec: `c_nivel_max CONSTANT NUMBER := 20;` y los códigos de error (`c_err_mision_cerrada CONSTANT NUMBER := -20101;` …). 📜 ¿Por qué conviene tener los códigos de error en la spec?

Después borrá los procedimientos sueltos de la U5 (`DROP PROCEDURE ...`) y verificá en `USER_OBJECTS` que solo queda el paquete.
