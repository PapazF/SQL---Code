/***** SQL: Question Set 1 *****/

/*Question 1: Which countries have the most Invoices?*/

SELECT billing_country, 
       COUNT(billing_country) AS invoice_number
FROM invoice
GROUP BY billing_country
ORDER BY invoice_number DESC;

/*Question 2: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. */

SELECT billing_city, 
       SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;

/*Question 3: Who is the best customer?
The customer who has spent the most money will be declared the best customer. */

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spending
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 1;

/***** SQL: Question Set 2 *****/

/*Question 1: Use your query to return the email, first name, last name, and genre of all Rock Music listeners. */

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoiceline ON invoice.invoice_id = invoiceline.invoice_id
WHERE track_id IN
(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/*Question 2: Who is the most popular rock artist?
Now that we know that our customers love rock music, we can decide which musicians to invite to play at the concert.
Let's invite the artists who have written the most rock music in our dataset. */

SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/***** SQL: Question Set 3 *****/

/*Question 1: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases. */

/* sales for each country */
SELECT customer.country, genre.name, COUNT(*) AS purchases_per_genre
FROM invoiceline
JOIN invoice ON invoice.invoice_id = invoiceline.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN track ON track.track_id = invoiceline.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY 1,2
ORDER BY 1;


/*Question 2: Return all the track names that have a song length longer than the average song length */

SELECT name, miliseconds
FROM track
WHERE miliseconds > 
(
	SELECT AVG(miliseconds) AS avg_track_length
	FROM track
)
ORDER BY miliseconds DESC;

/*Question 3: Write a query that determines the customer that has spent the most on music for each country. */
SELECT billing_country, customer_id, full_name, MAX(total_spending)
FROM 
(
SELECT billing_country, c.customer_id, CONCAT(first_name,' ',last_name) AS full_name, SUM(total) AS total_spending
FROM invoice AS i
JOIN customer AS c ON c.customer_id = i.customer_id
GROUP BY 1,2,3
ORDER BY 1
)
GROUP BY 1,2
ORDER BY 1;
