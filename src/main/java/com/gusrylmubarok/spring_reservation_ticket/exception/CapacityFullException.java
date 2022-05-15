package com.gusrylmubarok.spring_reservation_ticket.exception;

public class CapacityFullException extends RuntimeException {
    public CapacityFullException(String message) {
        super(message);
    }
}
