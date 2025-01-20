/* PREVIOUS EXERCISES:
Connected via cmd: psql -U username
Created database: CREATE DATABASE databasename;
Created table:
CREATE TABLE person (id SERIAL PRIMARY KEY, name varchar(255) NOT NULL, age int NOT NULL, student bool); */


-- Add three person rows to your table, give each of them name and age
INSERT INTO person (name, age) VALUES
('Bob', 31),
('Tim', 45),
('Teresa', 38);

-- Try to add a person without age column (doesn't work)
INSERT INTO person (name) VALUES
('Ted')

-- Check if persons are there
SELECT * FROM person;

-- Query only name column
SELECT name FROM person;

-- Query age and id columns
SELECT age, id FROM person;

-- Query all the columns and order them alphabetically by name column
SELECT * FROM person
ORDER BY name;

-- Query all the columns and order them in reversed alphabetical order
SELECT * FROM person
ORDER BY name DESC;

-- Count how many rows there are on the table
SELECT COUNT(*)
FROM person;

-- Count the accumulated age of all rows
SELECT SUM(age)
FROM person;

-- Count the average age of all rows
SELECT AVG(age)
FROM person;

-- Update any single column and make sure the row updated
UPDATE person SET name='Jane' WHERE id=3;

SELECT * FROM person WHERE id=3;

-- Update all of the rows to have false value on student column (and check if it worked)
UPDATE person SET student = FALSE;

SELECT * FROM person;

-- Delete row with id 1 from your table and make sure it doesn't exist anymore
DELETE FROM person WHERE id=1;

SELECT * FROM person WHERE id=1;

-- Create new table certificates
CREATE table certificates (
    id SERIAL PRIMARY KEY,
    name varchar(255) NOT NULL,
    person_id int,
    CONSTRAINT fk_person FOREIGN KEY(person_id) REFERENCES person(id)
);

-- Add new row to the person table
INSERT into person (name, age, student) VALUES
('Linda', 30, FALSE);

SELECT * FROM person;

-- Add a new row to the certificates table by attaching a certificate named Scrum to yourself
INSERT into certificates (name, person_id) VALUES
('AWS', 5);

SELECT * FROM certificates;

-- Add Scrum and Azure certificates to others in the person table
INSERT into certificates (name, person_id) VALUES
('Scrum', 2),
('Azure', 3);

SELECT * FROM certificates;

-- Query the person board for all Scrum certificate holders
SELECT p.id, p.name, age, student
FROM person p -- Alias person as p
INNER JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Scrum';

-- Query the person board for all Azure certificate holders
SELECT p.id, p.name, age, student
FROM person p -- Alias person as p
INNER JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Azure';

-- Download world.sql file and make new database called world, restore the file to your database