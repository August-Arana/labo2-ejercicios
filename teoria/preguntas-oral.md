# Preguntas de oral (flashcards)

Respondé en voz alta **antes** de abrir la respuesta. Marcá con ❌ las que no te salieron y repetilas al otro día.

---

## U1: BD relacional y SQL

<details><summary>¿Cuáles son los tipos de datos principales de Oracle y qué diferencia hay entre CHAR y VARCHAR2?</summary>

NUMBER(p,s), CHAR(n), VARCHAR2(n), DATE (también guarda la hora), TIMESTAMP (con fracciones de segundo), LONG (obsoleto, reemplazado por CLOB) y LOB (CLOB/BLOB). CHAR es de longitud fija: rellena con espacios hasta n (máximo 2000). VARCHAR2 es variable (máximo 4000 en SQL).
</details>

<details><summary>¿Por qué no se puede usar `= NULL`?</summary>

NULL significa "valor desconocido"; cualquier comparación con NULL da NULL (ni TRUE ni FALSE), así que el WHERE no la acepta. Se usa IS NULL / IS NOT NULL. Toda aritmética con NULL da NULL: hace falta NVL.
</details>

<details><summary>WHERE contra HAVING</summary>

WHERE filtra filas antes de agrupar y no puede usar funciones de grupo. HAVING filtra grupos después del GROUP BY y sí puede usarlas.
</details>

<details><summary>¿Qué es un producto cartesiano y cómo se evita?</summary>

Combinar cada fila de una tabla con todas las de la otra (n × m filas). Se evita con las condiciones de join: como mínimo, cantidad de tablas − 1.
</details>

<details><summary>Inner contra outer join. ¿Dónde va el (+)?</summary>

El inner devuelve solo las filas que coinciden. El outer también devuelve las que no tienen pareja, completando con NULL. En la sintaxis Oracle, el (+) va del lado de la tabla que puede no tener fila coincidente (el lado "deficiente", donde aparecen los NULL).
</details>

<details><summary>¿Qué es una subconsulta sincronizada (correlacionada)?</summary>

Una subconsulta que referencia columnas de la consulta externa, por lo que se evalúa conceptualmente una vez por cada fila externa. Ejemplo: empleados que ganan más que el promedio de su departamento.
</details>

<details><summary>Nombrá los 5 tipos de constraint.</summary>

NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK. NOT NULL solo se define a nivel de columna; una PK o FK compuesta, o un CHECK que involucre varias columnas, va a nivel de tabla.
</details>

<details><summary>¿Qué es una vista? ¿Y una secuencia?</summary>

Vista: una consulta guardada con nombre que se usa como una tabla (no guarda datos). Secuencia: un objeto que genera números únicos (NEXTVAL/CURRVAL) y evita el problema de concurrencia de MAX+1.
</details>

## U2: PL/SQL y bloques

<details><summary>SQL contra PL/SQL</summary>

SQL es declarativo (qué datos quiero). PL/SQL es la extensión procedural de Oracle: variables, condiciones, ciclos y manejo de errores, con SQL embebido. Ventajas: un bloque viaja entero al servidor, así que hay menos tráfico de red; mejor performance; modularidad; portabilidad entre plataformas Oracle; integración total con la base.
</details>

<details><summary>Secciones de un bloque y cuáles son obligatorias</summary>

DECLARE (opcional), BEGIN ... (obligatoria, con al menos una sentencia, aunque sea NULL;), EXCEPTION (opcional), END;
</details>

<details><summary>Tipos de bloque</summary>

Anónimo (sin nombre, no se guarda, se compila cada vez), procedimiento, función, paquete, trigger (con nombre, se guardan compilados en la base).
</details>

<details><summary>¿Para qué sirven %TYPE y %ROWTYPE?</summary>

Para declarar variables con el tipo de una columna o de una fila completa. Si cambia la tabla, el código se adapta sin tocarlo y se evitan errores de tamaño o tipo.
</details>

<details><summary>Variable de sustitución (&) contra bind (:)</summary>

`&` la reemplaza la herramienta cliente (SQL Developer, SQLcl) como texto **antes** de mandar el código al servidor; por eso se pide una sola vez aunque esté dentro de un loop. `:` es una variable bind del lado del servidor y la herramienta tiene que declararla o pedirla.
</details>

## U3: DML y cursores

<details><summary>DML contra DDL contra TCL. ¿Por qué un CREATE TABLE "hace commit"?</summary>

DML: INSERT, UPDATE, DELETE, SELECT (MERGE). DDL: CREATE, ALTER, DROP, TRUNCATE. TCL: COMMIT, ROLLBACK, SAVEPOINT. Toda sentencia DDL hace un COMMIT implícito antes y después de ejecutarse.
</details>

<details><summary>DELETE contra TRUNCATE</summary>

DELETE es DML: puede tener WHERE, genera undo y se puede deshacer con ROLLBACK. TRUNCATE es DDL: vacía toda la tabla, es muy rápido, no se puede deshacer y no dispara triggers de fila.
</details>

<details><summary>Cursor implícito contra explícito</summary>

El implícito lo abre Oracle en cada DML o SELECT INTO; se consulta con SQL%ROWCOUNT/FOUND/NOTFOUND. El explícito lo declarás vos para recorrer consultas que devuelven varias filas: OPEN, FETCH, CLOSE, o un FOR LOOP.
</details>

<details><summary>Atributos de un cursor explícito</summary>

%ISOPEN, %FOUND, %NOTFOUND, %ROWCOUNT (filas fetcheadas hasta ahora).
</details>

<details><summary>¿Qué ventaja tiene el cursor FOR LOOP?</summary>

Declara el registro, abre, fetchea, detecta el final y cierra solo, aunque salga una excepción en el medio. Hay menos código y es imposible olvidarse el CLOSE.
</details>

## U4: Excepciones

<details><summary>Los tres tipos de excepción</summary>

Predefinidas (tienen nombre, no se declaran: NO_DATA_FOUND…). No predefinidas (errores Oracle sin nombre: se declaran y se asocian con PRAGMA EXCEPTION_INIT a un código ORA). Definidas por el usuario (se declaran y se lanzan con RAISE según una regla de negocio).
</details>

<details><summary>¿Qué hace PRAGMA EXCEPTION_INIT?</summary>

Es una directiva al compilador que asocia un nombre de excepción declarado con un número de error Oracle, para poder atraparlo con un WHEN específico en lugar de WHEN OTHERS.
</details>

<details><summary>RAISE contra RAISE_APPLICATION_ERROR</summary>

RAISE lanza una excepción con nombre (o re-lanza la actual). RAISE_APPLICATION_ERROR(-20000..-20999, msg) termina con un error de Oracle personalizado que le llega al llamador (la aplicación, otro procedimiento) como cualquier ORA-.
</details>

<details><summary>¿Qué pasa si una excepción no se atrapa?</summary>

Se propaga al bloque que encierra al actual; si llega afuera de todo, el bloque termina con error y Oracle deshace lo que hizo esa sentencia (el bloque anónimo completo, si nadie lo atrapó).
</details>

<details><summary>SQLCODE y SQLERRM</summary>

Funciones que devuelven el número y el mensaje del error actual. Se usan dentro de WHEN OTHERS para informar o registrar.
</details>

## U5: Procedimientos y funciones

<details><summary>Procedimiento contra función</summary>

Los dos tienen nombre, se guardan compilados y aceptan parámetros. La función **retorna un valor** (RETURN obligatorio) y puede usarse dentro de expresiones y de SQL. El procedimiento se invoca como sentencia y devuelve datos con parámetros OUT.
</details>

<details><summary>Modos de parámetro</summary>

IN (por defecto, de solo lectura), OUT (se escribe; entra como NULL), IN OUT (entra con valor y se puede modificar).
</details>

<details><summary>¿Cuándo una función no puede usarse en un SELECT?</summary>

Cuando hace DML o COMMIT (ORA-14551), cuando tiene parámetros OUT/IN OUT, o tipos que SQL no conoce (BOOLEAN antes de 23ai, registros PL/SQL).
</details>

<details><summary>¿Cómo ves los errores de compilación?</summary>

SHOW ERRORS, o `SELECT * FROM USER_ERRORS WHERE name = '...'`. El objeto queda creado con status INVALID.
</details>

## U6: Paquetes

<details><summary>Spec contra body</summary>

La spec es la interfaz pública: declaraciones de procedimientos, funciones, tipos, variables y constantes. El body tiene la implementación más todo lo privado. Primero se compila la spec. Se puede recompilar el body sin invalidar a los que llaman.
</details>

<details><summary>Ventajas de los paquetes (apunte)</summary>

Modularidad, seguridad y privacidad (lo privado no se ve), performance (se carga entero en memoria con la primera llamada) y datos compartidos en memoria durante la sesión (variables de paquete).
</details>

<details><summary>Sobrecarga: ¿qué es y qué reglas tiene?</summary>

Varios subprogramas con el mismo nombre y distinta firma, que solo pueden existir dentro de un paquete o bloque (no como objetos sueltos). No pueden diferir solo en el nombre o el modo de los parámetros, ni en subtipos de la misma familia (NUMBER contra INTEGER), ni solo en el tipo de retorno.
</details>

<details><summary>¿Qué es el bloque one-time-only?</summary>

El BEGIN ... al final del body del paquete. Se ejecuta una sola vez por sesión, la primera vez que se referencia el paquete. Se usa para inicializar variables o cargar cachés en memoria (tablas PL/SQL con BULK COLLECT) y evitar consultas repetidas.
</details>

<details><summary>BULK COLLECT contra cargar con un cursor</summary>

BULK COLLECT trae todas las filas de una vez a la colección, con índices automáticos 1..n en el orden de la consulta. Con un cursor cargás fila a fila y elegís el índice (por ejemplo el id) para acceder directo después.
</details>

## U7: ORM

<details><summary>ORM en una frase</summary>

Una técnica que mapea objetos del lenguaje a tablas relacionales, para hacer CRUD sin escribir SQL a mano.
</details>

<details><summary>JPA contra Hibernate</summary>

JPA es la especificación (interfaces y anotaciones estándar de Java). Hibernate es una implementación de JPA que agrega funcionalidades propias (HQL, Criteria). Otra implementación: EclipseLink.
</details>

<details><summary>SessionFactory contra Session</summary>

SessionFactory: pesada, se crea una vez al iniciar la aplicación a partir de la configuración y fabrica sesiones. Session: liviana, una por unidad de trabajo; da la conexión física y es por donde se guardan y recuperan los objetos.
</details>

## U8 y U10: NoSQL y JSON

<details><summary>Teorema CAP</summary>

En un sistema distribuido, ante una partición de red, solo se pueden garantizar 2 de 3: Consistencia (todos ven el mismo dato), Disponibilidad (toda petición tiene respuesta) y Tolerancia a particiones. Como las particiones pasan, en la práctica se elige entre CP y AP.
</details>

<details><summary>Tipos de NoSQL con motor y caso de uso</summary>

Documental: MongoDB (contenido web, catálogos). Columnar: Cassandra o HBase (analítica, series temporales, big data). Clave-valor: Redis (caché, sesiones, carrito). Grafos: Neo4j (redes sociales, recomendaciones).
</details>

<details><summary>Tipos de valor en JSON</summary>

string, number, boolean, null, object, array. No hay fecha: se usa un string ISO-8601 ("2026-12-15").
</details>

<details><summary>¿Embeber o referenciar?</summary>

Embebés cuando los datos se leen juntos, pertenecen a un solo padre y no crecen sin límite. Referenciás cuando se comparten entre muchos, se actualizan solos o pueden crecer mucho.
</details>

## U9: Grafos y columnares

<details><summary>Elementos de un grafo y de Cypher</summary>

Nodos (con labels y propiedades) y relaciones (dirigidas, con tipo y propiedades). Cypher: `CREATE (n:Label {p:'v'})`, `MATCH (a)-[:TIPO]->(b) WHERE ... RETURN ...`.
</details>

<details><summary>¿Por qué una base columnar es buena para analítica?</summary>

Guarda juntos los valores de cada columna: lee solo las columnas que pide la consulta y comprime mucho (valores parecidos juntos). Es peor para escribir o actualizar filas completas.
</details>

<details><summary>Cassandra en 3 puntos</summary>

Nodos iguales P2P (sin maestro, sin punto único de falla), escalabilidad lineal y alta disponibilidad (AP), consultas con CQL (parecido a SQL, sin JOIN). Las tablas se diseñan según la consulta.
</details>
