# 02 · DML y transacciones (Unidad 3, primera parte)

Apunte: *03 - Sentencias DML*.
⚠️ Esta guía **modifica datos**. Cuando termines: `lab reset bdemobld` (y `lab reset gremio` si tocaste el gremio).

---

## Parte A: Ejercitación 1 de la cátedra 🏛️

Hacelo **en SQL Developer** y escribí en el `.sql` (como comentario) qué observaste en cada paso.

1. Insertá dos cargos nuevos en `JOB` (datos inventados que respeten PK y FK).
2. `COMMIT`.
3. Borrá esos dos cargos.
4. `ROLLBACK`.
5. Consultá `JOB`. 🎲 Antes de ejecutar: ¿están los dos cargos o no?
6. Cambiá el nombre de un cliente.
7. `SAVEPOINT A`.
8. Cambiá el nombre de otro cliente.
9. `SAVEPOINT B`.
10. `ROLLBACK TO` el último savepoint creado.
11. Consultá `CUSTOMER`. 🎲 ¿Cuál de los dos cambios ves?
12. 📜 Si querés que el **primer** cambio quede guardado para siempre, ¿tenés que hacer algo? ¿Qué pasa si cerrás SQL Developer sin hacerlo?
13. Borrá el departamento 10. ¿Se puede? ¿Por qué? (Leé el error completo.)
14. Insertá el departamento 50, `'EDUCATION'`, en la localidad 100. ¿Se puede?
15. Insertá el departamento 43, `'OPERATIONS'`, sin indicar localidad. ¿Se puede? (Ojo: ¿el 43 ya existe?)
16. Pasá el departamento 20 a la localidad 155. ¿Se puede?
17. Subí un 10 % el salario a los que ganan menos que el promedio. ✅ 20 filas actualizadas.
18. Subí un 5 % el límite de crédito a los clientes con más de 5 órdenes. ✅ 5 filas.

📜 Para cada uno de los puntos 13 a 16, escribí el código ORA- y si es un problema de **PK**, de **FK padre** (2291) o de **FK hija** (2292).

---

## Parte B: Transacciones a fondo

**Ej. 19: 🎲 DDL y COMMIT implícito**
```sql
UPDATE employee SET salary = salary + 1 WHERE employee_id = 7369;
CREATE TABLE prueba_tx (x NUMBER);
ROLLBACK;
SELECT salary FROM employee WHERE employee_id = 7369;
```
¿Se deshizo el UPDATE? 📜 ¿Por qué? Después: `DROP TABLE prueba_tx;`

**Ej. 20: TRUNCATE contra DELETE**
Creá `ITEM_COPIA` como copia de `ITEM`. Borrala con `DELETE` y hacé `ROLLBACK`. Después vaciala con `TRUNCATE` y hacé `ROLLBACK`. 📜 ¿Qué diferencia hay? ¿Por qué TRUNCATE es DDL?

**Ej. 21: 🐉 Jefe: el duelo de sesiones**
Abrí **dos** conexiones al mismo tiempo: SQL Developer y `lab sql` en una terminal.
1. Sesión 1: `UPDATE employee SET salary = 9999 WHERE employee_id = 7369;` (sin commit).
2. Sesión 2: `SELECT salary FROM employee WHERE employee_id = 7369;`. 🎲 ¿Qué ve?
3. Sesión 2: `UPDATE employee SET salary = 1 WHERE employee_id = 7369;`. 🎲 ¿Qué pasa? (No te asustes.)
4. Sesión 1: `ROLLBACK;`. Mirá qué le pasa a la sesión 2.
5. 📜 Explicá con estas palabras: *lectura consistente*, *bloqueo de fila*, *atomicidad*.

---

## Parte C: INSERT, UPDATE y DELETE con subconsultas

**Ej. 22:** Insertá un empleado nuevo en el depto `'RESEARCH'` de `'DALLAS'`, sin escribir el `department_id` a mano: buscalo con una subconsulta dentro del `VALUES`. Usá `MAX(employee_id) + 1` para el id.

**Ej. 23:** `INSERT ... SELECT`: creá `EMP_HISTORICO (employee_id, last_name, salary, fecha_baja DATE)` vacía y cargale todos los CLERK con `fecha_baja = SYSDATE`.

**Ej. 24:** `UPDATE` con subconsulta correlacionada: poné a cada empleado el salario promedio de su departamento (redondeado). Mirá el resultado y hacé `ROLLBACK`.

**Ej. 25:** `DELETE` con subconsulta: borrá los productos que nunca se vendieron. 💀 ¿Por qué falla? Pista: mirá qué otra tabla los referencia. Resolvelo sin desactivar constraints.

### ⚔️ Side quests
- **G1:** Mira y Grimm tienen `hp = 0`. Un clérigo los revive: dejá su `hp` en la mitad de su `hp_max`, en **un solo UPDATE**.
- **G2:** Fundá un gremio nuevo en Islas Sal y mudá a los dos lobos solitarios (los que tienen `gremio_id` nulo).
- **G3:** 💀 Intentá dar de baja la clase PICARO. ¿Por qué no se puede? ¿Y la DRUIDA?
- **G4:** Cerrá el precio vigente de la "Pocion de curacion" (`fecha_hasta = SYSDATE`) e insertá uno nuevo un 10 % más caro **en la misma transacción**. Si algo falla en el medio, que no quede a medias (`SAVEPOINT`).
