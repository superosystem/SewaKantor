package com.gusrylmubarok.spring_reservation_ticket.model;

public enum AmenityType {
    POOL("POOL"), SAUNA("SAUNA"), GYM("GYM");

    private final String name;

    private AmenityType(String value) {
        name = value;
    }

    @Override
    public String toString() {
        return name;
    }
}
