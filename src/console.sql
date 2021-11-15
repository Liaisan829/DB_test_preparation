create table airport
(
    id       serial primary key,
    name     char(255),
    location char(255) unique,
    license  int unique
);

create table plane
(
    id       serial primary key,
    model    char(30),
    document int unique
);

create table passenger
(
    id            serial primary key,
    surname       char(30),
    name          char(30),
    interPassword int unique,
    ticket        int unique
);

create table flight
(
    id               serial primary key,
    departureTime    char(5),
    arrivalTime      char(5),
    flightDuration   int,
    flightDate       date,
    departureAirport char(255) references airport (location),
    arrivalAirport   char(255) references airport (location),
    planeID          int references plane (id)
);


create table crew
(
    id               serial primary key,
    firstCaptain     char(60),
    secondCaptain    char(60),
    firstStewardess  char(60),
    secondStewardess char(60)
);

alter table passenger
    add column flightID int references flight (id);

alter table flight
    add column crewID int references crew (id);

insert into airport(name, location, license)
VALUES ('Kazan', 'Russia, Kazan', 123),
       ('Domodedovo', 'Russia, Moscow', 234),
       ('Paris', 'France, Paris', 345),
       ('London', 'UK, London', 456),
       ('Vladivostok', 'Russia, Vladivostok', 567);

insert into plane(model, document)
VALUES ('Su-27', 987),
       ('Airbus 320NEO', 876),
       ('Airbus A321', 765),
       ('Airbus A320', 654);

insert into passenger(surname, name, interPassword, ticket)
VALUES ('Titov', 'Dima', 921678, 12389),
       ('Sedov', 'Danya', 921667, 12376),
       ('Nemov', 'Sasha', 921623, 12398),
       ('Molov', 'Tim', 921692, 12332),
       ('Rogov', 'Dan', 921628, 12365);

insert into passenger(surname, name, interPassword, ticket)
VALUES ('Kitov', 'Bob', 921612, 12384);

insert into flight (departureTime, arrivalTime, flightDuration, flightDate, departureAirport, arrivalAirport, planeID,
                    crewID)
VALUES ('12:00', '13:00', 1, '12.03.2021', 'Russia, Moscow', 'Russia, Kazan', 2, 1),
       ('16:00', '21:00', 5, '12.03.2021', 'Russia, Moscow', 'UK, London', 3, 2),
       ('17:00', '23:00', 6, '15.04.2021', 'Russia, Kazan', 'Russia, Vladivostok', 1, 3),
       ('09:00', '12:00', 3, '13.04.2021', 'Russia, Moscow', 'France, Paris', 4, 4),
       ('09:00', '12:00', 3, '14.04.2021', 'Russia, Moscow', 'France, Paris', 4, 1),
       ('11:00', '18:00', 7, '28.04.2021', 'Russia, Vladivostok', 'Russia, Moscow', 2, 2),
       ('15:00', '23:00', 8, '28.04.2021', 'Russia, Vladivostok', 'Russia, Kazan', 3, 3),
       ('13:00', '18:00', 5, '15.04.2021', 'Russia, Kazan', 'UK, London', 1, 4),
       ('11:00', '18:00', 7, '29.04.2021', 'Russia, Vladivostok', 'Russia, Moscow', 2, 1),
       ('11:00', '23:00', 11, '29.04.2021', 'Russia, Vladivostok', 'France, Paris', 3, 2);


insert into crew (firstCaptain, secondCaptain, firstStewardess, secondStewardess)
VALUES ('Totov', 'Terov', 'Totova', 'Terova'),
       ('Kotov', 'Kerov', 'Kotova', 'Kerova'),
       ('Kotov', 'Terov', 'Kotova', 'Terova'),
       ('Lotov', 'Lerov', 'Lotova', 'Lerova');


-- 3 самый продолжительный по времени рейс
select *
from flight
where flightDuration = (select MAX(flightDuration) from flight);

-- 4 количество рейсов каждого аэропорта за указанный день
select airport.name, flight.flightDate, count(distinct flight.id) as amountOfFlights
from airport,
     flight
where flight.departureAirport = airport.location
  and flight.flightDate = ?
group by airport.name, flight.flightDate;

-- 5
select max(Total_count.max_count)
from (
         select sum(flight.flightDuration) as max_count
         from flight,
              passenger
         where flight.id = passenger.flightID
         group by passenger.name
     ) Total_count;

select min(Total_count.max_count)
from (
         select sum(flight.flightDuration) as max_count
         from flight,
              passenger
         where flight.id = passenger.flightID
         group by passenger.name
     ) Total_count