package org.arkadipta.the_smart_cab.exception;

import org.arkadipta.the_smart_cab.entity.RideStatus;

public class InvalidRideStatusException extends RuntimeException {
    public InvalidRideStatusException(Long rideId, RideStatus currentStatus, String expectedStatus) {
        super("Ride " + rideId + " is in " + currentStatus + " status. Expected: " + expectedStatus);
    }

    public InvalidRideStatusException(String message) {
        super(message);
    }
}
