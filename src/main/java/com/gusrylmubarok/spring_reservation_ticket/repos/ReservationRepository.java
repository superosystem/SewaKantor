package com.gusrylmubarok.spring_reservation_ticket.repos;

import com.gusrylmubarok.spring_reservation_ticket.model.AmenityType;
import com.gusrylmubarok.spring_reservation_ticket.model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;


public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findReservationsByAmenityType(AmenityType amenityType);

    List<Reservation> findReservationsByReservationDateAndStartTimeBeforeAndEndTimeAfterOrStartTimeBetween
            (LocalDate reservationDate, LocalTime startTime, LocalTime endTime, LocalTime betweenStart, LocalTime betweenEnd);
}
