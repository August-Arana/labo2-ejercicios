# 09 · NoSQL y JSON (Unidades 8 y 10)

Apuntes: *08 - Bases NoSQL*, *10 - Formato JSON*. Videos del profesor: *Concepto bases de datos SQL y NoSQL* y *JSON: sintaxis y código*.
Entorno: `lab up nosql` levanta MongoDB (`lab mongo`). Oracle 23ai también habla JSON.

---

## Parte A: Teoría NoSQL (📜)

1. ¿Qué significa NoSQL? ¿Por qué "Not Only"?
2. Las 4 características del apunte: estructura flexible, escalabilidad horizontal, alto rendimiento, datos no relacionales. Explicá **escalabilidad horizontal contra vertical** con un ejemplo.
3. Los 4 tipos, con un motor de ejemplo y un caso de uso cada uno:

   | Tipo | Motor | Caso de uso | ¿Cómo se ve un dato? |
   |---|---|---|---|
   | Documental | | | |
   | Columnar | | | |
   | Clave-valor | | | |
   | Grafos | | | |

4. Ventajas y desventajas del paradigma NoSQL (según el apunte).
5. **Teorema CAP**: definí C, A y P. ¿Por qué en un sistema distribuido "P" no es opcional? Dá un ejemplo de sistema **CP** y uno **AP**. ¿Qué elige un banco? ¿Y el contador de "me gusta" de una red social?
6. Bases distribuidas: ¿qué ganás y qué perdés al replicar datos en varios nodos?
7. ¿Cuándo SQL y cuándo NoSQL? Respondé para: el sistema de sueldos de BDEMOBLD, un carrito de compras, las recomendaciones "amigos de tus amigos", los logs de 10.000 sensores por segundo.
8. 📜 Compará ACID (lo que viste con COMMIT/ROLLBACK en la U3) con la "consistencia eventual".

---

## Parte B: JSON (sintaxis y modelado)

**Ej. 1:** 💀 Encontrá los errores de sintaxis (hay 6):
```
{
  'nombre': "Aldric",
  "nivel": 20,
  "clase": PALADIN,
  "vivo": True,
  "inventario": ["Espada", "Escudo",],
  "oro": 15.000,50
  // el mentor es nulo
  "mentor": null
}
```
Validalo después con `python3 -m json.tool archivo.json` o `jq . archivo.json`.

**Ej. 2:** 📜 Tipos de valor válidos en JSON (son 6). ¿Hay un tipo fecha? ¿Cómo se representan las fechas entonces?

**Ej. 3: 🏛️ Actividad de modelado de la cátedra.** Una empresa de venta de insumos registra:
- **Vendedores:** nombre, email, teléfono, fecha de contratación, estado de actividad.
- **Locales:** nombre, dirección, ciudad, teléfono, horario de atención.
- **Insumos:** nombre, descripción, stock actual, unidad de medida, proveedor.
- **Lista de precios de insumos:** precio y fecha de validez, vinculados al insumo por `insumo_id`.

(a) Modelalo en JSON. (b) Agregá un **supervisor** a cada local, con los mismos datos que un vendedor.

💀 La entrega que tenés en la carpeta de la U10 (`actividad.json`) tiene errores de calidad: `"nonbre"`, `"id_sipervisor"`, emails repetidos, y el teléfono como número. 📜 ¿Por qué un teléfono **no** debería ser number en JSON? Rehacé el modelo bien.

(c) 📜 En la entrega, los precios están **embebidos** dentro de cada insumo, pero el enunciado habla de "vinculados mediante `insumo_id`" (es decir, **referenciados**). Hacé las dos versiones y discutí: ¿cuándo embeber y cuándo referenciar? Pensá en cuántos precios puede tener un insumo, si se consultan juntos y si se actualizan por separado.

(d) El supervisor: ¿lo embebés en el local o lo referenciás por id en la colección de vendedores? ¿Qué pasa si el supervisor cambia de teléfono?

**Ej. 4: 🐉 Jefe del día 18: el gremio en documentos.** Modelá el esquema GREMIO completo como documentos JSON para una base documental. Decidí y **justificá por escrito**:
- ¿Qué colecciones tenés? (¿`aventureros`? ¿`gremios`? ¿`misiones`?)
- ¿Las participaciones van dentro de la misión, dentro del aventurero o en las dos? (Desnormalización: ¿qué ganás y qué pagás?)
- ¿El historial de precios de un objeto va embebido?
- Escribí 3 documentos de ejemplo completos y válidos.

---

## Parte C: JSON en la práctica

**Ej. 5: MongoDB** (`lab up nosql`, `lab mongo`). La colección `labo2.aventureros` ya tiene 5 documentos.
```js
db.aventureros.find()
db.aventureros.find({ nivel: { $gte: 17 } }, { nombre: 1, nivel: 1 })
db.aventureros.find({ "clase.nombre": "PICARO" })
db.aventureros.find({ inventario: "Pocion de curacion" })
db.aventureros.find({ gremio: null })
```
- 🎲 Antes de ejecutar cada una, predecí cuántos documentos devuelve.
- Escribí: los que tienen el campo `hechizos` (`$exists`), los que tienen más de 2 objetos (`$size` o `$expr`), los que participaron en una misión FALLIDA.
- `insertOne` de un aventurero **con un campo que nadie más tiene** (`mascota: { especie: "cuervo", nombre: "Pluma" }`). 📜 ¿Por qué en Oracle esto requeriría un `ALTER TABLE`? ¿Qué es "esquema flexible"?
- `updateOne` para sumar 100 de oro a Quill (`$inc`) y `$push` de un objeto a su inventario.
- Agregación: oro total por gremio (`aggregate` con `$group`). Compará con el `GROUP BY` de la U1.

**Ej. 6: JSON dentro de Oracle** (porque Oracle 23ai también es documental):
- Generá JSON desde SQL: `SELECT JSON_OBJECT('id' VALUE employee_id, 'apellido' VALUE last_name) FROM employee;`
- Un documento por departamento con un array de empleados: `JSON_OBJECT(... 'empleados' VALUE JSON_ARRAYAGG(JSON_OBJECT(...)))` + `GROUP BY`.
- Creá `CREATE TABLE fichas (id NUMBER PRIMARY KEY, doc JSON);`, insertá 3 aventureros como JSON y consultá con `JSON_VALUE(doc, '$.nombre')` y `doc.nombre` (notación punto).
- `JSON_TABLE`: convertí el array de inventario en filas.
- 📜 ¿Entonces Oracle es SQL o NoSQL? (Bases multimodelo.)
