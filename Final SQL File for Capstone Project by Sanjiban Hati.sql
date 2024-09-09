CREATE TABLE amazon_sales.sales (
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT NOT NULL,
    gross_income DECIMAL(10, 2) NOT NULL,
    rating FLOAT NOT NULL,
    PRIMARY KEY (invoice_id)
);


ALTER TABLE amazon_sales.sales
ADD COLUMN timeofday VARCHAR(10);

UPDATE amazon_sales.sales
SET timeofday = CASE
    WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END; 

ALTER TABLE amazon_sales.sales
ADD COLUMN dayname VARCHAR(10);

UPDATE amazon_sales.sales
SET dayname = DAYNAME(date); 

ALTER TABLE amazon_sales.sales
ADD COLUMN monthname VARCHAR(10);

UPDATE amazon_sales.sales
SET monthname = MONTHNAME(date);

SELECT COUNT(DISTINCT city) AS distinct_cities
FROM amazon_sales.sales;

SELECT branch, count(*) as no_of_cities
FROM amazon_sales.sales group by branch order by branch;

SELECT city, branch
FROM amazon_sales.sales
order by branch;

SELECT COUNT(DISTINCT product_line) AS distinct_product_lines
FROM amazon_sales.sales;

SELECT payment_method, COUNT(*) AS frequency
FROM amazon_sales.sales
GROUP BY payment_method
ORDER BY frequency DESC
limit 1;

SELECT product_line, SUM(total) AS total_sales
FROM amazon_sales.sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

SELECT monthname, SUM(total) AS revenue
FROM amazon_sales.sales
GROUP BY monthname 
;

SELECT monthname, SUM(cogs) AS total_cogs
FROM amazon_sales.sales
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;

SELECT product_line, SUM(total) AS revenue
FROM amazon_sales.sales
GROUP BY product_line
ORDER BY revenue DESC
LIMIT 1;

SELECT city, SUM(total) AS revenue
FROM amazon_sales.sales
GROUP BY city
ORDER BY revenue DESC
LIMIT 1;

SELECT product_line, ROUND(SUM(VAT),2) AS total_VAT
FROM amazon_sales.sales
GROUP BY product_line
ORDER BY total_VAT DESC
LIMIT 1;

WITH average_sales AS (
    SELECT AVG(total) AS avg_sales
    FROM amazon_sales.sales
)
SELECT product_line,
       CASE
           WHEN AVG(total) > (SELECT avg_sales FROM average_sales) THEN 'Good'
           ELSE 'Bad'
       END AS sales_status
FROM amazon_sales.sales
group BY product_line;

SELECT branch, SUM(quantity) AS total_quantity
FROM amazon_sales.sales
GROUP BY branch
HAVING SUM(quantity) > (
    SELECT AVG(total_quantity)
    FROM (
        SELECT SUM(quantity) AS total_quantity
        FROM amazon_sales.sales
        GROUP BY branch
    ) AS branch_totals
);


SELECT gender, product_line, COUNT(*) AS frequency
FROM amazon_sales.sales
GROUP BY gender, product_line
ORDER BY frequency DESC;

SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM amazon_sales.sales
GROUP BY product_line;

SELECT dayname, timeofday, COUNT(*) AS occurrences
FROM amazon_sales.sales
GROUP BY dayname, timeofday
ORDER BY FIELD(dayname, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), 
FIELD(timeofday, 'Morning', 'Afternoon', 'Evening');


SELECT customer_type, SUM(total) AS revenue
FROM amazon_sales.sales
GROUP BY customer_type
ORDER BY revenue DESC
LIMIT 1;

SELECT city, ROUND(AVG(VAT),2) AS avg_VAT
FROM amazon_sales.sales
GROUP BY city
ORDER BY avg_VAT DESC
LIMIT 1;


SELECT customer_type, ROUND(SUM(VAT),2) AS total_VAT
FROM amazon_sales.sales
GROUP BY customer_type
ORDER BY total_VAT DESC
LIMIT 1;

SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types
FROM amazon_sales.sales;

SELECT COUNT(DISTINCT payment_method) AS distinct_payment_methods
FROM amazon_sales.sales;

SELECT customer_type, COUNT(*) AS frequency
FROM amazon_sales.sales
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;

SELECT customer_type, COUNT(*) AS purchase_frequency
FROM amazon_sales.sales
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;

SELECT gender, COUNT(*) AS frequency
FROM amazon_sales.sales
GROUP BY gender
ORDER BY frequency DESC
LIMIT 1;

SELECT branch, gender, COUNT(*) AS frequency
FROM amazon_sales.sales
GROUP BY branch, gender order by branch;

SELECT timeofday, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales.sales
GROUP BY timeofday
ORDER BY avg_rating DESC
LIMIT 1;

SELECT branch, timeofday, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales.sales
GROUP BY branch, timeofday order by branch, AVG(rating) desc;

SELECT dayname AS day_of_week, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales.sales
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;

SELECT branch, dayname, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales.sales
GROUP BY branch, dayname order by branch, AVG(rating) desc;
















