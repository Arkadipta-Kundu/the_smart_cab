package org.arkadipta.the_smart_cab.controller;

import org.arkadipta.the_smart_cab.entity.Ride;
import org.arkadipta.the_smart_cab.service.RideService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/rides")
public class RideController {

    @Autowired
    private RideService rideService;

    // STEP 1: POST /rides - Book a ride (NO DRIVER YET)
    @PostMapping
    public ResponseEntity<Ride> bookRide(@RequestBody Map<String, Object> rideRequest) {
        String pickupLocation = (String) rideRequest.get("pickupLocation");
        String dropLocation = (String) rideRequest.get("dropLocation");
        Long userId = ((Number) rideRequest.get("userId")).longValue();
        Double fare = ((Number) rideRequest.get("fare")).doubleValue();

        Ride ride = rideService.bookRide(pickupLocation, dropLocation, userId, fare);
        return new ResponseEntity<>(ride, HttpStatus.CREATED);
    }

    // STEP 2: PUT /rides/{rideId}/assign - Assign driver to ride
    @PutMapping("/{rideId}/assign")
    public ResponseEntity<Ride> assignDriver(@PathVariable Long rideId) {
        Ride ride = rideService.assignDriver(rideId);
        return ResponseEntity.ok(ride);
    }

    // STEP 3: PUT /rides/{rideId}/accept - Driver accepts ride
    @PutMapping("/{rideId}/accept")
    public ResponseEntity<Ride> acceptRide(@PathVariable Long rideId, @RequestParam Long driverId) {
        Ride ride = rideService.acceptRide(rideId, driverId);
        return ResponseEntity.ok(ride);
    }

    // STEP 4: PUT /rides/{rideId}/reject - Driver rejects ride
    @PutMapping("/{rideId}/reject")
    public ResponseEntity<Ride> rejectRide(@PathVariable Long rideId, @RequestParam Long driverId) {
        Ride ride = rideService.rejectRide(rideId, driverId);
        return ResponseEntity.ok(ride);
    }

    // STEP 5: PUT /rides/{rideId}/start - Driver starts ride
    @PutMapping("/{rideId}/start")
    public ResponseEntity<Ride> startRide(@PathVariable Long rideId, @RequestParam Long driverId) {
        Ride ride = rideService.startRide(rideId, driverId);
        return ResponseEntity.ok(ride);
    }

    // STEP 6: PUT /rides/{rideId}/complete - Complete ride
    @PutMapping("/{rideId}/complete")
    public ResponseEntity<Ride> completeRide(@PathVariable Long rideId, @RequestParam Long driverId) {
        Ride ride = rideService.completeRide(rideId, driverId);
        return ResponseEntity.ok(ride);
    }

    // PUT /rides/{rideId}/cancel - Cancel ride
    @PutMapping("/{rideId}/cancel")
    public ResponseEntity<Ride> cancelRide(@PathVariable Long rideId, @RequestParam Long userId) {
        Ride ride = rideService.cancelRide(rideId, userId);
        return ResponseEntity.ok(ride);
    }

    // GET /rides - Get all rides
    @GetMapping
    public ResponseEntity<List<Ride>> getAllRides() {
        List<Ride> rides = rideService.getAllRides();
        return ResponseEntity.ok(rides);
    }

    // GET /rides/{id} - Get ride by ID
    @GetMapping("/{id}")
    public ResponseEntity<Ride> getRideById(@PathVariable Long id) {
        Ride ride = rideService.getRideById(id);
        return ResponseEntity.ok(ride);
    }
}
