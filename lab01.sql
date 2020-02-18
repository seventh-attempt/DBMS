-- can use "SET search_path TO aviacompany" comand
-- 	to avoid writing aviacompany before table name

-- CREATE TABLE aviacompany.airports (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	location VARCHAR(20) NOT NULL,
-- 	UNIQUE (location)
-- );

-- CREATE TABLE aviacompany.planes (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	model VARCHAR(20) NOT NULL,
-- 	UNIQUE (model)
-- );

-- CREATE TABLE aviacompany.inventory (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	airport INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
-- 	plane INTEGER REFERENCES aviacompany.planes (id) ON DELETE CASCADE,
-- 	amount INTEGER NOT NULL,
-- 	UNIQUE (airport, plane)
-- );

-- CREATE TABLE aviacompany.chiefs (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	second_name VARCHAR(20) UNIQUE NOT NULL,
-- 	airport integer UNIQUE REFERENCES aviacompany.airports (id) ON DELETE CASCADE
-- );

-- CREATE TABLE aviacompany.contacts (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	contact VARCHAR(20) NOT NULL,
-- 	airport INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
-- 	UNIQUE (contact)
-- );

-- CREATE TABLE aviacompany.routes (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	start_point INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
-- 	end_point INTEGER REFERENCES aviacompany.airports (id) ON DELETE CASCADE,
-- 	is_deleted BOOLEAN DEFAULT FALSE;
-- 	UNIQUE (start_point, end_point)
-- );

-- CREATE TABLE aviacompany.chiefs_log (
-- 	id BIGSERIAL PRIMARY KEY,
-- 	operation VARCHAR(10) NOT NULL,
-- 	stamp TIMESTAMP NOT NULL,
-- 	second_name VARCHAR(20) NOT NULL,
-- 	airport INTEGER NOT NULL
-- );


-- INSERT INTO aviacompany.airports (location) VALUES
-- 	('Minsk'), ('Moscow'), ('Beijing'), ('Dhaka'),
-- 	('New York'), ('Osaka'), ('Budapest'),
-- 	('Phoneix'), ('Munich'), ('Prague');

-- INSERT INTO aviacompany.planes (model) VALUES
-- 	('Boeing 737'), ('CRAIC CR929'), ('Airbus A320'),
-- 	('Boeing 747'), ('Duglas DC-3'), ('Embaraer 190'),
-- 	('Boeing 737-8'), ('Beechcraft');

-- INSERT INTO aviacompany.inventory (airport, plane, amount) VALUES
-- 	(1, 1, 12), (1, 4, 3), (2, 4, 35), (3, 6, 9),
-- 	(4, 2, 7), (5, 5, 25), (5, 7, 20), (6, 5, 15),
-- 	(7, 8, 4), (8, 3, 13), (9, 2, 5), (9, 4, 12),
-- 	(10, 8, 10);

-- INSERT INTO aviacompany.chiefs (second_name, airport) VALUES
-- 	('Zager', 4), ('Labar', 5), ('Fraley', 8),
-- 	('Beddingfield', 1), ('Montelongo', 10),
-- 	('Palmore', 3), ('Detwiler', 2), ('Packett', 6),
-- 	('Hanningan', 7), ('Feltman', 9);

-- INSERT INTO aviacompany.contacts (contact, airport) VALUES
-- 	('airport1@gmail.com', 1), ('airport1_1@gmail.com', 1),
-- 	('airport2@gmail.com', 2), ('airport3@gmail.com', 3),
-- 	('airport4@gmail.com', 4), ('airport4_1@gmail.com', 4),
-- 	('airport5@gmail.com', 5), ('airport6@gmail.com', 6),
-- 	('airport7@gmail.com', 7), ('airport8@gmail.com', 8),
-- 	('airport9@gmail.com', 9), ('airport10@gmail.com', 10);

-- INSERT INTO aviacompany.routes (start_point, end_point) VALUES
-- 	(1, 2), (1, 10), (2, 1), (2, 5), (2, 9),
-- 	(3, 4), (3, 6), (4, 3), (4, 5), (5, 2),
-- 	(5, 4), (5, 8), (6, 3), (7, 8), (7, 10),
-- 	(8, 5), (8, 7), (9, 2), (10, 1), (10, 7);


-- CREATE FUNCTION aviacompany.chiefs_audit_func()
-- RETURNS TRIGGER AS $$
-- BEGIN
-- 	IF (TG_OP = 'DELETE') THEN
-- 		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'DELETE', now(), OLD.second_name, NEW.airport;
-- 		RETURN OLD;
-- 	ELSIF (TG_OP = 'UPDATE') THEN
-- 		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'UPDATE', now(), NEW.second_name, NEW.airport;
-- 		RETURN NEW;
-- 	ELSIF (TG_OP = 'INSERT') THEN
-- 		INSERT INTO aviacompany.chiefs_log (operation, stamp, second_name, airport) SELECT 'INSERT', now(), NEW.second_name, NEW.airport;
-- 		RETURN NEW;
-- 	END IF;
-- 	RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE FUNCTION aviacompany.disable_route_func()
-- RETURNS TRIGGER AS $$
-- BEGIN
-- 	UPDATE aviacompany.routes SET is_deleted = TRUE
-- 		WHERE (start_point = OLD.start_point AND end_point = OLD.end_point) OR (start_point = OLD.end_point AND end_point = OLD.start_point);
-- 	RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE FUNCTION aviacompany.safe_update_func()
-- RETURNS TRIGGER AS $$
-- BEGIN
-- 	IF EXISTS (SELECT routes.id FROM aviacompany.routes WHERE routes.id = OLD.id AND aviacompany.routes.is_deleted = TRUE) THEN
-- 		RETURN NULL;
-- 	END IF;
-- 	RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE PROCEDURE aviacompany.create_route(dep_point VARCHAR, destination VARCHAR) AS $$
-- DECLARE
-- 	first_airport INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = dep_point);
-- 	second_airport INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = destination);
-- BEGIN
-- 	INSERT INTO aviacompany.routes(start_point, end_point) VALUES (first_airport, second_airport);
-- 	INSERT INTO aviacompany.routes(start_point, end_point) VALUES (second_airport, first_airport);
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE PROCEDURE aviacompany.add_plane(airport_location VARCHAR, plane_model VARCHAR, planes_amount INTEGER) AS $$
-- DECLARE
-- 	airport_id INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = airport_location);
-- 	plane_id INTEGER := (SELECT planes.id FROM aviacompany.planes WHERE planes.model = plane_model);
-- BEGIN
-- 	INSERT INTO aviacompany.inventory(airport, plane, amount) VALUES (airport_id, plane_id, planes_amount);
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE PROCEDURE aviacompany.change_chief(airport_location VARCHAR, chief_second_name VARCHAR) AS $$
-- DECLARE
-- 	airport_id INTEGER := (SELECT airports.id FROM aviacompany.airports WHERE airports.location = airport_location);
-- BEGIN
-- 	UPDATE aviacompany.chiefs
-- 		SET second_name = chief_second_name WHERE chiefs.airport = airport_id;
-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE VIEW aviacompany.check_routes AS 
-- 	SELECT first_airport.location AS departure_point, last_airport.location AS destination FROM aviacompany.routes AS route
-- 	JOIN aviacompany.airports AS first_airport ON first_airport.id = route.start_point
-- 	JOIN aviacompany.airports AS last_airport ON last_airport.id = route.end_point;

-- CREATE VIEW aviacompany.airport_info AS
-- 	SELECT airport.location AS airport_location, chief.second_name AS chief_name, contacts.contact AS contact, planes.model AS plane FROM aviacompany.airports AS airport
-- 	JOIN aviacompany.chiefs AS chief ON chief.airport = airport.id
-- 	JOIN aviacompany.contacts AS contacts ON contacts.airport = airport.id
-- 	JOIN aviacompany.inventory AS inventory ON inventory.airport = airport.id
-- 	JOIN aviacompany.planes AS planes ON planes.id = inventory.plane;

-- CREATE VIEW aviacompany.inventory_check AS
-- 	SELECT airport.location AS airport_location, plane.model AS plane, inventory.amount AS amount FROM aviacompany.inventory AS inventory
-- 	JOIN aviacompany.airports AS airport ON airport.id = inventory.airport
-- 	JOIN aviacompany.planes AS plane ON plane.id = inventory.plane;


-- CREATE TRIGGER chiefs_audit AFTER INSERT OR UPDATE OR DELETE ON aviacompany.chiefs
-- 	FOR EACH ROW EXECUTE PROCEDURE aviacompany.chiefs_audit_func();

-- CREATE TRIGGER disable_route BEFORE DELETE ON aviacompany.routes
-- 	FOR EACH ROW EXECUTE PROCEDURE aviacompany.disable_route_func();

-- CREATE TRIGGER safe_update BEFORE UPDATE ON aviacompany.routes
-- 	FOR EACH ROW EXECUTE PROCEDURE aviacompany.safe_update_func();



-- SELECT * FROM aviacompany.airports;
-- SELECT * FROM aviacompany.chiefs;
-- SELECT * FROM aviacompany.contacts;
-- SELECT * FROM aviacompany.inventory;
-- SELECT * FROM aviacompany.planes;
-- SELECT * FROM aviacompany.routes;
-- SELECT * FROM aviacompany.chiefs_log;

-- CALL aviacompany.create_route('Phoneix', 'Dhaka');
-- CALL aviacompany.add_plane('Dhaka', 'Beechcraft', 3);
-- CALL aviacompany.change_chief('Dhaka', 'Dennis');

-- SELECT * FROM aviacompany.check_routes;
-- SELECT * FROM aviacompany.airport_info;
-- SELECT * FROM aviacompany.inventory_check;

-- CALL aviacompany.change_chief('Dhaka', 'Dennis');
-- DELETE FROM aviacompany.routes where id = 4;
-- UPDATE aviacompany.routes SET is_deleted = FALSE WHERE start_point=5 AND end_point=2;

