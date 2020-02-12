-- can use "SET search_path TO aviacompany" comand
-- 	to avoid writing aviacompany before table name

CREATE TABLE aviacompany.airports (
	id BIGSERIAL PRIMARY KEY,
	location VARCHAR(20) NOT NULL,
	UNIQUE (location)
);

CREATE TABLE aviacompany.planes (
	id BIGSERIAL PRIMARY KEY,
	model VARCHAR(20) NOT NULL,
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
	UNIQUE (start_point, end_point)
);


INSERT INTO aviacompany.airports (location) VALUES
	('Minsk'), ('Moscow'), ('Beijing'), ('Dhaka'),
	('New York'), ('Osaka'), ('Budapest'),
	('Phoneix'), ('Munich'), ('Prague');

INSERT INTO aviacompany.planes (model) VALUES
	('Boeing 737'), ('CRAIC CR929'), ('Airbus A320'),
	('Boeing 747'), ('Duglas DC-3'), ('Embaraer 190'),
	('Boeing 737-8'), ('Beechcraft');

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

INSERT INTO aviacompany.routes (start_point, end_point) VALUES
	(1, 2), (1, 10), (2, 1), (2, 5), (2, 9),
	(3, 4), (3, 6), (4, 3), (4, 5), (5, 2),
	(5, 4), (5, 8), (6, 3), (7, 8), (7, 10),
	(8, 5), (8, 7), (9, 2), (10, 1), (10, 7);
