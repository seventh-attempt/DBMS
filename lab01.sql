-- can use "SET search_path TO aviacompany" comand
-- 	to avoid writing aviacompany before table name


-- SCHEMA --

CREATE SCHEMA aviacompany;


-- TABLES --

CREATE TABLE aviacompany.airports (
	id BIGSERIAL PRIMARY KEY,
	location VARCHAR(20) NOT NULL,
	UNIQUE (location)
);

CREATE TABLE aviacompany.planes (
	id BIGSERIAL PRIMARY KEY,
	model VARCHAR(20) NOT NULL,
	capacity INTEGER NOT NULL,
	UNIQUE (model)
);

CREATE TABLE aviacompany.inventory (
	id BIGSERIAL PRIMARY KEY,
	airport INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
	plane INTEGER REFERENCES aviacompany.planes (id) ON DELETE CASCADE,
	amount INTEGER NOT NULL,
	UNIQUE (airport, plane)
);

CREATE TABLE aviacompany.chiefs (
	id BIGSERIAL PRIMARY KEY,
	second_name VARCHAR(20) UNIQUE NOT NULL,
	airport integer UNIQUE REFERENCES aviacompany.airports (id) ON DELETE CASCADE
);

CREATE TABLE aviacompany.contacts (
	id BIGSERIAL PRIMARY KEY,
	contact VARCHAR(20) NOT NULL,
	airport INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
	UNIQUE (contact)
);

CREATE TABLE aviacompany.routes (
	id BIGSERIAL PRIMARY KEY,
	start_point INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
	end_point INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
	race_day VARCHAR(3) NOT NULL,
	race_time TIME NOT NULL,
	is_active BOOLEAN DEFAULT TRUE,
	UNIQUE (start_point, end_point)
);

CREATE TABLE aviacompany.chiefs_log (
	id BIGSERIAL PRIMARY KEY,
	operation VARCHAR(10) NOT NULL,
	stamp TIMESTAMP NOT NULL,
	second_name VARCHAR(20) NOT NULL,
	airport INTEGER NOT NULL
);


-- FUNCTIONS and TRIGGERS --

CREATE FUNCTION aviacompany.chiefs_audit_func()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'DELETE', now(), OLD.second_name, NEW.airport;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'UPDATE', now(), NEW.second_name, NEW.airport;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'INSERT', now(), NEW.second_name, NEW.airport;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chiefs_audit AFTER INSERT OR UPDATE OR DELETE ON aviacompany.chiefs
	FOR EACH ROW EXECUTE PROCEDURE aviacompany.chiefs_audit_func();


CREATE FUNCTION aviacompany.disable_route_func()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE aviacompany.routes SET is_active = FALSE WHERE start_point = OLD.start_point AND end_point = OLD.end_point;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER disable_route BEFORE DELETE ON aviacompany.routes
	FOR EACH ROW EXECUTE PROCEDURE aviacompany.disable_route_func();


CREATE FUNCTION aviacompany.safe_update_func()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (SELECT routes.id FROM aviacompany.routes WHERE routes.id = OLD.id AND aviacompany.routes.is_active = FALSE) THEN
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER safe_update BEFORE UPDATE ON aviacompany.routes
	FOR EACH ROW EXECUTE PROCEDURE aviacompany.safe_update_func();


CREATE FUNCTION aviacompany.week_day_check_func()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.race_day NOT IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun') THEN
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER week_day_check BEFORE INSERT OR UPDATE ON aviacompany.routes
	FOR EACH ROW EXECUTE PROCEDURE aviacompany.week_day_check_func();


-- INSERTS --

INSERT INTO aviacompany.airports (location) VALUES
	('Minsk'), ('Moscow'), ('Beijing'), ('Dhaka'),
	('New York'), ('Osaka'), ('Budapest'),
	('Phoneix'), ('Munich'), ('Prague');

INSERT INTO aviacompany.planes (model, capacity) VALUES
	('Boeing 737', 100), ('CRAIC CR929', 50), ('Airbus A320', 95),
	('Boeing 747', 115), ('Duglas DC-3', 200), ('Embaraer 190', 150),
	('Boeing 737-8', 300), ('Beechcraft', 70);

INSERT INTO aviacompany.inventory (airport, plane, amount) VALUES
	(1, 1, 12), (1, 4, 3), (2, 4, 35), (3, 6, 9),
	(4, 2, 7), (5, 5, 25), (5, 7, 20), (6, 5, 15),
	(7, 8, 4), (8, 3, 13), (9, 2, 5), (9, 4, 12),
	(10, 8, 10);

INSERT INTO aviacompany.chiefs (second_name, airport) VALUES
	('Zager', 4), ('Labar', 5), ('Fraley', 8),
	('Beddingfield', 1), ('Montelongo', 10),
	('Palmore', 3), ('Detwiler', 2), ('Packett', 6),
	('Hanningan', 7), ('Feltman', 9);

INSERT INTO aviacompany.contacts (contact, airport) VALUES
	('airport1@gmail.com', 1), ('airport1_1@gmail.com', 1),
	('airport2@gmail.com', 2), ('airport3@gmail.com', 3),
	('airport4@gmail.com', 4), ('airport4_1@gmail.com', 4),
	('airport5@gmail.com', 5), ('airport6@gmail.com', 6),
	('airport7@gmail.com', 7), ('airport8@gmail.com', 8),
	('airport9@gmail.com', 9), ('airport10@gmail.com', 10);

INSERT INTO aviacompany.routes (start_point, end_point, race_day, race_time) VALUES
	(1, 2, 'Mon', '16:13:00'), (1, 10, 'Thu', '04:00:00'), (2, 1, 'Wed', '17:15:00'),
	(2, 5, 'Fri', '23:05:00'), (2, 9, 'Tue', '19:20:00'), (3, 4, 'Sun', '22:50:00'),
	(3, 6, 'Wed', '21:10:00'), (4, 3, 'Sat', '09:00:00'), (4, 5, 'Fri', '12:47:00'),
	(5, 2, 'Mon', '18:25:00'), (5, 4, 'Tue', '13:14:15'), (5, 8, 'Thu', '23:55:00'),
	(6, 3, 'Tue', '20:20:00'), (7, 8, 'Fri', '15:27:00'), (7, 10, 'Wed', '05:00:00'),
	(8, 5, 'Fri', '17:21:00'), (8, 7, 'Sat', '01:02:03'), (9, 2, 'Sun', '16:00:00'),
	(10, 1, 'Tue', '21:34:00'), (10, 7, 'Thu', '02:40:00');


-- PROCEDURES --

CREATE PROCEDURE aviacompany.create_route(dep_point VARCHAR, day_1 VARCHAR, time_1 TIME, destination VARCHAR, day_2 VARCHAR, time_2 TIME) AS $$
DECLARE
	first_airport INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = dep_point);
	second_airport INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = destination);
BEGIN
	INSERT INTO aviacompany.routes(start_point, end_point, race_day, race_time) VALUES (first_airport, second_airport, day_1, time_1);
	INSERT INTO aviacompany.routes(start_point, end_point, race_day, race_time) VALUES (second_airport, first_airport, day_2, time_2);
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE aviacompany.add_plane(airport_location VARCHAR, plane_model VARCHAR, planes_amount INTEGER) AS $$
DECLARE
	airport_id INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = airport_location);
	plane_id INTEGER := (SELECT planes.id FROM aviacompany.planes WHERE planes.model = plane_model);
BEGIN
	INSERT INTO aviacompany.inventory(airport, plane, amount) VALUES (airport_id, plane_id, planes_amount);
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE aviacompany.change_chief(airport_location VARCHAR, chief_second_name VARCHAR) AS $$
DECLARE
	airport_id INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = airport_location);
BEGIN
	UPDATE aviacompany.chiefs
		SET second_name = chief_second_name WHERE chiefs.airport = airport_id;
END;
$$ LANGUAGE plpgsql;


-- VIEWS --

CREATE VIEW aviacompany.check_routes AS 
	SELECT aviacompany.id AS id, first_airport.location AS departure_point, last_airport.location AS destination FROM aviacompany.routes AS route
	JOIN aviacompany.airports AS first_airport ON first_airport.id = route.start_point
	JOIN aviacompany.airports AS last_airport ON last_airport.id = route.end_point;

CREATE VIEW aviacompany.airport_info AS
	SELECT airport.id AS id, airport.location AS airport_location, chief.second_name AS chief_name,
		contacts.contact AS contact, planes.model AS plane FROM aviacompany.airports AS airport
	JOIN aviacompany.chiefs AS chief ON chief.airport = airport.id
	JOIN aviacompany.contacts AS contacts ON contacts.airport = airport.id
	JOIN aviacompany.inventory AS inventory ON inventory.airport = airport.id
	JOIN aviacompany.planes AS planes ON planes.id = inventory.plane;

CREATE VIEW aviacompany.inventory_check AS
	SELECT inventory.id AS id, airport.location AS airport_location, plane.model AS plane,
		plane.capacity AS plane_capacity, inventory.amount AS amount FROM aviacompany.inventory AS inventory
	JOIN aviacompany.airports AS airport ON airport.id = inventory.airport
	JOIN aviacompany.planes AS plane ON plane.id = inventory.plane;


-- VERIFICATION SECTION --

SELECT * FROM aviacompany.airports;
SELECT * FROM aviacompany.chiefs;
SELECT * FROM aviacompany.contacts;
SELECT * FROM aviacompany.inventory;
SELECT * FROM aviacompany.planes;
SELECT * FROM aviacompany.routes;
SELECT * FROM aviacompany.chiefs_log;

CALL aviacompany.add_plane('Dhaka', 'Beechcraft', 3);
CALL aviacompany.change_chief('Dhaka', 'Dennis');
CALL aviacompany.create_route('Phoneix', 'Tue', '22:15:00', 'Dhaka', 'Wed', '09:00:00');

SELECT * FROM aviacompany.airport_info;
SELECT * FROM aviacompany.check_routes;
SELECT * FROM aviacompany.inventory_check;

CALL aviacompany.change_chief('Dhaka', 'Dennis');
DELETE FROM aviacompany.routes where id = 15;
UPDATE aviacompany.routes SET is_active = TRUE WHERE id = 15;
INSERT INTO aviacompany.routes (start_point, end_point, race_day, race_time) VALUES (4, 8, 'Wen', '11:12:13');


-- DROP SECTION --

DROP TRIGGER chiefs_audit ON aviacompany.chiefs;
DROP TRIGGER disable_route ON aviacompany.routes;
DROP TRIGGER safe_update ON aviacompany.routes;
DROP TRIGGER week_day_check ON aviacompany.routes;

DROP FUNCTION aviacompany.chiefs_audit_func;
DROP FUNCTION aviacompany.disable_route_func;
DROP FUNCTION aviacompany.safe_update_func;
DROP FUNCTION aviacompany.week_day_check_func;

DROP PROCEDURE aviacompany.add_plane;
DROP PROCEDURE aviacompany.change_chief;
DROP PROCEDURE aviacompany.create_route;

DROP VIEW aviacompany.airport_info;
DROP VIEW aviacompany.check_routes;
DROP VIEW aviacompany.inventory_check;

DROP TABLE aviacompany.routes;
DROP TABLE aviacompany.contacts;
DROP TABLE aviacompany.chiefs_log;
DROP TABLE aviacompany.chiefs;
DROP TABLE aviacompany.inventory;
DROP TABLE aviacompany.planes;
DROP TABLE aviacompany.airports;

DROP SCHEMA aviacompany;
