CREATE DATABASE library;
USE library;
CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    birth_date DATE, 
    email VARCHAR(320) NOT NULL
) engine = innodb;
CREATE TABLE address (
    address_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    street_name VARCHAR(200) NOT NULL,
    building_name VARCHAR(200),
    postal_code VARCHAR(10),
    floor_number VARCHAR(3),
    unit_number VARCHAR(6)
) engine = innodb;
ALTER TABLE address ADD COLUMN user_id INT UNSIGNED;
ALTER TABLE address ADD CONSTRAINT fk_address_users
    FOREIGN KEY (user_id) REFERENCES users(user_id);
CREATE TABLE publishers (
    publisher_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(1000) NOT NULL
) engine = innodb;
CREATE TABLE books (
    book_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(1000) NOT NULL,
    synopsis text,
    isbn VARCHAR(13) NOT NULL
) engine = innodb;
ALTER TABLE books ADD COLUMN publisher_id INT UNSIGNED;
ALTER TABLE books ADD CONSTRAINT fk_books_publishers
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id);
CREATE TABLE authors (
    author_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100)
) engine = innodb;
CREATE TABLE writing_credits (
    writing_credit_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
) engine = innodb;
ALTER TABLE writing_credits ADD COLUMN author_id INT UNSIGNED;
ALTER TABLE writing_credits ADD CONSTRAINT fk_writing_credits_authors
    FOREIGN KEY (author_id) REFERENCES authors(author_id);
ALTER TABLE writing_credits ADD COLUMN book_id INT UNSIGNED;
ALTER TABLE writing_credits ADD CONSTRAINT fk_writing_credits_books
    FOREIGN KEY (book_id) REFERENCES books(book_id);
CREATE TABLE books_users (
    book_user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
) engine = innodb;
ALTER TABLE books_users ADD COLUMN user_id INT UNSIGNED;
ALTER TABLE books_users ADD CONSTRAINT fk_books_users_users
    FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE books_users ADD COLUMN book_id INT UNSIGNED;
ALTER TABLE books_users ADD CONSTRAINT fk_books_users_books
    FOREIGN KEY (book_id) REFERENCES books(book_id);
INSERT INTO users (first_name, last_name, birth_date, email) VALUE 
('Chu Kang', 'Lim', '1998-01-18', 'cklim@gemail.com'),
('Jonathan', 'Tan', '1995-10-15', 'jontan@gemail.com'),
('See Mei', 'Liang', '1983-06-21', 'smliang@gemail.com');
INSERT INTO publishers (name) VALUE 
('CosmoChronicle Publishing'),
('Moonlit Publications');
INSERT INTO books (title, synopsis, isbn, publisher_id) VALUE 
('Spectral Serenade', ' A spectral love story transcending time, weaving through realms of the living and the dead.', '9781234567901', 1),
('Quantum Quasar', 'Unravel the cosmos in a mind-bending odyssey, where reality blurs and the universe reveals its secrets.', '9781234567918', 1),
('Lunar Lullaby', 'Under the moon enchantment, a forbidden love blooms, challenging destiny and defying celestial forces.', '9781234567925', 2);
INSERT INTO authors (first_name, last_name) VALUE 
('Seraphina', 'Nightshade'),
('Orion', 'Mystique'),
('Stella', 'Celestia');
INSERT INTO writing_credits (author_id, book_id) VALUE
(1,1),
(2,1),
(3,2),
(3,3),
(2,2);
INSERT INTO books_users (book_id, user_id) VALUE
(1,1),
(2,1),
(3,2),
(3,3),
(2,2);