# Simulacro 2: PL/SQL (2 horas)

**Condiciones:** SQL Developer, sin apuntes, cronómetro. `lab reset` antes de empezar. Respuestas en `soluciones/simulacros/s2-ejN.sql`.
Puntaje: 100. Aprobás con 60.

---

**1. (15 pts) Cursores.** Bloque que recorre los departamentos y, por cada uno, lista sus empleados ordenados por salario descendente con el grado salarial (`SALARY_GRADE`). Al final de cada departamento: el total y la cantidad. Los departamentos sin empleados muestran `(vacío)`.

**2. (15 pts) Excepciones.** Bloque que pide un `product_id` y un porcentaje, y actualiza el precio vigente. Manejar:
- producto inexistente (excepción de usuario),
- producto sin precio vigente (otra excepción de usuario),
- porcentaje que hace que `min_price > list_price` (constraint de PRICE asociada con PRAGMA),
- cualquier otro error con `SQLERRM`.

**3. (20 pts) Procedimiento.** `transferir_empleado(p_emp_id, p_nuevo_depto)`:
- Valida que exista el empleado y el departamento (errores -20001 y -20002).
- Si el empleado es MANAGER y tiene subordinados en el depto viejo, no se puede transferir (-20003).
- Actualiza `department_id` y devuelve en un parámetro OUT el nombre del nuevo departamento.
- Bloque de prueba que llame 3 veces (un caso OK y dos casos de error atrapados).

**4. (20 pts) Función.** `fn_antiguedad_cliente(p_customer_id) RETURN NUMBER`: meses entre la primera y la última orden del cliente. Si tiene una sola orden, 0. Si no tiene órdenes, NULL. Si no existe, error. Usarla en un SELECT que liste los 5 clientes más antiguos.

**5. (20 pts) Integrador.** Procedimiento `cerrar_orden(p_order_id)`:
- Recalcula `ITEM.total = actual_price * quantity` para cada ítem de la orden (cursor con `FOR UPDATE` / `WHERE CURRENT OF`).
- Actualiza `SALES_ORDER.total` con la suma.
- Si `ship_date` es nulo, la pone en `SYSDATE`.
- Informa cuántos ítems recalculó y si el total cambió respecto al que estaba guardado.

**6. (10 pts) Oral escrito.** En 3 o 4 líneas cada una:
a) Diferencia entre procedimiento y función. ¿Cuándo una función no puede usarse en un SELECT?
b) ¿Qué es `PRAGMA EXCEPTION_INIT` y para qué sirve?
c) Cursor implícito contra explícito: ¿cuándo usás cada uno?
