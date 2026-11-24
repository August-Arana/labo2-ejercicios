# 08 · ORM: JPA e Hibernate (Unidad 7)

Apunte: *07 - Conceptos sobre ORM*.
La unidad es sobre todo **teórica**, pero se entiende diez veces mejor si la ves funcionando. El proyecto `orm/` ya se conecta a tu Oracle y mapea `PRODUCT`. Se ejecuta con:

```bash
cd orm && mvn -q compile exec:java
```

Lo que hay que saber de memoria está en la Parte A. La Parte B es práctica para entenderlo (y te sirve también para Java).

---

## Parte A: Teoría (📜 todo es oral)

1. ¿Qué es un ORM? ¿Qué problema resuelve? Explicá el *desajuste objeto-relacional* con un ejemplo de BDEMOBLD (por ejemplo, `EMPLOYEE.MANAGER_ID` contra un atributo `Employee jefe`).
2. Ventajas (4) y desventajas (2) según el apunte. Agregá una desventaja que el apunte no menciona: el problema **N+1**.
3. ¿Qué es **JPA** y qué es **Hibernate**? ¿Cuál es la especificación y cuál la implementación? Nombrá otra implementación de JPA.
4. Arquitectura de Hibernate: *Configuration*, *SessionFactory*, *Session*, *Transaction*. ¿Cuál se crea una vez y cuál muchas? ¿Cuál es pesada y cuál liviana? ¿Qué equivalente JPA tiene cada una (`EntityManagerFactory`, `EntityManager`, `EntityTransaction`)?
5. Dos formas de mapear: **XML** (`.hbm.xml`) contra **anotaciones** (`@Entity`, `@Table`, `@Id`, `@Column`). ¿Qué hace cada anotación?
6. ¿Qué es **HQL/JPQL**? ¿En qué se diferencia de SQL? (Pista: ¿consulta tablas o clases?)
7. ¿Por qué un ORM ayuda contra la **inyección SQL**? ¿Lo hace automáticamente si concatenás strings en el HQL?
8. ¿En qué caso **no** usarías un ORM? (Procesos masivos, reportes complejos: relacionalo con PL/SQL.)
9. Caso de uso del apunte (gestión de empleados): describí qué entidades, qué operaciones CRUD y dónde entra la transacción.

---

## Parte B: Práctica en `orm/`

**ORM-1: Mirá lo que genera.** Ejecutá el proyecto tal cual. Con `show_sql = true` ves el SQL que Hibernate genera a partir del JPQL. 🎲 Antes de ejecutar, escribí qué SQL esperás.

**ORM-2: CRUD con transacción.** En `Main.java` (donde está el TODO):
- `em.getTransaction().begin()`, `em.persist(new Product(999001L, "TEST PRODUCT"))`, `commit()`.
- Buscalo con `find`, cambiale la descripción con `setDescription` **sin llamar a ningún update**, y hacé commit. 🎲 ¿Se actualizó en la base? (Mirá el SQL generado.) 📜 Eso es el *dirty checking*.
- `em.remove(...)` y commit.
- Repetí el persist con un id que ya existe: ¿qué excepción Java aparece y qué ORA- tiene adentro?

**ORM-3: Relaciones.** Mapeá `Gremio` (tabla `GREMIO`) y `Aventurero` (tabla `AVENTURERO`) con:
- `@ManyToOne @JoinColumn(name = "GREMIO_ID") private Gremio gremio;` en Aventurero.
- `@OneToMany(mappedBy = "gremio") private List<Aventurero> miembros;` en Gremio.
- Registralas en `persistence.xml`.
- JPQL: `select a from Aventurero a where a.gremio.nombre = :g order by a.nivel desc`. 🎲 ¿Qué join genera Hibernate?

**ORM-4: N+1 en vivo.** Traé todos los gremios y, por cada uno, imprimí `g.getMiembros().size()`. Contá cuántos SELECT aparecen en consola. Arreglalo con `select distinct g from Gremio g left join fetch g.miembros`. 📜 Explicá el N+1 con tus palabras.

**ORM-5: Llamar a PL/SQL desde JPA.** Llamá al procedimiento `subir_nivel` (U5, G3) con `em.createStoredProcedureQuery("SUBIR_NIVEL")`. 📜 Esto muestra que ORM y PL/SQL no compiten: ¿cuándo pondrías la lógica en la base y cuándo en Java?
