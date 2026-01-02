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

    // STEP 2: Assign Driver (LOCATION-BASED MATCHING)
    public Ride assignDriver(Long rideId) {
        // Get the ride
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in REQUESTED status
        if (ride.getStatus() != RideStatus.REQUESTED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "REQUESTED");
        }

        // Get pickup location code from ride
        Integer pickupCode = ride.getPickupLocationCode();
        if (pickupCode == null) {
            throw new RuntimeException("Ride does not have pickup location code");
        }

        // Find all available drivers
        List<Driver> availableDrivers = driverRepository.findAll().stream()
                .filter(driver -> driver.getAvailable() != null && driver.getAvailable())
                .filter(driver -> driver.getCurrentLocationCode() != null)
                .toList();

        if (availableDrivers.isEmpty()) {
            throw new DriverNotAvailableException();
        }

        // Find nearest driver by comparing location codes
        // Distance = abs(driverLocationCode - pickupLocationCode)
        Driver nearestDriver = availableDrivers.stream()
                .min((d1, d2) -> {
                    int distance1 = Math.abs(d1.getCurrentLocationCode() - pickupCode);
                    int distance2 = Math.abs(d2.getCurrentLocationCode() - pickupCode);
                    return Integer.compare(distance1, distance2);
                })
                .orElseThrow(() -> new DriverNotAvailableException());

        // Assign nearest driver to ride
        ride.setDriverId(nearestDriver.getId());
        ride.setStatus(RideStatus.DRIVER_ASSIGNED);

        // Mark driver as unavailable
        nearestDriver.setAvailable(false);
        driverRepository.save(nearestDriver);

        return rideRepository.save(ride);
    }

    // STEP 3: Driver accepts ride
    public Ride acceptRide(Long rideId, Long driverId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in DRIVER_ASSIGNED status
        if (ride.getStatus() != RideStatus.DRIVER_ASSIGNED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "DRIVER_ASSIGNED");
        }

        // Verify it's the assigned driver
        if (!ride.getDriverId().equals(driverId)) {
            throw new RuntimeException("Only assigned driver can accept this ride");
        }

        ride.setStatus(RideStatus.DRIVER_ACCEPTED);
        return rideRepository.save(ride);
    }

    // STEP 4: Driver rejects ride - reassign to next driver
    public Ride rejectRide(Long rideId, Long driverId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in DRIVER_ASSIGNED status
        if (ride.getStatus() != RideStatus.DRIVER_ASSIGNED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "DRIVER_ASSIGNED");
        }

        // Verify it's the assigned driver
        if (!ride.getDriverId().equals(driverId)) {
            throw new RuntimeException("Only assigned driver can reject this ride");
        }

        // Mark current driver as available again
        Optional<Driver> driverOptional = driverRepository.findById(driverId);
        if (driverOptional.isPresent()) {
            Driver driver = driverOptional.get();
            driver.setAvailable(true);
            driverRepository.save(driver);
        }

        // Reset ride status and try to assign to next driver
        ride.setDriverId(null);
        ride.setStatus(RideStatus.REQUESTED);
        rideRepository.save(ride);

        // Auto-assign to next nearest driver
        return assignDriver(rideId);
    }

    // STEP 5: Driver starts the ride
    public Ride startRide(Long rideId, Long driverId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in DRIVER_ACCEPTED status
        if (ride.getStatus() != RideStatus.DRIVER_ACCEPTED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "DRIVER_ACCEPTED");
        }

        // Verify it's the assigned driver
        if (!ride.getDriverId().equals(driverId)) {
            throw new RuntimeException("Only assigned driver can start this ride");
        }

        ride.setStatus(RideStatus.STARTED);
        return rideRepository.save(ride);
    }

    // STEP 6: Complete Ride
    public Ride completeRide(Long rideId, Long driverId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Check if ride is in STARTED status
        if (ride.getStatus() != RideStatus.STARTED) {
            throw new InvalidRideStatusException(rideId, ride.getStatus(), "STARTED");
        }

        // Verify it's the assigned driver
        if (!ride.getDriverId().equals(driverId)) {
            throw new RuntimeException("Only assigned driver can complete this ride");
        }

        ride.setStatus(RideStatus.COMPLETED);

        // Mark driver as available again
        Optional<Driver> driverOptional = driverRepository.findById(driverId);
        if (driverOptional.isPresent()) {
            Driver driver = driverOptional.get();
            driver.setAvailable(true);
            driverRepository.save(driver);
        }

        return rideRepository.save(ride);
    }

    // Cancel ride
    public Ride cancelRide(Long rideId, Long userId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RideNotFoundException(rideId));

        // Only user who booked can cancel
        if (!ride.getUserId().equals(userId)) {
            throw new RuntimeException("Only the user who booked can cancel this ride");
        }

        // Can only cancel if not started
        if (ride.getStatus() == RideStatus.STARTED || ride.getStatus() == RideStatus.COMPLETED) {
            throw new RuntimeException("Cannot cancel ride in " + ride.getStatus() + " status");
        }

        ride.setStatus(RideStatus.CANCELLED);

        // Free the driver if assigned
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

    // Get rides by user ID
    public List<Ride> getRidesByUserId(Long userId) {
        return rideRepository.findAll().stream()
                .filter(ride -> ride.getUserId().equals(userId))
                .toList();
    }

    // Get rides by driver ID
    public List<Ride> getRidesByDriverId(Long driverId) {
        return rideRepository.findAll().stream()
                .filter(ride -> ride.getDriverId() != null && ride.getDriverId().equals(driverId))
                .toList();
    }

    // Get pending rides for driver (DRIVER_ASSIGNED status)
    public List<Ride> getPendingRidesForDriver(Long driverId) {
        return rideRepository.findAll().stream()
                .filter(ride -> ride.getDriverId() != null &&
                        ride.getDriverId().equals(driverId) &&
                        ride.getStatus() == RideStatus.DRIVER_ASSIGNED)
                .toList();
    }

    // Get active ride for driver (DRIVER_ACCEPTED or STARTED)
    public Optional<Ride> getActiveRideForDriver(Long driverId) {
        return rideRepository.findAll().stream()
                .filter(ride -> ride.getDriverId() != null &&
                        ride.getDriverId().equals(driverId) &&
                        (ride.getStatus() == RideStatus.DRIVER_ACCEPTED ||
                                ride.getStatus() == RideStatus.STARTED))
                .findFirst();
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
