/* LAB  AGGREGATION REVISITED SUBQUERIES */

use sakila; 

/*  Q1  */
# Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    a.address,
    city.city,
    a.postal_code,
    a.district
FROM
    customer c
        LEFT JOIN
    address a ON c.address_id = a.address_id
        LEFT JOIN
    city ON a.city_id = city.city_id;  
-- Table with name email address, city, postal code. 7 Columns   599 rows 

/*  Q2  */
#What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    avg_t.avg_payment
FROM
    customer c
        JOIN
    (SELECT 
        p.customer_id, AVG(p.amount) AS avg_payment
    FROM
        payment p
    GROUP BY p.customer_id) avg_t
ORDER BY avg_payment DESC
;
-- result is a table with 3 columns. Ordered in descendent order by average payment 

select * from customer;

/*  Q3  */
#Wtih joins
SELECT DISTINCT
    c.first_name, c.last_name, c.email
FROM
    rental r
        JOIN
    customer c ON r.customer_id = c.customer_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film_category fc ON i.film_id = fc.film_id
        JOIN
    category cat ON fc.category_id = cat.category_id
WHERE
    cat.name = 'Action'
;  
-- we get 510 rows of people who rented action films

#With where conditions
SELECT DISTINCT
    c.first_name, c.last_name, c.email
FROM
    customer c
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            rental r
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    inventory i
                WHERE
                    i.film_id IN (SELECT 
                            film_id
                        FROM
                            film_category fc
                        WHERE
                            fc.category_id IN (SELECT 
                                    category_id
                                FROM
                                    category cat
                                WHERE
                                    cat.name = 'Action'))));
                                    
-- I get exactly the same 510 rows. 

/*  Q4  */
#Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
#If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
-- I think the amounts should be multiplied by 100

SELECT 
    *,
    CASE
        WHEN amount > 0 AND amount <= 200 THEN 'low'
        WHEN amount > 200 AND amount <= 400 THEN 'medium'
        WHEN amount > 400 THEN 'high'
    END AS trans_clasification /*this is the created column to clasify the transactions*/
FROM
    trans;
