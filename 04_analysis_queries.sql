USE airline_operations_revenue_analytics;

-- Q1. Airline-wise total revenue
SELECT a.airline_name, SUM(t.ticket_price) AS total_revenue
FROM Tickets t
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Airlines a ON f.airline_id = a.airline_id
GROUP BY a.airline_id, a.airline_name
ORDER BY total_revenue DESC;

-- Q2. Airline-wise flight count
SELECT a.airline_name, COUNT(f.flight_id) AS total_flights
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name
ORDER BY total_flights DESC;

-- Q3. Airline-wise ticket count and revenue
SELECT a.airline_name, COUNT(t.ticket_id) AS total_tickets,
       SUM(t.ticket_price) AS total_revenue
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
JOIN Tickets t ON f.flight_id = t.flight_id
GROUP BY a.airline_id, a.airline_name
ORDER BY total_revenue DESC;

-- Q4. Average ticket price per airline
SELECT a.airline_name, AVG(t.ticket_price) AS average_ticket_price
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
JOIN Tickets t ON f.flight_id = t.flight_id
GROUP BY a.airline_id, a.airline_name
ORDER BY average_ticket_price DESC;

-- Q5. Route-wise revenue
SELECT dep.airport_code AS departure, arr.airport_code AS arrival,
       SUM(t.ticket_price) AS route_revenue
FROM Tickets t
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Airports dep ON f.departure_airport_id = dep.airport_id
JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
GROUP BY dep.airport_id, dep.airport_code, arr.airport_id, arr.airport_code
ORDER BY route_revenue DESC;

-- Q6. Route-wise ticket volume
SELECT dep.airport_code AS departure, arr.airport_code AS arrival,
       COUNT(t.ticket_id) AS ticket_volume
FROM Tickets t
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Airports dep ON f.departure_airport_id = dep.airport_id
JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
GROUP BY dep.airport_id, dep.airport_code, arr.airport_id, arr.airport_code
ORDER BY ticket_volume DESC;

-- Q7. Busiest airports
SELECT airport_code, airport_name, COUNT(*) AS flight_movements
FROM (
    SELECT departure_airport_id AS airport_id FROM Flights
    UNION ALL
    SELECT arrival_airport_id AS airport_id FROM Flights
) x
JOIN Airports a ON x.airport_id = a.airport_id
GROUP BY airport_id, airport_code, airport_name
ORDER BY flight_movements DESC;

-- Q8. Airline-wise cancellation rate
SELECT a.airline_name,
       COUNT(f.flight_id) AS total_flights,
       COUNT(CASE WHEN f.status = 'Cancelled' THEN 1 END) AS cancelled_flights,
       ROUND(COUNT(CASE WHEN f.status = 'Cancelled' THEN 1 END) * 100.0
             / COUNT(f.flight_id), 2) AS cancellation_rate
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name
ORDER BY cancellation_rate DESC;

-- Q9. Average ticket price by route
SELECT dep.airport_code AS departure, arr.airport_code AS arrival,
       AVG(t.ticket_price) AS average_ticket_price
FROM Tickets t
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Airports dep ON f.departure_airport_id = dep.airport_id
JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
GROUP BY dep.airport_id, dep.airport_code, arr.airport_id, arr.airport_code
ORDER BY average_ticket_price DESC;

-- Q10. Airline-wise delays
SELECT a.airline_name,
       COUNT(CASE WHEN f.status = 'Delayed' THEN 1 END) AS delayed_flights,
       AVG(CASE WHEN f.status = 'Delayed' THEN f.delay_minutes END) AS average_delay
FROM Airlines a
JOIN Flights f ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name
ORDER BY delayed_flights DESC, average_delay DESC;

-- Q11. Peak travel month
SELECT MONTHNAME(departure_date) AS travel_month, COUNT(*) AS total_flights
FROM Flights
GROUP BY MONTH(departure_date), MONTHNAME(departure_date)
ORDER BY total_flights DESC;

-- Q12. Top 3 revenue-generating routes
SELECT dep.airport_code AS departure, arr.airport_code AS arrival,
       SUM(t.ticket_price) AS route_revenue
FROM Tickets t
JOIN Flights f ON t.flight_id = f.flight_id
JOIN Airports dep ON f.departure_airport_id = dep.airport_id
JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
GROUP BY dep.airport_id, dep.airport_code, arr.airport_id, arr.airport_code
ORDER BY route_revenue DESC
LIMIT 3;

-- Q13. Highest-spending passengers
SELECT p.passenger_name, COUNT(t.ticket_id) AS total_tickets,
       SUM(t.ticket_price) AS total_spending
FROM Passengers p
JOIN Tickets t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id, p.passenger_name
ORDER BY total_spending DESC
LIMIT 10;

-- Q14. Repeat passengers
SELECT p.passenger_id, p.passenger_name, COUNT(t.ticket_id) AS total_tickets
FROM Passengers p
JOIN Tickets t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id, p.passenger_name
HAVING COUNT(t.ticket_id) > 1
ORDER BY total_tickets DESC;

-- Q15. Cancellation revenue impact
SELECT a.airline_name,
       COUNT(DISTINCT f.flight_id) AS total_flights,
       COUNT(DISTINCT CASE WHEN f.status = 'Cancelled' THEN f.flight_id END)
           AS cancelled_flights,
       SUM(CASE WHEN f.status = 'Cancelled' THEN t.ticket_price ELSE 0 END)
           AS cancelled_revenue
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
LEFT JOIN Tickets t ON f.flight_id = t.flight_id
GROUP BY a.airline_id, a.airline_name
ORDER BY cancelled_revenue DESC;
