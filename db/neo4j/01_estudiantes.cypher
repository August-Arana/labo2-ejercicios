// Course example (Unit 9 tutorial), with the missing quote after 'Jose' fixed.
// Load with: lab cypher db/neo4j/01_estudiantes.cypher
MATCH (n:Estudiante) DETACH DELETE n;
MATCH (n:Materia) DETACH DELETE n;
CREATE (Martin:Estudiante {nombre:'Martin', legajo:'1111'}),
       (Pablo:Estudiante {nombre:'Pablo', legajo:'2222'}),
       (Natalia:Estudiante {nombre:'Natalia', legajo:'3333'}),
       (Jose:Estudiante {nombre:'Jose', legajo:'4444'}),
       (Ezequiel:Estudiante {nombre:'Ezequiel', legajo:'5555'}),
       (LaboratorioII:Materia {nombre:'LaboratorioII', cupos:50, profesores:2}),
       (Fisica:Materia {nombre:'Fisica', cupos:10, profesores:1}),
       (Programacion1:Materia {nombre:'Programacion1', profesores:5}),
       (Programacion10:Materia {nombre:'Programacion10', plan_de_estudio:2030}),
       (Martin)-[:Cursa]->(LaboratorioII),
       (Pablo)-[:Cursa]->(LaboratorioII),
       (Natalia)-[:Cursa]->(LaboratorioII),
       (Jose)-[:Cursa]->(LaboratorioII),
       (Ezequiel)-[:Cursa]->(LaboratorioII),
       (Martin)-[:Cursa]->(Fisica),
       (Martin)-[:Cursa]->(Programacion1),
       (Jose)-[:Aprobo]->(Programacion1),
       (Pablo)-[:Aprobo]->(Programacion1),
       (Natalia)-[:Aprobo]->(Programacion1),
       (Ezequiel)-[:Aprobo]->(Programacion1),
       (Natalia)-[:Aprobo]->(Fisica),
       (Ezequiel)-[:Aprobo]->(Fisica);
