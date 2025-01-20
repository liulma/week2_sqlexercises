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
/* From sql command line it would work like this:
RESTORE DATABASE world
FROM 'C:\Users\LindaUlma\Codes\Week_2\sql_exercises\world.sql'; 
With psql session need to move file first so postgres has access and then run
psql -U postgres -d world -f "C:/Program Files/PostgreSQL/16/data/world.sql" in cmd 
Didn't work so trying what Skillioni suggested:
\cd C:/Users/LindaUlma/Documents open the directory
Then run: \i world.sql*/

-- Investigate what kind of tables can be found in the database
SELECT * FROM country;

SELECT * FROM city limit 10;

-- Query the city table for all rows with country_code FIN
SELECT * from city 
WHERE country_code='FIN'
ORDER BY name;

-- Count how many cities can be found in the United States
SELECT COUNT(*)
FROM city
WHERE country_code='USA';

-- Count the population of U.S. cities
SELECT SUM(population)
FROM city
WHERE country_code='USA';

-- List cities with populations between 1 and 2 million and limit search result to 15 rows
SELECT * FROM city 
WHERE population BETWEEN 1000000 and 2000000
limit 15;

-- Calculate the total population of cities in U.S. states, grouped by state
SELECT SUM(population), district
FROM city
WHERE country_code = 'USA'
GROUP BY district;

-- Calculate which country has the highest life expectancy. Null values not included, limit search result to one row
SELECT name, lifeexpectancy
FROM country
WHERE lifeexpectancy = (SELECT MAX(lifeexpectancy) FROM country WHERE lifeexpectancy IS NOT NULL) limit 1;

-- Calculate the total number of inhabitants in all cities in a given country grouped by country. Include relevant columns in the search result
SELECT country_code, SUM(population)
FROM city
GROUP BY country_code
ORDER BY country_code;

SELECT c.name, SUM(ci.population) AS total_population
FROM country c
JOIN city ci ON c.code = ci.country_code
GROUP BY c.name
ORDER BY c.name;

-- Next, include the population column from the country table. The numbers should not add up
SELECT c.name, SUM(ci.population) AS totalcity_population, SUM(c.population) AS total_population
FROM country c
JOIN city ci ON c.code = ci.country_code
GROUP BY c.name, c.population
ORDER BY c.name;

SELECT ci.country_code, SUM(ci.population) AS total_citypopulation, c.population AS total_population
FROM city ci
JOIN country c on ci.country_code = c.code
GROUP BY country_code, c.population
ORDER BY country_code;

-- List countries by capital, use the JOIN clause
SELECT DISTINCT c.name, c.capital
FROM country c
JOIN city ci ON ci.country_code = c.code;

-- List Spain only
SELECT DISTINCT c.name, c.capital
FROM country c
JOIN city ci ON ci.country_code = c.code
WHERE c.name = 'Spain';

-- List all European countries and their cities
SELECT c.name AS country_name, c.capital,
STRING_AGG (DISTINCT ci.name, ', ') AS "cities"
FROM country c
JOIN city ci ON ci.country_code = c.code
WHERE continent = 'Europe'
GROUP BY c.name, c.capital;

-- List all languages spoken in Southeast Asia region, use the join clause
SELECT c.name,
STRING_AGG (DISTINCT cl.language, ', ') AS languages
FROM country c
JOIN country_language cl ON cl.country_code = c.code
WHERE region = 'Southeast Asia'
GROUP BY c.name;

-- Use a subquery to search for all cities with a larger population than the entire population of Finland
SELECT ci.name, ci.population
FROM city ci
JOIN country c ON c.code = ci.country_code
WHERE ci.population >
    (SELECT population
    FROM country c
    WHERE c.name = 'Finland');

-- Search all cities with over one million inhabitants in a country where English is spoken
SELECT DISTINCT ci.name, ci.population
FROM city ci
JOIN country_language cl ON cl.country_code = ci.country_code
WHERE ci.country_code IN 
    (SELECT country_code
    FROM country_language
    WHERE language = 'English')
AND ci.population > 1000000;