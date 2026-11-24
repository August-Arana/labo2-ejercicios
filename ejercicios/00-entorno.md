# 00 · Entorno y modelo de datos

Objetivo: que el entorno deje de ser un tema y que conozcas las tablas de memoria.

## Parte A: Herramientas

### Ej. 1: Tres formas de ejecutar lo mismo
Creá `soluciones/00-entorno/ej01.sql` con esto:

```sql
SELECT department_id, name FROM department ORDER BY department_id;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hola desde PL/SQL');
END;
/
```

1. En **nvim**: `<espacio>lr`.
2. En **SQL Developer**: abrí el mismo archivo (File → Open) y probá **Ctrl+Enter** (sentencia bajo el cursor) y **F5** (todo como script).
3. En **SQLcl**: `lab sql` y después `@soluciones/00-entorno/ej01.sql`.

- 🎲 En SQL Developer: ¿por qué con F5 el `SELECT` sale como texto en "Script Output" y con Ctrl+Enter sale en una grilla?
- 💀 Borrá la `/` final y ejecutá con F5. ¿Qué pasa? ¿Y con Ctrl+Enter parado dentro del bloque?
- 💀 En SQL Developer, abrí un worksheet nuevo y ejecutá solo el bloque. ¿Ves el "Hola"? Buscá el panel **View → Dbms Output** y la diferencia con `SET SERVEROUTPUT ON`.

> Tip para SQL Developer: activá *Tools → Preferences → Environment → Automatically Reload Externally Modified Files*. Así podés editar en nvim y el archivo abierto en SQL Developer se actualiza solo.

### Ej. 2: Variables de sustitución contra variables bind
```sql
SELECT employee_id, last_name FROM employee WHERE department_id = &depto;
SELECT employee_id, last_name FROM employee WHERE last_name = '&apellido';
SELECT employee_id, last_name FROM employee WHERE department_id = :depto;
```
- 🎲 ¿Por qué `&apellido` va entre comillas y `&depto` no?
- Probá `&&depto` dos veces seguidas. ¿Qué cambia? ¿Cómo lo "olvidás"? (`UNDEFINE depto`)
- 💀 La tercera consulta (`:depto`) en SQL Developer te pide un valor. En SQLcl/nvim **no**. ¿Por qué? Tus ejercicios viejos de la U2 usaban `:variable`: en este repo usá siempre `&` para que funcionen en las dos herramientas.
- 📜 ¿Quién reemplaza el `&`: el motor Oracle o la herramienta cliente? ¿Y el `:`?

### Ej. 3: Explorar el diccionario de datos
Sin abrir el explorador de objetos, respondé con consultas:
1. ¿Qué tablas tenés? (`USER_TABLES`)
2. ¿Qué columnas y tipos tiene `EMPLOYEE`? (`DESC employee` y `USER_TAB_COLUMNS`)
3. ¿Qué constraints tiene `EMPLOYEE` y de qué tipo (P, R, C, U)? (`USER_CONSTRAINTS`)
4. ¿A qué tabla apunta cada FK de `EMPLOYEE`? (pista: `r_constraint_name`)
- 📜 ¿Qué es el diccionario de datos y por qué es útil en un examen?

## Parte B: El modelo BDEMOBLD

### Ej. 4: Dibujá el DER a mano 📝
En papel (o en `soluciones/00-entorno/der.md`) dibujá las 10 tablas con sus PK y FK:
`LOCATION, DEPARTMENT, JOB, EMPLOYEE, SALARY_GRADE, PRODUCT, PRICE, CUSTOMER, SALES_ORDER, ITEM`.

Preguntas que tenés que poder responder sin mirar:
- ¿Qué relación **recursiva** hay? ¿Qué significa `MANAGER_ID` nulo?
- ¿Por qué `SALARY_GRADE` no tiene FK con nadie? ¿Cómo se "une" con `EMPLOYEE`?
- ¿Cuál es la PK de `PRICE`? ¿Qué representa una fila con `END_DATE` nulo?
- ¿Cuál es la PK de `ITEM`? ¿Por qué es compuesta?
- ¿Qué columna de `CUSTOMER` apunta a `EMPLOYEE`, y qué significa?

### Ej. 5: Conteo rápido
Una sola consulta que devuelva la cantidad de filas de cada tabla de BDEMOBLD (pista: `UNION ALL`).
✅ Esperado: EMPLOYEE 32, DEPARTMENT 11, JOB 6, LOCATION 4, CUSTOMER 33, SALES_ORDER 100, ITEM 271, PRODUCT 31, PRICE 58, SALARY_GRADE 5.

## Parte C: El esquema GREMIO ⚔️

El esquema `GREMIO` está armado a propósito como un **espejo** de BDEMOBLD, así que todo lo que aprendas en uno sirve en el otro:

| GREMIO | BDEMOBLD | Notas |
|---|---|---|
| `CIUDAD` | `LOCATION` | Islas Sal no tiene gremio |
| `GREMIO` | `DEPARTMENT` | La Compañía del Grifo Roto no tiene miembros |
| `CLASE` | `JOB` | Nadie es DRUIDA |
| `AVENTURERO` | `EMPLOYEE` | `mentor_id` ≈ `manager_id`; hay aventureros sin gremio y oro nulo |
| `RANGO` | `SALARY_GRADE` | se une por `nivel BETWEEN nivel_min AND nivel_max` |
| `OBJETO` | `PRODUCT` | |
| `PRECIO_OBJETO` | `PRICE` | vigente = `fecha_hasta IS NULL` |
| `MISION` | `SALES_ORDER` | estado ABIERTA / COMPLETADA / FALLIDA |
| `PARTICIPACION` | (N a N) | aventurero ↔ misión, con rol |
| `BOTIN` | `ITEM` | objetos obtenidos en cada misión |
| `BITACORA` | (nueva) | vacía, para que la llenes desde procedimientos |

### Ej. 6: DER del gremio
Igual que el ej. 4, pero para GREMIO. Marcá las constraints CHECK que encuentres (`USER_CONSTRAINTS` con `constraint_type = 'C'`, columna `search_condition`).
- 🎲 ¿Qué pasa si intentás poner `hp = 200` a un aventurero con `hp_max = 180`? Probalo y leé el error.
