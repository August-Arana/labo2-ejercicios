package labo2.orm;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/** Maps the BDEMOBLD table PRODUCT (product_id, description). */
@Entity
@Table(name = "PRODUCT")
public class Product {

    @Id
    @Column(name = "PRODUCT_ID")
    private Long id;

    @Column(name = "DESCRIPTION", length = 30)
    private String description;

    protected Product() { }          // JPA needs a no-arg constructor

    public Product(Long id, String description) {
        this.id = id;
        this.description = description;
    }

    public Long getId() { return id; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() { return id + " - " + description; }
}
