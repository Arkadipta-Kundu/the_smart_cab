package org.arkadipta.the_smart_cab.exception;

public class DriverNotFoundException extends RuntimeException {
    public DriverNotFoundException(Long id) {
        super("Driver not found with id: " + id);
    }
}
