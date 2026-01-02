package org.arkadipta.the_smart_cab.service;

import org.arkadipta.the_smart_cab.entity.Location;
import org.arkadipta.the_smart_cab.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {

    @Autowired
    private LocationRepository locationRepository;

    // Create or update location
    public Location saveLocation(Location location) {
        return locationRepository.save(location);
    }

    // Get all locations
    public List<Location> getAllLocations() {
        return locationRepository.findAll();
    }

    // Get location by ID
    public Location getLocationById(Long id) {
        return locationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Location not found with id: " + id));
    }

    // Get location by code
    public Location getLocationByCode(Integer code) {
        return locationRepository.findByLocationCode(code)
                .orElseThrow(() -> new RuntimeException("Location not found with code: " + code));
    }

    // Calculate distance between two location codes
    // Formula: distance = abs(pickupCode - dropCode) * 5 km
    public double calculateDistance(Integer pickupCode, Integer dropCode) {
        return Math.abs(pickupCode - dropCode) * 5.0;
    }

    // Delete location
    public void deleteLocation(Long id) {
        locationRepository.deleteById(id);
    }
}
