package labo2.orm;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

/**
 * Starting point for the ORM exercises (ejercicios/07-orm.md).
 * Run with:  cd orm && mvn -q compile exec:java
 */
public class Main {
    public static void main(String[] args) {
        // 1. Configuration + SessionFactory  ->  EntityManagerFactory (built once)
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("labo2");
        // 2. Session  ->  EntityManager (cheap, one per unit of work)
        EntityManager em = emf.createEntityManager();
        try {
            // HQL/JPQL talks about CLASSES and FIELDS, not tables and columns.
            List<Product> tennis = em.createQuery(
                    "select p from Product p where upper(p.description) like :d order by p.id",
                    Product.class)
                .setParameter("d", "%TENNIS%")
                .getResultList();
            tennis.forEach(System.out::println);

            // find() by primary key
            System.out.println("find(100860) -> " + em.find(Product.class, 100860L));

            // TODO (ORM-2): insert a Product inside a transaction, then roll it back.
        } finally {
            em.close();
            emf.close();
        }
    }
}
