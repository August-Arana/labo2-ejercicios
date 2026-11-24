# Chuleta PL/SQL (Labo II)

> Para el día 20: reescribila de memoria en papel y después compará.

## Bloque
```sql
SET SERVEROUTPUT ON
DECLARE
  v_n      NUMBER(6,2) := 0;
  c_tasa   CONSTANT NUMBER := 0.17;
  v_ape    employee.last_name%TYPE;
  rec_emp  employee%ROWTYPE;
  e_propia EXCEPTION;
BEGIN
  SELECT * INTO rec_emp FROM employee WHERE employee_id = &id;
  IF rec_emp.salary > 2000 THEN ...
  ELSIF ... THEN ...
  ELSE ...
  END IF;
  v_ape := CASE WHEN v_n > 0 THEN 'pos' WHEN v_n < 0 THEN 'neg' ELSE 'cero' END;
EXCEPTION
  WHEN NO_DATA_FOUND THEN ...
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
END;
/
```

## Loops
```sql
LOOP ... EXIT WHEN cond; END LOOP;
WHILE cond LOOP ... END LOOP;
FOR i IN 1..10 LOOP ... END LOOP;          -- i no se declara
FOR i IN REVERSE 1..10 LOOP ... END LOOP;
```

## Cursores
```sql
-- implícito (después de INSERT/UPDATE/DELETE/SELECT INTO)
SQL%ROWCOUNT  SQL%FOUND  SQL%NOTFOUND  SQL%ISOPEN (siempre FALSE)

-- explícito
CURSOR c_emp(p_depto NUMBER) IS SELECT ... WHERE department_id = p_depto;
OPEN c_emp(10);
LOOP
  FETCH c_emp INTO v1, v2;        -- o INTO rec (c_emp%ROWTYPE)
  EXIT WHEN c_emp%NOTFOUND;       -- ¡antes de usar las variables!
  ...
END LOOP;
CLOSE c_emp;

FOR r IN c_emp(10) LOOP ... END LOOP;              -- abre, fetchea y cierra solo
FOR r IN (SELECT ... ) LOOP ... END LOOP;          -- cursor inline

CURSOR c IS SELECT ... FOR UPDATE OF salary;
UPDATE employee SET ... WHERE CURRENT OF c;
```

## Excepciones
```sql
e_hijos EXCEPTION;
PRAGMA EXCEPTION_INIT(e_hijos, -2292);    -- no predefinida
RAISE e_propia;                           -- usuario
RAISE;                                    -- re-lanzar (solo dentro de un handler)
RAISE_APPLICATION_ERROR(-20001, 'msg');   -- -20000..-20999
```
| Predefinida | ORA |
|---|---|
| NO_DATA_FOUND | 01403 |
| TOO_MANY_ROWS | 01422 |
| DUP_VAL_ON_INDEX | 00001 |
| VALUE_ERROR | 06502 |
| INVALID_NUMBER | 01722 |
| ZERO_DIVIDE | 01476 |
| INVALID_CURSOR | 01001 |
| CURSOR_ALREADY_OPEN | 06511 |

| Constraint | ORA |
|---|---|
| PK/UNIQUE | 00001 |
| NOT NULL | 01400 |
| CHECK | 02290 |
| FK: no existe el padre | 02291 |
| FK: tiene hijos | 02292 |

## Procedimientos y funciones
```sql
CREATE OR REPLACE PROCEDURE p(p_a IN NUMBER, p_b OUT VARCHAR2, p_c IN OUT NUMBER, p_d IN NUMBER DEFAULT 0) IS  -- DEFAULT solo en IN
  v_local NUMBER;
BEGIN
  ...
EXCEPTION
  ...
END p;
/
SHOW ERRORS
EXEC p(1, :v, :x);     -- o desde un bloque: p(1, v_b, v_c);

CREATE OR REPLACE FUNCTION f(p_id NUMBER) RETURN VARCHAR2 IS
BEGIN
  RETURN '...';            -- en TODOS los caminos
END f;
/
SELECT f(employee_id) FROM employee;     -- solo si f no hace DML
```

## Paquetes
```sql
CREATE OR REPLACE PACKAGE pkg IS                -- SPEC = público
  g_contador NUMBER := 0;
  c_max CONSTANT NUMBER := 20;
  PROCEDURE alta(p_desc VARCHAR2);
  PROCEDURE alta(p_desc VARCHAR2, p_id NUMBER); -- sobrecarga
  FUNCTION f RETURN NUMBER;
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg IS           -- BODY = implementación + privado
  TYPE tr IS RECORD (id NUMBER, nombre VARCHAR2(30));
  TYPE tt IS TABLE OF tr INDEX BY PLS_INTEGER;
  t_cache tt;
  FUNCTION privada RETURN NUMBER;               -- forward declaration
  PROCEDURE alta(p_desc VARCHAR2, p_id NUMBER) IS BEGIN ... END alta;
  PROCEDURE alta(p_desc VARCHAR2) IS BEGIN alta(p_desc, privada); END alta;
  FUNCTION f RETURN NUMBER IS BEGIN RETURN 1; END f;
  FUNCTION privada RETURN NUMBER IS BEGIN RETURN 99; END privada;
BEGIN                                           -- one-time-only
  SELECT ... BULK COLLECT INTO t_cache FROM ...;
END pkg;
/
DROP PACKAGE BODY pkg;   DROP PACKAGE pkg;
```
Colecciones: `.COUNT .FIRST .LAST .NEXT(i) .PRIOR(i) .EXISTS(i) .DELETE`

## SQL que siempre se olvida
```sql
NVL(x, 0)   NVL2(x, si_no_nulo, si_nulo)   COALESCE(a, b, c)   DECODE(x, 1, 'a', 'b')
TO_CHAR(fecha, 'DD/MM/YYYY HH24:MI')   TO_CHAR(n, '999,990.00')   TO_DATE('31/12/2026','DD/MM/YYYY')
MONTHS_BETWEEN(f1, f2)   ADD_MONTHS(f, n)   LAST_DAY(f)   NEXT_DAY(f, 'FRIDAY')   TRUNC(f, 'MM')
SUBSTR(s, ini, cant)   INSTR(s, 'x')   LPAD(s, n, '*')   UPPER/LOWER/INITCAP   LENGTH   TRIM
WHERE ... GROUP BY ... HAVING ... ORDER BY ...          -- orden de escritura
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY    -- orden de evaluación
e.department_id = d.department_id(+)                    -- (+) del lado que puede ser NULL
FETCH FIRST 5 ROWS ONLY
```

## Diccionario
`USER_TABLES · USER_TAB_COLUMNS · USER_CONSTRAINTS · USER_OBJECTS · USER_SOURCE · USER_ERRORS · USER_SEQUENCES`
