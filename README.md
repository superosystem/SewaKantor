# Spring Reservation Ticket
I have created simple Web Application that service to reservation ticket.

## Tech Stack
- [Java 11](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Hibernate](https://hibernate.org/)
- [Maven](https://maven.apache.org/)
- [JPA](https://docs.oracle.com/javaee/6/tutorial/doc/bnbpz.html)
- [MySQL](https://www.mysql.com/)
- [Thymeleaf](https://www.thymeleaf.org/)
- [Bootstrap](https://mvnrepository.com/artifact/org.webjars/bootstrap)
- [Spring Security](https://spring.io/projects/spring-security)

## Access Application
<b>username : ```user``` <br>
password : ```userpassword```</b>

## Run Locally
<b>Pre-requisite</b>: you have installed [docker](https://docs.docker.com/engine/install/) and [docker-compose](https://docs.docker.com/compose/install/) on your local environment.
Clone the project
```bash
$ git clone https://github.com/gusrylmubarok/spring-reservation-ticket
```

Go to the project directory

```bash
$ cd spring-reservation-ticket
```
Build docker image

```bash
$ docker-compose -f docker-compose.yml up
```

Make database on MySQL

```bash
$ docker exec -it reservation_ticket_con /bin/bash
$ mysql -h localhost -u root
$ create database spring_reservation_ticket;
```

## Documentation

- [Database, homapage, login page, ticket lists and form reservation images.](https://github.com/gusrylmubarok/spring-reservation-ticket/blob/main/documentation/)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
