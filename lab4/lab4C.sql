
DROP VIEW IF EXISTS allFlights;
DROP TABLE IF EXISTS HasBooked CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS CreditCard CASCADE;
DROP TABLE IF EXISTS Contact CASCADE;
DROP TABLE IF EXISTS Passenger CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Flight CASCADE;
DROP TABLE IF EXISTS WeeklySchedule CASCADE;
DROP TABLE IF EXISTS Route CASCADE;
DROP TABLE IF EXISTS Airport CASCADE;
DROP TABLE IF EXISTS Day CASCADE;
DROP TABLE IF EXISTS Year CASCADE;


DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;


CREATE TABLE Year(
    yearNumber INT,
    factor DOUBLE,
    CONSTRAINT pk_Year PRIMARY KEY(yearNumber)
) ENGINE=InnoDB;


CREATE TABLE Day(
    year INT,
    day VARCHAR(10),
    factor DOUBLE,
    CONSTRAINT pk_Day PRIMARY KEY(year, day)
) ENGINE=InnoDB;


CREATE TABLE Airport(
    code VARCHAR(3),
    name VARCHAR(30),
    country VARCHAR(30),
    CONSTRAINT pk_Airport PRIMARY KEY(code)
) ENGINE=InnoDB;


CREATE TABLE Route(
    routeID INT AUTO_INCREMENT,
    codeDeparture VARCHAR(3),
    codeArrival VARCHAR(3),
    year INT,
    routePrice DOUBLE,
    CONSTRAINT pk_Route PRIMARY KEY(routeID)
) ENGINE=InnoDB;


CREATE TABLE WeeklySchedule(
    weeklyScheduleID INT AUTO_INCREMENT,
    routeID INT,
    departureTime TIME,
    yearNumber INT,
    day VARCHAR(10), -- new
    CONSTRAINT pk_weeklyScheduleID PRIMARY KEY(weeklyScheduleID)
) ENGINE=InnoDB;


CREATE TABLE Flight(
    flightID INT AUTO_INCREMENT,
    weeklyScheduleID INT,
    weeks INT,
    CONSTRAINT pk_Flight PRIMARY KEY(flightID)
) ENGINE=InnoDB;


CREATE TABLE Reservation(
    reservationID INT AUTO_INCREMENT,
    numPassengers INT,
    flightID INT,
    CONSTRAINT pk_Reservation PRIMARY KEY(reservationID)
) ENGINE=InnoDB;


CREATE TABLE Passenger(
	reservationNum INT,
    passportNum INT,
    fullName VARCHAR(30),
    CONSTRAINT pk_Passenger PRIMARY KEY(reservationNum, passportNum)
) ENGINE=InnoDB;


CREATE TABLE Contact(
reservationID INT,
passportNum INT,
email VARCHAR(30),
phoneNumber BIGINT,
CONSTRAINT pk_Contact PRIMARY KEY(reservationID)
) ENGINE=InnoDB;


CREATE TABLE Booking(
    bookingID INT AUTO_INCREMENT,
    reservationID INT,
    price INT,
    creditCardNum BIGINT,
    CONSTRAINT pk_Booking PRIMARY KEY(bookingID,reservationID)
) ENGINE=InnoDB;


CREATE TABLE HasBooked(
    bookingID INT,
    passportNum INT,
    ticketID INT,
    CONSTRAINT pk_HasBooked PRIMARY KEY(bookingID,passportNum)
) ENGINE=InnoDB;


CREATE TABLE CreditCard(
    cardNumber BIGINT,
    cardHolder VARCHAR(30),
    CONSTRAINT pk_CreditCard PRIMARY KEY(cardNumber)
) ENGINE=InnoDB;



-- Add foreign keys
ALTER TABLE Day ADD CONSTRAINT fk_Day_year FOREIGN KEY (year) REFERENCES Year(yearNumber);

ALTER TABLE Route ADD CONSTRAINT fk_Route_codeArrival FOREIGN KEY (codeArrival) REFERENCES Airport(code);
ALTER TABLE Route ADD CONSTRAINT fk_Route_codeDeparture FOREIGN KEY (codeDeparture) REFERENCES Airport(code);

ALTER TABLE WeeklySchedule ADD CONSTRAINT fk_WeeklySchedule_routeID FOREIGN KEY (routeID) REFERENCES Route(routeID);
ALTER TABLE WeeklySchedule ADD CONSTRAINT fk_WeeklySchedule_yearNumber FOREIGN KEY (yearNumber, day) REFERENCES Day(year, day);

ALTER TABLE Flight ADD CONSTRAINT fk_Flight_weeklyScheduleID FOREIGN KEY (weeklyScheduleID) REFERENCES WeeklySchedule(weeklyScheduleID);

ALTER TABLE Reservation ADD CONSTRAINT fk_Reservation_flightID FOREIGN KEY (flightID) REFERENCES Flight(flightID);

ALTER TABLE Contact ADD CONSTRAINT fk_Contact_reservationID FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID);
ALTER TABLE Contact ADD CONSTRAINT fk_Contact_reserNpassportNum FOREIGN KEY (reservationID, passportNum) REFERENCES Passenger(reservationNum, passportNum);

ALTER TABLE Booking ADD CONSTRAINT fk_Booking_reservationID FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID);
ALTER TABLE Booking ADD CONSTRAINT fk_Booking_creditCardNum FOREIGN KEY (creditCardNum) REFERENCES CreditCard(cardNumber);

ALTER TABLE HasBooked ADD CONSTRAINT fk_HasBooked_bookingID FOREIGN KEY (bookingID) REFERENCES Booking(bookingID);


DELIMITER //
CREATE PROCEDURE addYear(yearNumber INT, factor DOUBLE)
BEGIN
    INSERT INTO Year(yearNumber, factor) 
    VALUES (yearNumber, factor);
END;
//


DELIMITER //
CREATE PROCEDURE addDay(year INT, day VARCHAR(10), factor DOUBLE)
BEGIN
    INSERT INTO Day(year, day, factor) 
    VALUES (year, day, factor);
END;
//



DELIMITER //
CREATE PROCEDURE addDestination(airport_code VARCHAR(3), name VARCHAR(30), country VARCHAR(30))
BEGIN
    INSERT INTO Airport(code, name, country) 
    VALUES (airport_code, name, country);
END;
//


DELIMITER //
CREATE PROCEDURE addRoute(departure_airport_code VARCHAR(3), arrival_airport_code VARCHAR(3), year INT, routeprice DOUBLE)
BEGIN
    INSERT INTO Route( codeDeparture, codeArrival, year, routePrice) 
    VALUES ( departure_airport_code, arrival_airport_code, year, routeprice);
END;
//



DELIMITER //
CREATE PROCEDURE addFlight(departure_airport_code VARCHAR(3), arrival_airport_code VARCHAR(3), years INT, day VARCHAR(10), departure_time TIME)
BEGIN
	DECLARE routeid INT;
    DECLARE scheduleid INT;
    
	DECLARE count INT DEFAULT 1;
    DECLARE weeks INT DEFAULT 52; -- 52 weeks
    
	-- get routeid
    SELECT Route.routeID INTO routeid
    FROM Route
    WHERE codeDeparture = departure_airport_code
	AND codeArrival = arrival_airport_code
	AND year = years;
    
    INSERT INTO WeeklySchedule( routeID, departureTime, yearNumber, day ) 
    VALUES (routeid, departure_time, years, day);
    -- get scheduleid
    SET scheduleid = last_insert_id();

	while (count <= weeks) DO
    INSERT INTO Flight( weeklyScheduleID , weeks) 
    VALUES (scheduleid, count);
    SET count = count + 1;
	END WHILE;
END;
//


DELIMITER //
CREATE FUNCTION calculateFreeSeats(flightnumber INT) RETURNS INT
BEGIN
	DECLARE totalSeats INT DEFAULT 40;
    DECLARE totalPassengers INT;
    DECLARE freeSeats INT;
    
    SELECT IFNULL(SUM(numPassengers), 0) INTO totalPassengers
    FROM Reservation
    INNER JOIN Booking ON Reservation.reservationID = Booking.reservationID
    WHERE Reservation.flightID = flightnumber;

    SET freeSeats = totalSeats - totalPassengers;

    RETURN freeSeats;
END;
//


DELIMITER //
CREATE FUNCTION calculatePrice(flightnumber INT) RETURNS DOUBLE
BEGIN
	DECLARE seatPrice DOUBLE DEFAULT 0;
    DECLARE seatFactor DOUBLE DEFAULT 0;
    DECLARE routePrice DOUBLE DEFAULT 0;
    DECLARE dayFactor DOUBLE DEFAULT 0;
    DECLARE yearFactor DOUBLE DEFAULT 0;

    -- seatFactor
    SET seatFactor = (40 - calculateFreeSeats(flightnumber) + 1) / 40;

    -- routePrice
    SELECT Route.routePrice INTO routePrice
    FROM Route
    INNER JOIN WeeklySchedule ON Route.routeID = WeeklySchedule.routeID
    INNER JOIN Flight ON WeeklySchedule.weeklyScheduleID = Flight.weeklyScheduleID
    WHERE Flight.flightID = flightnumber;

    -- dayFactor
    SELECT Day.factor INTO dayFactor
    FROM Day
    INNER JOIN WeeklySchedule ON Day.year = WeeklySchedule.yearNumber AND Day.day = WeeklySchedule.day
    INNER JOIN Flight ON WeeklySchedule.weeklyScheduleID = Flight.weeklyScheduleID
    WHERE Flight.flightID = flightnumber;

    -- yearFactor
    SELECT Year.factor INTO yearFactor
    FROM Year
    INNER JOIN WeeklySchedule ON Year.yearNumber = WeeklySchedule.yearNumber
    INNER JOIN Flight ON WeeklySchedule.weeklyScheduleID = Flight.weeklyScheduleID
    WHERE Flight.flightID = flightnumber;

    -- Calculate seatPrice
    SET seatPrice = CAST(routePrice AS DECIMAL(10, 2)) * CAST(dayFactor AS DECIMAL(10, 2)) * CAST(seatFactor AS DECIMAL(10, 3)) * CAST(yearFactor AS DECIMAL(10, 2));

    RETURN seatPrice;
END;
//


-- reservation > paid > insert data to booking > trigger > hasbooked(ticketnum)
DELIMITER //
CREATE TRIGGER afterBookingPaid 
AFTER INSERT
ON Booking
FOR EACH ROW
BEGIN
    DECLARE uniqueTicketNum INT;
    DECLARE ticketExists INT DEFAULT 0;
    DECLARE numPassenger INT;
    DECLARE counter INT DEFAULT 0;
    
    -- count the number of passengers in passenger
    SELECT COUNT(*) INTO numPassenger
    FROM Passenger
    WHERE Passenger.reservationNum = NEW.reservationID;

	
    -- loop through each passenger
    WHILE counter < numPassenger DO
    SET uniqueTicketNum = FLOOR(RAND() * 1000000000);
        WHILE ticketExists != 0 DO
            -- generate a unique ticket number
            SET uniqueTicketNum = FLOOR(RAND() * 1000000000);
            -- check ticket number already exists or not
			SELECT COUNT(*) INTO ticketExists FROM HasBooked WHERE HasBooked.ticketID = uniqueTicketNum;
        END WHILE;
        
        -- insert to hasbooked
        INSERT INTO HasBooked (bookingID, passportNum, ticketID)
        VALUES (NEW.bookingID, (SELECT passportNum FROM Passenger WHERE reservationNum = NEW.reservationID LIMIT counter, 1), uniqueTicketNum);
        
        SET counter = counter + 1;
    END WHILE;
END;
//



DELIMITER //
CREATE PROCEDURE addReservation(departure_airport_code VARCHAR(3), arrival_airport_code VARCHAR(3), year INT, week INT, day VARCHAR(10), time TIME, number_of_passengers INT, OUT output_reservation_nr INT)
BEGIN
	DECLARE scheduleid INT;
    DECLARE flight INT;
    DECLARE freeSeats INT;
    

    -- find scheduleid
	SELECT weeklyScheduleID INTO scheduleid 
    FROM WeeklySchedule
    INNER JOIN Route ON WeeklySchedule.routeID = Route.routeID
    WHERE Route.codeDeparture = departure_airport_code 
      AND Route.codeArrival = arrival_airport_code 
      AND WeeklySchedule.yearNumber = year
      AND WeeklySchedule.day = day 
      AND WeeklySchedule.departureTime = time;

	-- find flightID
    SELECT flightID INTO flight 
    FROM Flight 
    WHERE Flight.WeeklyScheduleID = scheduleid 
      AND Flight.weeks = week;

	-- did not find scheduleid || did not find flightID
    IF scheduleid IS NULL OR flight IS NULL THEN
        SELECT "There exist no flight for the given route, date and time" AS Message;
		SET output_reservation_nr = NULL;

    ELSE
		-- calculateFreeSeats
		SET freeSeats = calculateFreeSeats(flight);
        
		-- check enough seats
		IF number_of_passengers > freeSeats THEN
			SELECT "There are not enough seats available on the chosen flight" AS Message;
			SET output_reservation_nr = NULL;
		ELSE
			-- insert reservation
			INSERT INTO Reservation (numPassengers, flightID) 
			VALUES (number_of_passengers, flight);
			SET output_reservation_nr = LAST_INSERT_ID();
            
        END IF;
	END IF;
END;
//



DELIMITER //
CREATE PROCEDURE addPassenger(reservation_nr INT, passport_number INT, name VARCHAR(30))
BEGIN
    DECLARE reservation_nr_exists INT DEFAULT 0;
    DECLARE passenger_exists INT DEFAULT 0;
    DECLARE already_paid INT DEFAULT 0;

    -- find reservation_nr
    SELECT COUNT(*) INTO reservation_nr_exists 
    FROM Reservation
    WHERE Reservation.reservationID = reservation_nr;
    
    -- there is reservation_nr
    IF reservation_nr_exists != 0 THEN
    
		-- check already_paid
		SELECT COUNT(*) INTO already_paid
        FROM Booking
        WHERE Booking.reservationID = reservation_nr;

		-- not already_paid can add passenger
		IF already_paid = 0 THEN
        
			-- check if the passenger already exists
			SELECT COUNT(*) INTO passenger_exists
			FROM Passenger 
            WHERE reservation_nr = Passenger.reservationNum
			AND passportNum = passport_number
			AND fullName = name;

			IF passenger_exists = 0 THEN
				-- insert new passenger
				INSERT INTO Passenger(reservationNum, passportNum, fullName) 
				VALUES (reservation_nr, passport_number, name);
                
			END IF;
        ELSE
        SELECT "The booking has already been payed and no futher passengers can be added" AS Message;
        END IF;
        
    ELSE
		SELECT "The given reservation number does not exist" AS Message;
	END IF;
END;
//


DELIMITER //
CREATE PROCEDURE addContact(reservation_nr INT, passport_number INT, email VARCHAR(30), phone BIGINT)
BEGIN

	DECLARE reservation_nr_exists INT DEFAULT 0;
    DECLARE is_passenger INT DEFAULT 0;
    DECLARE contact_exists INT DEFAULT 0;

    -- find reservation_nr
    SELECT COUNT(*) INTO reservation_nr_exists 
    FROM Reservation
    WHERE Reservation.reservationID = reservation_nr;


    IF reservation_nr_exists != 0 THEN
		-- check if the contact already exists
        SELECT COUNT(*) INTO contact_exists
        FROM Contact
        WHERE Contact.passportNum = passport_number 
        AND Contact.reservationID = reservation_nr;

        IF contact_exists = 0 THEN
            
			SELECT COUNT(*) INTO is_passenger
			FROM Passenger
			WHERE passportNum = passport_number;
				
			-- not a passengers
			IF is_passenger = 0 THEN
				SELECT "The person is not a passenger of the reservation" AS Message;
				
			ELSE 
				-- insert new contact
				INSERT INTO Contact(reservationID, passportNum, email, phoneNumber) 
				VALUES (reservation_nr, passport_number, email, phone);
			END IF;
        END IF;
        
    ELSE
		SELECT "The given reservation number does not exist" AS Message;
	END IF;

END;
//




DELIMITER //
CREATE PROCEDURE addPayment (reservation_nr INT, cardholder_name VARCHAR(30), credit_card_number BIGINT)
BEGIN

	DECLARE reservation_nr_exists INT DEFAULT 0;
	DECLARE have_contact INT DEFAULT 0;
    DECLARE flightid INT;
    DECLARE numofPassenger INT;
    DECLARE totalPrice DOUBLE;
    DECLARE payment_exists INT DEFAULT 0;

    -- find reservation_nr
    SELECT COUNT(*) INTO reservation_nr_exists 
    FROM Reservation
    WHERE Reservation.reservationID = reservation_nr;
    
    
    -- reservation_nr exist
    IF reservation_nr_exists != 0 THEN
		 -- check there is the contact
         SELECT COUNT(*) INTO have_contact
         FROM Contact
         WHERE reservationID = reservation_nr;

		 -- have contact can be paid
         IF have_contact != 0 THEN 

		 SELECT Reservation.flightID INTO flightid FROM Reservation WHERE Reservation.reservationID = reservation_nr;
		 SELECT COUNT(*) INTO numofPassenger FROM Passenger WHERE Passenger.reservationNum = reservation_nr;           

				IF numofPassenger > calculateFreeSeats(flightid) THEN
                    DELETE FROM Contact WHERE Contact.reservationID = reservation_nr;
					DELETE FROM Reservation WHERE Reservation.reservationID = reservation_nr;
                    DELETE FROM Passenger WHERE Passenger.reservationNum = reservation_nr;
					SELECT "There are not enough seats available on the flight anymore, deleting reservation" as Message;
                ELSE
                    SET totalPrice = calculatePrice(flightid) * numofPassenger;
                    -- SELECT SLEEP(5); -- overbooking
                    
                    -- if the payment not exist add information
					SELECT COUNT(*) INTO payment_exists
					FROM CreditCard
					WHERE CreditCard.cardNumber = credit_card_number;
                    
                    IF payment_exists = 0 THEN
						INSERT INTO CreditCard(cardNumber, cardHolder) 
						VALUES (credit_card_number, cardholder_name);
                    END IF;
                    
					INSERT INTO Booking(reservationID, price, creditCardNum)
					VALUES (reservation_nr, totalPrice, credit_card_number);
                    
                END IF;
		ELSE
			SELECT "The reservation has no contact yet" AS Message;
		END IF;
        
    ELSE
		SELECT "The given reservation number does not exist" AS Message;
	END IF;

END;
//


-- create view for all flights
CREATE VIEW allFlights AS
SELECT 
    AirportDeparture.name AS departure_city_name,
    AirportArrival.name AS destination_city_name,
    WeeklySchedule.departureTime AS departure_time,
    WeeklySchedule.day AS departure_day,
    Flight.weeks AS departure_week,
    WeeklySchedule.yearNumber AS departure_year,
    calculateFreeSeats(Flight.flightID) AS nr_of_free_seats,
    calculatePrice(Flight.flightID) AS current_price_per_seat
FROM Flight
INNER JOIN WeeklySchedule ON Flight.weeklyScheduleID = WeeklySchedule.weeklyScheduleID
INNER JOIN Route ON WeeklySchedule.routeID = Route.routeID
INNER JOIN Airport AS AirportDeparture ON Route.codeDeparture = AirportDeparture.code
INNER JOIN Airport AS AirportArrival ON Route.codeArrival = AirportArrival.code;

/*
8a:
We can encrypt the credit card number through some encryption algorithms. When we need to access the data, we can decrypt it. This way, if a hacker gains access to the database, they won't be able to obtain sensitive information directly.

8b:
Security:  stored procedures run on the database, can be better control who can access to the data and reducing the risk of unauthorized use.

Performance: executing stored procedures on the server reduces network traffic, and is faster than performing the same functions on the front end.

Convenient maintenance: make maintenance more convenient by centralizing business logic in the database, making it easier to maintain compared to spreading it out in the front-end code.


9a:
add a new reservation

9b:
The reservation is not visible in session B. This is because MySQL has the transaction isolation level Repeatable-Read as default to maintain consistency. At this isolation level, each transaction only sees data changes that were committed before the transaction began. Therefore, session B cannot see the uncommitted reservation from session A.

9c:
Try to modify the reservation from session A in session B, session get locked. This happens because MySQL locks the record in session A until the transaction is committed, ensuring data consistency.


10a: 
No overbooking occured. Both sessions attempted to reserve 21 seats simultaneously. However, only one transaction successfully locked the necessary rows, when addPayments was called concurrently, only the transaction with the lock accurately calculated available seats and successfully committed. The second transaction, found insufficient seats and was denied.


10b:
Yes, an overbooking theoretically occur.
If the first session not already execute line 497 to update the reservation, and the second session execute to the calculateFreeSeats, then the second session calculate for freeseat still is 40. This will lead to overbooking.

10c:
Add the SELECT sleep(5); at line 504  will lead to overbooking.


10d.
-- we use the lock table and unlock table to prenvent other transactions modify them.
when making reservations, adding passengers, adding contacts, and making payments, 
the tables involved will be locked to ensure that other sessions or transactions 
cannot modify or add the same data during these operations. 
Locked tables are unlocked after the operation is completed, allowing other operations to continue.

SELECT "Testing script for Question 10, Adds a booking, should be run in both terminals" as "Message";
SELECT "Adding a reservations and passengers" as "Message";
-- start transaction
START TRANSACTION;
-- lock table to prevent other transactions modify them
LOCK TABLES
    HasBooked WRITE,
    Booking WRITE,
    CreditCard WRITE,
    Contact WRITE,
    Passenger WRITE,
    Reservation WRITE,
    Flight WRITE,
    WeeklySchedule WRITE,
    Route WRITE,
    Airport WRITE,
    Day WRITE,
    Year WRITE,
    allFlights WRITE;

CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",21,@a); 
CALL addPassenger(@a,00000001,"Saruman");
CALL addPassenger(@a,00000002,"Orch1");
CALL addPassenger(@a,00000003,"Orch2");
CALL addPassenger(@a,00000004,"Orch3");
CALL addPassenger(@a,00000005,"Orch4");
CALL addPassenger(@a,00000006,"Orch5");
CALL addPassenger(@a,00000007,"Orch6");
CALL addPassenger(@a,00000008,"Orch7");
CALL addPassenger(@a,00000009,"Orch8");
CALL addPassenger(@a,00000010,"Orch9");
CALL addPassenger(@a,00000011,"Orch10");
CALL addPassenger(@a,00000012,"Orch11");
CALL addPassenger(@a,00000013,"Orch12");
CALL addPassenger(@a,00000014,"Orch13");
CALL addPassenger(@a,00000015,"Orch14");
CALL addPassenger(@a,00000016,"Orch15");
CALL addPassenger(@a,00000017,"Orch16");
CALL addPassenger(@a,00000018,"Orch17");
CALL addPassenger(@a,00000019,"Orch18");
CALL addPassenger(@a,00000020,"Orch19");
CALL addPassenger(@a,00000021,"Orch20");
CALL addContact(@a,00000001,"saruman@magic.mail",080667989); 
-- unlock table
UNLOCK TABLES;
SELECT SLEEP(5);
-- lock table for addPayment
LOCK TABLES
    HasBooked WRITE,
    Booking WRITE,
    CreditCard WRITE,
    Contact WRITE,
    Passenger WRITE,
    Reservation WRITE,
    Flight WRITE,
    WeeklySchedule WRITE,
    Route WRITE,
    Airport WRITE,
    Day WRITE,
    Year WRITE,
    allFlights WRITE;

SELECT "Making payment, supposed to work for one session and be denied for the other" as "Message";
CALL addPayment (@a, "Sauron",7878787878);
SELECT "Nr of free seats on the flight (should be 19 if no overbooking occured, otherwise -2): " as "Message", (SELECT nr_of_free_seats from allFlights where departure_week = 1) as "nr_of_free_seats";

COMMIT;
UNLOCK TABLES;


Secondary index:

CREATE INDEX idx_passportNum ON HasBooked(passportNum);
Adding a secondary index to the passportNum field in the "HasBooked" table can speed up querying booking information based on passport numbers.
Customers can quickly check all the ticket information they have booked with their passport number.
Customer service can use the passport number to quickly locate all of a customer's booking history when dealing with customer inquiries.

*/
