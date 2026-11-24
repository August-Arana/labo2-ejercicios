# Simulacro final (2 h 30 min)

**Condiciones de examen.** SQL Developer para la parte práctica; papel (o un .md) para la teórica. `lab reset` antes. Respuestas en `soluciones/simulacros/sf-*.sql` / `sf-teoria.md`.
Puntaje: 100 (70 práctica + 30 teoría). Aprobás con 60, sacando por lo menos 40 en la práctica.

---

## Parte práctica (70 pts)

**P1. (10 pts) SQL.** Productos cuyo precio de lista **vigente** es mayor que el promedio de los precios vigentes, con la cantidad total vendida (`SUM(quantity)` de ITEM; 0 si nunca se vendieron). De mayor a menor precio.

**P2. (25 pts) Paquete `PKG_VENTAS`.**
- Pública `fn_total_orden(p_order_id) RETURN NUMBER`: suma de los ítems. Si la orden no existe, error -20100.
- Pública `alta_item(p_order_id, p_product_id, p_quantity)` con **sobrecarga** `alta_item(p_order_id, p_description, p_quantity)` (busca el producto por descripción y llama a la versión core).
  - `item_id` = máximo de la orden + 1.
  - `actual_price` = precio de lista vigente (si no hay, error -20101).
  - `total` = precio × cantidad; actualiza `SALES_ORDER.total`.
- Privada `fn_precio_vigente(p_product_id)`.
- Variable de paquete con la cantidad de ítems dados de alta en la sesión, y una función pública que la devuelve.
- Bloque de prueba que ejercite los dos `alta_item`, un error atrapado y la variable de sesión.

**P3. (20 pts) Cursores + excepciones.** Bloque que, para cada vendedor (`EMPLOYEE` que aparece como `salesperson_id` en CUSTOMER), calcule el total vendido por sus clientes y:
- si vendió más que el promedio de los vendedores: +10 % de comisión (comisión nula = 0);
- si no vendió nada: mensaje `"<apellido> no tiene ventas"`.
- Errores inesperados: deshacer **todo** lo hecho en el bloque y cancelar con un mensaje claro.

**P4. (15 pts) Corrección de código.** Encontrá y corregí los errores (son 5 o más):
```sql
CREATE OR REPLACE FUNCTION fn_nombre_depto(p_id NUMBER) RETURN VARCHAR2 IS
  v_nombre department.name%TYPE;
BEGIN
  SELECT name INTO v_nombre FROM department WHERE department_id = p_id;
  IF SQL%NOTFOUND THEN
    RETURN 'NO EXISTE';
  END IF;
EXCEPTION
  WHEN TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE('duplicado');
END;
/
DECLARE
  v VARCHAR2(5);
BEGIN
  v := fn_nombre_depto(&id);
  DBMS_OUTPUT.PUT_LINE(v);
END
```

## Parte teórica (30 pts)

**T1. (6 pts)** ORM: ¿qué es, qué relación hay entre JPA e Hibernate y qué rol cumplen `SessionFactory` y `Session`? Una ventaja y una desventaja.

**T2. (6 pts)** Teorema CAP: enunciado y un ejemplo de cuándo elegirías AP y cuándo CP.

**T3. (6 pts)** Modelá en JSON una orden de BDEMOBLD (SALES_ORDER con sus ITEM, el cliente y la descripción de cada producto). Decí qué embebiste, qué referenciaste y por qué.

**T4. (6 pts)** Escribí en Cypher: "clientes que compraron algún producto que también compró el cliente 'JOCKSPORTS'". Proponé el modelo de nodos y relaciones primero.

**T5. (6 pts)** Base columnar: ¿por qué conviene para análisis (OLAP) y no para transacciones (OLTP)? Nombrá un motor y una característica de su arquitectura.
