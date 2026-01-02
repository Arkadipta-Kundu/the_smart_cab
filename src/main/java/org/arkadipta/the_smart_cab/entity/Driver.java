package org.arkadipta.the_smart_cab.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "drivers")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Driver {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String phone;

    private String vehicleNumber;

    private Boolean available;

    private String password;

    private String currentLocation;

    private Integer currentLocationCode;

    private String role = "DRIVER";
}
