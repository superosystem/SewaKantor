package com.gusrylmubarok.spring_reservation_ticket;

import com.gusrylmubarok.spring_reservation_ticket.model.AmenityType;
import com.gusrylmubarok.spring_reservation_ticket.model.Capacity;
import com.gusrylmubarok.spring_reservation_ticket.model.Reservation;
import com.gusrylmubarok.spring_reservation_ticket.model.User;
import com.gusrylmubarok.spring_reservation_ticket.repos.CapacityRepository;
import com.gusrylmubarok.spring_reservation_ticket.repos.ReservationRepository;
import com.gusrylmubarok.spring_reservation_ticket.repos.UserRepository;
import org.hibernate.type.OffsetDateTimeType;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


@SpringBootApplication
public class SpringReservationTicketApplication {

    private Map<AmenityType, Integer> initialCapacities =
            new HashMap<>() {
                {
                    put(AmenityType.GYM, 20);
                    put(AmenityType.POOL, 4);
                    put(AmenityType.SAUNA, 1);
                }
            };

    public static void main(String[] args) {
        SpringApplication.run(SpringReservationTicketApplication.class, args);
    }

    @Bean
    public CommandLineRunner loadData(
            UserRepository userRepository,
            CapacityRepository capacityRepository) {
        return (args) -> {
            userRepository.save(
                    new User("Agus Syahril Mubarok", "user", bCryptPasswordEncoder().encode("userpassword")));

            for (AmenityType amenityType : initialCapacities.keySet()) {
                capacityRepository.save(new Capacity(amenityType, initialCapacities.get(amenityType)));
            }
        };
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
