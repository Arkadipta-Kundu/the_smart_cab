package org.arkadipta.the_smart_cab.controller.rest;

import org.arkadipta.the_smart_cab.entity.Location;
import org.arkadipta.the_smart_cab.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/locations")
public class LocationController {

    @Autowired
    private LocationService locationService;

    // Create a new location
    @PostMapping
    public ResponseEntity<Location> createLocation(@RequestBody Location location) {
        Location savedLocation = locationService.saveLocation(location);
        return new ResponseEntity<>(savedLocation, HttpStatus.CREATED);
    }

    // Get all locations
    @GetMapping
    public ResponseEntity<List<Location>> getAllLocations() {
        List<Location> locations = locationService.getAllLocations();
        return ResponseEntity.ok(locations);
    }

    // Get location by ID
    @GetMapping("/{id}")
    public ResponseEntity<Location> getLocationById(@PathVariable Long id) {
        Location location = locationService.getLocationById(id);
        return ResponseEntity.ok(location);
    }

    // Get location by code
    @GetMapping("/code/{code}")
    public ResponseEntity<Location> getLocationByCode(@PathVariable Integer code) {
        Location location = locationService.getLocationByCode(code);
        return ResponseEntity.ok(location);
    }

    // Calculate distance between two locations
    @GetMapping("/distance")
    public ResponseEntity<Map<String, Object>> calculateDistance(
            @RequestParam Integer pickupCode,
            @RequestParam Integer dropCode) {

        double distance = locationService.calculateDistance(pickupCode, dropCode);

        Map<String, Object> response = new HashMap<>();
        response.put("pickupCode", pickupCode);
        response.put("dropCode", dropCode);
        response.put("distance", distance);
        response.put("unit", "km");
        response.put("formula", "abs(pickupCode - dropCode) * 5");

        return ResponseEntity.ok(response);
    }

    // Update location
    @PutMapping("/{id}")
    public ResponseEntity<Location> updateLocation(
            @PathVariable Long id,
            @RequestBody Location location) {

        location.setId(id);
        Location updatedLocation = locationService.saveLocation(location);
        return ResponseEntity.ok(updatedLocation);
    }

    // Delete location
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteLocation(@PathVariable Long id) {
        locationService.deleteLocation(id);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Location deleted successfully");
        response.put("id", id.toString());

        return ResponseEntity.ok(response);
    }
}
