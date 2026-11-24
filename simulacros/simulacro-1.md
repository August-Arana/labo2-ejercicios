# Simulacro 1: SQL y bloques (90 minutos)

**Condiciones:** SQL Developer, sin apuntes, sin internet, cronómetro. Cada respuesta va en `soluciones/simulacros/s1-ejN.sql`. Antes de empezar: `lab reset`.
Puntaje total: 100. Aprobás con 60.

---

**1. (10 pts)** Listar apellido, nombre y fecha de ingreso (formato `DD/MM/YYYY`) de los empleados que **no** tienen comisión y ganan entre 1000 y 2000, ordenados por fecha de ingreso.

**2. (15 pts)** Por cada **ciudad** (`regional_group`): cantidad de departamentos, cantidad de empleados y salario promedio (2 decimales). Tienen que aparecer todas las ciudades, aunque no tengan empleados.

**3. (15 pts)** Empleados que ganan más que **su jefe**. Mostrar apellido del empleado, su salario, apellido del jefe y salario del jefe.

**4. (15 pts)** Los clientes cuyo total comprado (suma de `SALES_ORDER.total`) supera el promedio del total comprado por cliente. Mostrar nombre y total, de mayor a menor.

**5. (10 pts)** Sin ejecutar: ¿qué devuelve cada una y por qué?
```sql
SELECT COUNT(*), COUNT(commission), COUNT(DISTINCT department_id) FROM employee;
SELECT NVL(commission, 0) + salary FROM employee WHERE employee_id = 7369;
SELECT * FROM employee WHERE department_id NOT IN (SELECT department_id FROM department WHERE location_id = 999);
```

**6. (15 pts)** Crear la tabla `CURSOS (curso_id PK, nombre obligatorio y único, cupo entre 5 y 40, fecha_inicio por defecto hoy, profesor_id FK a EMPLOYEE)`. Insertar 2 filas válidas y escribir **un INSERT que viole cada constraint**, con el error esperado en un comentario.

**7. (20 pts)** Bloque anónimo que pide un `department_id` y muestra:
```
Departamento: RESEARCH (DALLAS)
Empleados: 5   Masa salarial: 10,875.00
Mayor salario: SCOTT (3,000.00)
Categoría: ALTA
```
Categoría: masa salarial > 10000 → ALTA; entre 5000 y 10000 → MEDIA; si no, BAJA. Usar `%TYPE` y `CASE`. Si el departamento no existe, mostrar un mensaje (podés usar `COUNT` para detectarlo: excepciones es la U4). Si hay empate en el mayor salario, mostrar cualquiera de los dos.

---
*Cuando termines: "corregime el simulacro 1". Anotá el tiempo que tardaste en cada ejercicio.*
