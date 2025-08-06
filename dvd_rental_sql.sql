--QUESTION 1 (Select actors whose first_name is not ‘John’)

SELECT *
FROM actor
WHERE first_name != 'John';









-- QUESTION 2 ( Show me the last_name and first_name of actors whose first names are Ed, Nick and Jennifer in the actor table.)

SELECT last_name, first_name
FROM actor
WHERE first_name IN ('Ed', 'Nick', 'Jennifer');



-- QUESTION 3 (Retrieve actors whose last_name is not ‘Smith’ and first_name is ‘Tom’)

SELECT last_name, first_name
FROM actor
WHERE last_name != 'Smith' AND first_name = 'Tom';

-- QUESTION 4 (We found out that one of our loyal customers, Nancy Thomas, has not come to patronise us for a while, can you please help track her email from the customer table? so we could reach out to her particularly)
SELECT email
FROM customer
WHERE first_name = 'Nancy' AND last_name = 'Thomas';

-- QUESTION 5 (A customer is late on their movie return, we’ve mailed them a letter to their address at ‘259 Ipoh Drive”. We should also call them. Return the customer’s phone number from the address table.)

SELECT phone
FROM address
WHERE address = '259 Ipoh Drive';

-- QUESTION 6 (List all countries from country table)

SELECT country
FROM country;

-- QUESTION 7 (Show the number of countries from country table)
SELECT COUNT (country) AS total_country -- OR SELECT COUNT(*) AS total_country
FROM country;

-- QUESTION 8 (Find United States in the country table)

SELECT *
FROM country
WHERE country = 'United States';

-- QUESTION 9 (List all payments with an amount of either 1.99, 2.99, 3.99 or 4.99 )
SELECT *
FROM payment
WHERE amount IN (1.99, 2.99, 3.99, 4.99);

-- QUESTION 10 (Display the total amount paid by all customers in the payment table)
SELECT SUM(amount) AS total_amount_paid
FROM payment;


-- QUESTION 11 (Retrieve the titles of films from the film table that are either in the “PG” or “PG-13” rating category.)
SELECT title
FROM film
WHERE rating = 'PG' OR rating = 'PG-13'; --or where rating in ('PG', 'PG-13')

-- QUESTION 12 (Classify films as ‘Short’ if their length is less than 90 minutes, ‘Medium” if between 90 and 120 minutes, and ‘Long’ if over 120 minutes.)

SELECT 
    title,
    length,
    CASE
        WHEN length < 90 THEN 'Short'
        WHEN length BETWEEN 90 AND 120 THEN 'Medium'
        WHEN length > 120 THEN 'Long'
    END AS film_classification
FROM film;

-- QUESTION 13 (Retrieve films with a rating of 'PG' or 'G' and classify them as 'Family' films, else classify them as 'Other')

SELECT 
    title,
    rating,
    CASE
        WHEN rating IN ('PG', 'G') THEN 'Family'
        ELSE 'Other'
    END AS family_film_classification
FROM film;

-- Question 14: Return the names of customers who have not returned the DVDs they rented

SELECT c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r
	ON c.customer_id = r.customer_id
WHERE return_date IS NULL;

-- Question 15: What is the name of the customer who made the highest total payments
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_payment
FROM customer AS c
JOIN payment AS p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_payment DESC
LIMIT 1;


-- QUESTION 16: What is the movie that was rented the most
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 1;

-- QUESTION 17: Which movies have been rented so far?
SELECT DISTINCT f.title
FROM rental r
JOIN inventory i
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON i.film_id = f.film_id;

-- QUESTION 18: Which movies have not been rented so far?
SELECT f.title
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- QUESTION 19: Which Customers have not rented any movies so far?
SELECT c.first_name, c.last_name, c.email
FROM customer c
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

--QUESTION 20: Display each movie and the number of times it got rented
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
JOIN rental r
	ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC;

--QUESTION 21: Show the first name and last name and the number of films each actor acted in
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC;

--QUESTION 22: Show the number of rented movies under each rating
SELECT f.rating, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
JOIN rental r
	ON i.inventory_id = r.inventory_id
GROUP BY f.rating
ORDER BY rental_count DESC;


--QUESTION 23: Display the names of the actors that acted in more than 20 movies
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 20
ORDER BY film_count DESC;


--QUESTION 24: For all the movies rated "PG", show the movie and the number of times it got rented
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
JOIN rental r
	ON i.inventory_id = r.inventory_id
WHERE f.rating = 'PG'
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC;

--QUESTION 25: Display the movies offered for rent in store_id 1 and not offered in store_id 2
SELECT DISTINCT f.title
FROM film f
JOIN inventory i1
	ON f.film_id = i1.film_id AND i1.store_id = 1
WHERE f.film_id NOT IN (
    SELECT i2.film_id
    FROM inventory i2
    WHERE i2.store_id = 2
);

--QUESTION 26: Display the movies offered for rent in any of the two stores 1 and 2
SELECT DISTINCT f.title
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
WHERE i.store_id IN (1, 2);

--QUESTION 27: Show the profit of each of the stores 1 and 2
SELECT s.store_id, SUM(p.amount) AS total_profit
FROM store s
JOIN staff st
	ON s.store_id = st.store_id
JOIN payment p
	ON st.staff_id = p.staff_id
WHERE s.store_id IN (1, 2)
GROUP BY s.store_id
ORDER BY s.store_id;