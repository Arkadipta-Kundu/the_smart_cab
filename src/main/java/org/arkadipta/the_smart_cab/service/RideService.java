package org.arkadipta.the_smart_cab.service;

import org.arkadipta.the_smart_cab.entity.Driver;
import org.arkadipta.the_smart_cab.entity.Location;
import org.arkadipta.the_smart_cab.entity.Ride;
import org.arkadipta.the_smart_cab.entity.RideStatus;
import org.arkadipta.the_smart_cab.exception.DriverNotAvailableException;
import org.arkadipta.the_smart_cab.exception.InvalidRideStatusException;
import org.arkadipta.the_smart_cab.exception.RideNotFoundException;
import org.arkadipta.the_smart_cab.repository.DriverRepository;
import org.arkadipta.the_smart_cab.repository.RideRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RideService {

    @Autowired
    private RideRepository rideRepository;

    @Autowired
    private DriverRepository driverRepository;

    @Autowired
    private LocationService locationService;

    // OLD fare calculation method (kept for backward compatibility)
    private Double calculateFare(String pickupLocation, String dropLocation) {
        double baseFare = 50.0;
        int pickupLength = pickupLocation != null ? pickupLocation.length() : 0;
        int dropLength = dropLocation != null ? dropLocation.length() : 0;
        return baseFare + (pickupLength + dropLength) * 5.0;
    }

    // NEW fare calculation using location codes and distance
    // Formula: fare = 50 + (distance * 12)
    // Where distance = abs(pickupCode - dropCode) * 5 km
    private Double calculateFareByLocationCode(Integer pickupCode, Integer dropCode) {
        double distance = locationService.calculateDistance(pickupCode, dropCode);
        double baseFare = 50.0;
        double perKmRate = 12.0;
        return baseFare + (distance * perKmRate);
    }

    // STEP 1: Book Ride (NO DRIVER YET)
    public Ride bookRide(String pickupLocation, String dropLocation, Long userId, Double fare) {
        Ride ride = new Ride();
        ride.setPickupLocation(pickupLocation);
        ride.setDropLocation(dropLocation);
        ride.setUserId(userId);

        // Calculate fare automatically if not provided
        if (fare == null || fare == 0) {
            fare = calculateFare(pickupLocation, dropLocation);
        }
        ride.setFare(fare);
        ride.setStatus(RideStatus.REQUESTED);
        ride.setDriverId(null); // No driver assigned yet

        return rideRepository.save(ride);
    }

    // NEW: Book Ride using location codes
    public Ride bookRideWithLocationCodes(Integer pickupCode, Integer dropCode, Long userId) {
        // Get location names from codes
        Location pickupLoc = locationService.getLocationByCode(pickupCode);
        Location dropLoc = locationService.getLocationByCode(dropCode);

        Ride ride = new Ride();
        ride.setPickupLocation(pickupLoc.getName());
        ride.setDropLocation(dropLoc.getName());
        ride.setPickupLocationCode(pickupCode);
        ride.setDropLocationCode(dropCode);
        ride.setUserId(userId);

        // Calculate distance
        double distance = locationService.calculateDistance(pickupCode, dropCode);
        ride.setDistance(distance);

        // Calculate fare using new formula
        double fare = calculateFareByLocationCode(pickupCode, dropCode);
        ride.setFare(fare);

        ride.setStatus(RideStatus.REQUESTED);
        ride.setDriverId(null);

        return rideRepository.save(ride);
    }

    // STEP 2: Assign Driver (SIMPLE LOGIC)
    public Ride assignDriver(Long rideId) {
        // Get the ride
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in REQUESTED status
        if (ride.getStatus() != RideStatus.REQUESTED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "REQUESTED");
        }

        // Find first available driver
        List<Driver> availableDrivers = driverRepository.findAll().stream()
                .filter(driver -> driver.getAvailable() != null && driver.getAvailable())
                .toList();

        if (availableDrivers.isEmpty()) {
            throw new DriverNotAvailableException();
        }

        Driver driver = availableDrivers.get(0); // Get first available driver

        // Assign driver to ride
        ride.setDriverId(driver.getId());
        ride.setStatus(RideStatus.ASSIGNED);

        // Mark driver as unavailable
        driver.setAvailable(false);
        driverRepository.save(driver);

        return rideRepository.save(ride);
    }

    // STEP 3: Complete Ride
    public Ride completeRide(Long rideId) {
        // Get the ride
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in ASSIGNED status
        if (ride.getStatus() != RideStatus.ASSIGNED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "ASSIGNED");
        }

        // Mark ride as completed
        ride.setStatus(RideStatus.COMPLETED);

        // Mark driver as available again
        if (ride.getDriverId() != null) {
            Optional<Driver> driverOptional = driverRepository.findById(ride.getDriverId());
            if (driverOptional.isPresent()) {
                Driver driver = driverOptional.get();
                driver.setAvailable(true);
                driverRepository.save(driver);
            }
        }

        return rideRepository.save(ride);
    }

    // Get all rides
    public List<Ride> getAllRides() {
        return rideRepository.findAll();
    }

    // Get ride by ID
    public Ride getRideById(Long id) {
        return rideRepository.findById(id)
                .orElseThrow(() -> new RideNotFoundException(id));
    }
}
