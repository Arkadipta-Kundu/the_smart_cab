package org.arkadipta.the_smart_cab.service;

import org.arkadipta.the_smart_cab.entity.Driver;
import org.arkadipta.the_smart_cab.entity.Location;
import org.arkadipta.the_smart_cab.exception.DriverNotFoundException;
import org.arkadipta.the_smart_cab.repository.DriverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DriverService {

    @Autowired
    private DriverRepository driverRepository;

    @Autowired
    private LocationService locationService;

    // Register a new driver
    public Driver registerDriver(Driver driver) {
        return driverRepository.save(driver);
    }

    // Get all drivers
    public List<Driver> getAllDrivers() {
        return driverRepository.findAll();
    }

    // Get available drivers only
    public List<Driver> getAvailableDrivers() {
        return driverRepository.findAll().stream()
                .filter(driver -> driver.getAvailable() != null && driver.getAvailable())
                .collect(Collectors.toList());
    }

    // Update driver availability
    public Driver updateAvailability(Long id, Boolean available) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new DriverNotFoundException(id));
        driver.setAvailable(available);
        return driverRepository.save(driver);
    }

    // Find driver by phone and password for authentication
    public Optional<Driver> findByPhoneAndPassword(String phone, String password) {
        return driverRepository.findByPhoneAndPassword(phone, password);
    }

    // Update driver location
    public Driver updateDriverLocation(Long id, Integer locationCode) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new DriverNotFoundException(id));

        // Get location name from code
        Location location = locationService.getLocationByCode(locationCode);

        driver.setCurrentLocationCode(locationCode);
        driver.setCurrentLocation(location.getName());

        return driverRepository.save(driver);
    }
}
