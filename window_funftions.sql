-- 1. Compare Values with Previous or Next Records
sql
Copy
Edit


SELECT 
    sale_id,
    product_name,
    category,
    region,
    amount,
    LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) AS previous_amount,
    LEAD(amount) OVER (PARTITION BY region ORDER BY sale_date) AS next_amount,
    CASE
        WHEN amount > LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'HIGHER'
        WHEN amount < LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'LOWER'
        WHEN amount = LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'EQUAL'
        ELSE 'N/A'
    END AS comparison_with_previous
FROM sales;


--  2. Ranking Data within a Category

SELECT 
    product_name,
    category,
    region,
    amount,
    RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rank_amount,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS dense_rank_amount
FROM sales;


--  3. Identifying Top Records

SELECT *
FROM (
    SELECT 
        product_name,
        category,
        amount,
        RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rnk
    FROM sales
) ranked_sales
WHERE rnk <= 3;


--  4. Finding the Earliest Records
SELECT *
FROM (
    SELECT 
        product_name,
        category,
        sale_date,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sale_date ASC) AS row_num
    FROM sales
) ordered_sales
WHERE row_num <= 2;


-- 5. Aggregation with Window Functions

SELECT 
    product_name,
    category,
    amount,
    MAX(amount) OVER (PARTITION BY category) AS max_in_category,
    MAX(amount) OVER () AS overall_max
FROM sales;
