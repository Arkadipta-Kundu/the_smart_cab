package org.arkadipta.the_smart_cab.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "locations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name; // e.g., "Area A", "Downtown", "Airport"

    @Column(unique = true)
    private Integer locationCode; // e.g., 1, 2, 3, 4, 5
}
