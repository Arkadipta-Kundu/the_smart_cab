package org.arkadipta.the_smart_cab.exception;

public class DriverNotAvailableException extends RuntimeException {
    public DriverNotAvailableException() {
        super("No available drivers found");
    }

    public DriverNotAvailableException(String message) {
        super(message);
    }
}
