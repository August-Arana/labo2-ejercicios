# 10 · Bases de grafos y columnares (Unidad 9)

Apuntes: *09 - Bases de datos columnares y grafos* y *Apunte Tutorial Neo4J*.
Entorno: `lab up nosql`. Neo4j Browser en **http://localhost:7474** (usuario `neo4j`, clave `labo2neo4j`), o `lab cypher` en la terminal. Es lo mismo que Neo4j Desktop del tutorial, pero en Docker.

---

## Parte A: Teoría (📜)

**Grafos**
1. ¿Qué es un nodo, una relación (arista), una etiqueta (label) y una propiedad? ¿Qué tiene de particular que **las relaciones** tengan propiedades?
2. Las 5 características del apunte (estructura de grafo, esquema flexible, consultas eficientes, escalabilidad, visualización).
3. Ventajas y desventajas. ¿Cuándo **no** usar un grafo?
4. Motores: nombrá 3. Cypher: ¿por qué se dice que es **declarativo**?
5. 📜 ¿Por qué "amigos de amigos de amigos" es caro en SQL (pensá en los self joins de EMPLOYEE.MANAGER_ID) y barato en un grafo?

**Columnares**
6. ¿Qué significa guardar por columnas en lugar de por filas? Dibujá cómo quedan en disco 3 filas de EMPLOYEE (id, apellido, salario) en cada formato.
7. ¿Por qué comprime mejor? ¿Por qué `SELECT AVG(salary)` es más rápido y un `UPDATE` de una fila entera es más lento?
8. Ventajas (4) y desventajas (6) según el apunte.
9. **Cassandra**: arquitectura P2P de nodos iguales (sin maestro), escalabilidad lineal, disponibilidad, CQL. ¿Dónde se ubica en el teorema CAP?
10. Motores columnares: nombrá 3 del apunte.

---

## Parte B: Neo4j: el tutorial de la cátedra 🏛️

**Ej. 1:** Cargá el grafo del tutorial: `lab cypher db/neo4j/01_estudiantes.cypher`.
💀 El script del apunte tiene un error de sintaxis en `(Jose:Estudiante{nombre:'Jose,legajo:'4444'})`. Encontralo (el del repo ya está corregido).

**Ej. 2:** En el Browser: `MATCH (n) RETURN n`. Explorá el visor.

**Ej. 3:** Escribí en Cypher:
1. Todos los nodos `Estudiante`.
2. Qué materias cursa Martin.
3. Quiénes aprobaron Programacion1.
4. Estudiantes que cursan LaboratorioII **y** aprobaron Fisica.
5. Cantidad de estudiantes por materia cursada (`count`), ordenada.
6. Materias que nadie cursa (pista: `WHERE NOT (m)<-[:Cursa]-()`).
7. Agregá una propiedad `nota` a las relaciones `Aprobo` (`SET r.nota = 8`) y calculá el promedio por estudiante.
8. Creá un nodo `Profesor` que dicta LaboratorioII y Fisica, y consultá "los alumnos de los profesores de Martin".

---

## Parte C: ⚔️ El grafo del gremio

**Ej. 4:** Pasá GREMIO a grafo a mano en Cypher (o generá el script con una consulta SQL que concatene strings: ¡buen ejercicio de U1!):
- Nodos: `(:Aventurero {id, nombre, nivel, raza})`, `(:Gremio {nombre})`, `(:Ciudad {nombre})`, `(:Mision {id, titulo, estado})`.
- Relaciones: `(:Aventurero)-[:MENTOR_DE]->(:Aventurero)`, `-[:MIEMBRO_DE]->(:Gremio)`, `(:Gremio)-[:CON_SEDE_EN]->(:Ciudad)`, `(:Aventurero)-[:PARTICIPO {rol}]->(:Mision)`.

Pista SQL para generar los nodos:
```sql
SELECT 'CREATE (:Aventurero {id:' || aventurero_id || ', nombre:''' || nombre || ''', nivel:' || nivel || '});'
FROM aventurero;
```

**Ej. 5: 🐉 Jefe del día 19: consultas de caminos**
1. Toda la línea de mentores de Pip hasta la raíz: `MATCH p = (raiz)-[:MENTOR_DE*]->(:Aventurero {nombre:'Pip'}) RETURN p`.
2. Todos los "descendientes" de Aldric (a cualquier profundidad) y su profundidad.
3. Pares de aventureros que compartieron misión **y** son de gremios distintos.
4. El camino más corto entre Quill y Vex usando cualquier relación (`shortestPath`).
5. 📜 Escribí la consulta 2 en SQL con `CONNECT BY` (U1, G3) y compará.

---

## Parte D: Diseño columnar (Cassandra, en papel)

En Cassandra **se diseña la tabla a partir de la consulta**, no de las entidades.

**Ej. 6:** Para cada consulta, diseñá una tabla CQL con su `PRIMARY KEY ((partition key), clustering columns)`:
1. "Misiones de un gremio, de la más nueva a la más vieja."
2. "Historial de precios de un objeto, ordenado por fecha."
3. "Participaciones de un aventurero."

```sql
-- ejemplo de forma
CREATE TABLE misiones_por_gremio (
  gremio     text,
  publicada  date,
  mision_id  int,
  titulo     text,
  estado     text,
  PRIMARY KEY ((gremio), publicada, mision_id)
) WITH CLUSTERING ORDER BY (publicada DESC);
```

📜 ¿Por qué en Cassandra está bien **duplicar** datos en varias tablas? ¿Por qué no hay JOIN? Compará con la normalización que aplicaste en BDEMOBLD.
