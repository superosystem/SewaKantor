package com.gusrylmubarok.spring_reservation_ticket.repos;

import com.gusrylmubarok.spring_reservation_ticket.model.User;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, Long> {
    User findUserByUsername(String username);
}
