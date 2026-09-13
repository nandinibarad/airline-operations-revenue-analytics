USE airline_operations_revenue_analytics;

CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE Airports (
    airport_id INT PRIMARY KEY,
    airport_code VARCHAR(10),
    airport_name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Aircrafts (
    aircraft_id INT PRIMARY KEY,
    airline_id INT,
    aircraft_name VARCHAR(100),
    aircraft_type VARCHAR(50),
    seat_capacity INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    airline_id INT,
    aircraft_id INT,
    departure_airport_id INT,
    arrival_airport_id INT,
    departure_date DATE,
    departure_time TIME,
    arrival_time TIME,
    status VARCHAR(20),
    delay_minutes INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports(airport_id)
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    country VARCHAR(50)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    seat_no VARCHAR(5) NOT NULL,
    ticket_class VARCHAR(10),
    ticket_price INT,
    booking_date DATE,
    booking_status VARCHAR(10),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    ticket_id INT,
    payment_type VARCHAR(20),
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
