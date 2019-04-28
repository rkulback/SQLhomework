-- use the sakila database
use sakila;

-- display the first and last name of the actor table (requirement 1a)
SELECT first_name, last_name FROM actor;

-- display the names of each actor in a single column in uppercase letters 
-- name column 'Actor Name' (requirement 1b)
-- used concat method to combine the desired values into one column; used "AS" to name column
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor;

-- find the id, first name, and last name of any actor with the first name of "Joe"
-- use a SELECT w/ WHERE statement limiting first name to "Joe"
-- requirement 2a
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

-- find all actors with the last name that includes the letters "GEN"
-- NOTE - I would ask if the order of letters is important;
-- my query will return all last names that contain those letters, and assumes order is not important
-- requirement 2b
SELECT first_name, last_name FROM actor
WHERE last_name like "%G%" "%E%" "%N%";

-- find all the actors whose last names contain the letters "LI"
-- display as last_name and then first_name
-- requirement 2c
SELECT last_name, first_name FROM actor
WHERE last_name like "%L%" "%I%";

-- display country_id and country columns for Afghanistan, Bangladesh, and China
-- use in statement
-- requirement 2d
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- add column entitled description; set datatype to blob
-- requirement 3a
ALTER TABLE actor
ADD COLUMN description BLOB NOT NULL AFTER last_name;

-- delete the description column
-- requirement 3b
ALTER TABLE actor
DROP COLUMN description;

-- list the last names of actors; and count how many have that last name
-- requirement 4a
SELECT actor.last_name,
COUNT(last_name) AS Last_name_count
FROM actor
GROUP BY last_name;

-- list the last names of actors; and count how many have that last name; limit to counts greater than 1
-- requirement 4b
SELECT actor.last_name,
COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING count(last_name)>1;

-- rewrite the groucho williams entry as harpo williams
-- first, identify ID to ensure correct record is altered
-- second, use update statement to alter record
-- requirement 4c
SELECT actor_id, first_name, last_name FROM actor 
WHERE first_name = "GROUCHO";

UPDATE actor
SET first_name = "HARPO"
WHERE actor_id = 172;

SELECT * FROM actor
WHERE actor_id = 172;

-- write single script to correct the previous entry
-- first ensure there is only one "harpo" entry
-- requirement 4d
SELECT * FROM actor
WHERE first_name = "HARPO";

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- You cannot locate the schema of the address table. Which query would you use to re-create it?
-- requirement 5a
SHOW CREATE TABLE address;

-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address
-- first - selected all from each table to identify proper join column
-- requirement 6a
SELECT first_name, last_name, address
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
-- requirement 6b
SELECT staff.first_name, staff.last_name, sum(payment.amount) AS 'Total' FROM staff
JOIN payment
ON payment.staff_id=staff.staff_id
GROUP BY staff.staff_id
HAVING Total > '2005-05-25 11:30:37'; -- AND '2005-05-25 12:35:23';
SELECT * FROM staff;
SELECT * FROM payment;

-- list each film and the number of actors that are in that film
-- requirement 6c
SELECT film.title, COUNT(film_actor.film_id) AS 'Number of Actors'
FROM film_actor
INNER JOIN film
ON film.film_id = film_actor.film_id
GROUP BY title;

-- how many copies of "Hunchback Impossible" exist in the system?
-- requirement 6d
SELECT film.title, inventory.film_id, COUNT(inventory.film_id) as 'Number in Inventory' FROM inventory 
JOIN film
ON film.film_id = inventory.film_id
GROUP BY film_id
HAVING title = 'hunchback impossible';

-- list total paid by each customer
-- sort alphabetically by last name
-- requirement 6e
SELECT customer.first_name, customer.last_name,  sum(payment.amount) AS 'Total Amount Paid' FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

-- display the names of movie titles starting w/ "K" and "Q"
-- use subqueries
-- requirement 7a
SELECT title FROM film 
WHERE title IN
	(SELECT title 
    FROM film 
    WHERE title like "K%" OR title like "Q%");

-- display all actors who appeared in "Alone Trip"
-- use subqueries
-- requirement 7b
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;
SELECT CONCAT(first_name, ' ', last_name) AS 'Alone Trip Actor' from actor
WHERE actor_id IN 
(SELECT actor_id FROM film_actor
WHERE film_id IN
(SELECT film_id FROM film
WHERE title='Alone Trip'));

-- You will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, email, country.country FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON city.city_id = address.city_id
JOIN country
ON country.country_id = city.country_id
WHERE country='Canada';


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title, category.name FROM film
JOIN film_category
ON film_category.film_id = film.film_id
JOIN category
ON category.category_id = film_category.category_id
HAVING category.name='Family';

-- Display the most frequently rented movies in descending order.
-- 7e
SELECT * FROM rental;
SELECT * FROM film;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM customer;
SELECT film.title, count(rental.inventory_id) AS 'Frequent Rentals' FROM film
JOIN inventory
ON inventory.film_id=film.film_id
JOIN rental
ON rental.inventory_id=inventory.inventory_id
GROUP BY film.title
ORDER BY count(rental.inventory_id) desc;

-- display how much business each store brought in
-- requirement 7f
SELECT store_id, sum(payment.amount) AS 'Total Rental Amount' FROM inventory
JOIN rental
ON inventory.inventory_id=rental.inventory_id
JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY store_id;

-- display each store_id, city, and country
-- 7g
SELECT store.store_id AS 'Store ID', city.city AS 'City', country.country AS 'Country' FROM store
JOIN address
ON store.address_id=address.address_id
JOIN city
ON city.city_id=address.city_id
JOIN country 
ON country.country_id=city.country_id;

-- list the top five genres in gross revenue in descending order
-- 7h
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;

SELECT name AS 'Genre', sum(payment.amount) AS 'Gross Revenues' FROM category
JOIN film_category
ON film_category.category_id=category.category_id
JOIN inventory
ON inventory.inventory_id=film_category.film_id
JOIN rental
ON rental.inventory_id=inventory.inventory_id
JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY name
ORDER BY sum(payment.amount) desc;

-- create a view to save the above query
-- 8a
CREATE VIEW top_five_genres AS
SELECT name AS 'Genre', sum(payment.amount) AS 'Gross Revenues' FROM category
JOIN film_category
ON film_category.category_id=category.category_id
JOIN inventory
ON inventory.inventory_id=film_category.film_id
JOIN rental
ON rental.inventory_id=inventory.inventory_id
JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY name
ORDER BY sum(payment.amount) desc;

-- display the view
-- 8b
SHOW CREATE VIEW top_five_genres;

-- delete the view
-- 8c
DROP VIEW top_five_genres;
	












