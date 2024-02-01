CREATE database crm;

USE crm;

CREATE TABLE managers (
    manager_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(320) NOT NULL
) engine = innodb;

CREATE TABLE consultants (
    consultant_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(320) NOT NULL,
    manager_id INT UNSIGNED NOT NULL
) engine = innodb;

ALTER TABLE consultants ADD CONSTRAINT fk_consultants_managers
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id);

CREATE TABLE clients (
    client_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    birth_date DATE,
    email VARCHAR(320) NOT NULL,
    consultant_id INT UNSIGNED NOT NULL
) engine = innodb;

ALTER TABLE clients ADD CONSTRAINT fk_clients_consultants
    FOREIGN KEY (consultant_id) REFERENCES consultants(consultant_id);

INSERT INTO managers (first_name, last_name, email) VALUE 
('Robin', 'Chen', 'robinchen@gemail.com'),
('Choon Kee', 'Chen', 'chenchoonkee@gemail.com');

INSERT INTO consultants (first_name, last_name, email, manager_id) VALUE 
('Daniel', 'Wong', 'danielwong@gemail.com', 1),
('Chia Weng', 'Lim', 'limchiaweng@gemail.com', 2);

INSERT INTO clients (first_name, last_name, birth_date, email, consultant_id) VALUE 
('Wendy', 'Lai', '2000-01-01', 'wendylai@gemail.com', 1),
('Joyce', 'Seow', '2001-01-01', 'joyceseow@gemail.com', 2);