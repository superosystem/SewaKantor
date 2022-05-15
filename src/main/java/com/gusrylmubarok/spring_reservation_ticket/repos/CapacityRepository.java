package com.gusrylmubarok.spring_reservation_ticket.repos;

import com.gusrylmubarok.spring_reservation_ticket.model.AmenityType;
import com.gusrylmubarok.spring_reservation_ticket.model.Capacity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CapacityRepository extends JpaRepository<Capacity, Long> {
    Capacity findByAmenityType(AmenityType amenityType);
}
