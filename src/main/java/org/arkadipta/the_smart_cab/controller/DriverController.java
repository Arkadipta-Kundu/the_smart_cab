package org.arkadipta.the_smart_cab.controller;

import org.arkadipta.the_smart_cab.entity.Driver;
import org.arkadipta.the_smart_cab.service.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/drivers")
public class DriverController {

    @Autowired
    private DriverService driverService;

    // POST /drivers - Register a new driver
    @PostMapping
    public ResponseEntity<Driver> registerDriver(@RequestBody Driver driver) {
        Driver savedDriver = driverService.registerDriver(driver);
        return new ResponseEntity<>(savedDriver, HttpStatus.CREATED);
    }

    // GET /drivers - Get all drivers (with optional filter for available only)
    @GetMapping
    public ResponseEntity<List<Driver>> getDrivers(@RequestParam(required = false) Boolean available) {
        List<Driver> drivers;
        if (available != null && available) {
            drivers = driverService.getAvailableDrivers();
        } else {
            drivers = driverService.getAllDrivers();
        }
        return ResponseEntity.ok(drivers);
    }

    // PUT /drivers/{id}/availability - Update driver availability
    @PutMapping("/{id}/availability")
    public ResponseEntity<Driver> updateAvailability(@PathVariable Long id,
            @RequestParam Boolean available) {
        Driver updatedDriver = driverService.updateAvailability(id, available);
        return ResponseEntity.ok(updatedDriver);
    }

    // PUT /drivers/{id}/location - Update driver current location
    @PutMapping("/{id}/location")
    public ResponseEntity<Driver> updateLocation(@PathVariable Long id,
            @RequestParam Integer locationCode) {
        Driver driver = driverService.updateDriverLocation(id, locationCode);
        return ResponseEntity.ok(driver);
    }
}
