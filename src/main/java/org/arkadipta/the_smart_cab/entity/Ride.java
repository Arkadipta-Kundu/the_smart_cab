package org.arkadipta.the_smart_cab.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "rides")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Ride {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String pickupLocation;

    private String dropLocation;

    private Integer pickupLocationCode;

    private Integer dropLocationCode;

    private Double distance; // in km

    @Enumerated(EnumType.STRING)
    private RideStatus status;

    private Long userId;

    private Long driverId;

    private Double fare;
}
