----Stage 1: Data Understanding

SELECT TOP 10 
    *
FROM fraudTest;

---------------------------------OVER()
SELECT 
    COUNT(*) AS total_rows
FROM fraudTest;
----------------------------------
SELECT 
    [is_fraud],
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 4) AS percentage
FROM fraudTest
GROUP BY [is_fraud];
----------------------------------------
SELECT 
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM fraudTest;
-------------------------------------------
SELECT 
    MIN([city_population]) AS min_city_population,
    MAX([city_population]) AS max_city_population,
    AVG(CAST(city_population AS BIGINT)) AS avg_city_population
FROM fraudTest;
------------------------------------------
SELECT 
    [category],
    COUNT([category]) AS count,
    ROUND(100.0 * COUNT([category]) / SUM(COUNT([category])) OVER(), 2) AS percentage
FROM fraudTest
GROUP BY [category]
ORDER BY count DESC;
-----------------------------------------------------
SELECT 
    [gender],
    COUNT([gender]) AS count,
    ROUND(100.0 * COUNT([gender]) / SUM(COUNT([gender])) OVER(), 2) AS percentage
FROM fraudTest
GROUP BY [gender]
ORDER BY count DESC;
---------------------------------------------------------------------------

-----Stage 2: Data Quality Check / Cleaning Validation

SELECT 
    COUNT(DISTINCT transaction_id) AS distinct_transaction_ids
FROM fraudTest;
------------------------------------------------
SELECT 
    *
FROM fraudTest
WHERE [transaction_datetime] IS NULL
   OR [category] IS NULL
   OR [first_name] IS NULL
   OR [last_name] IS NULL
   OR [gender] IS NULL
   OR [job_title] IS NULL
   OR [city_population] IS NULL;

   -----------------------------------------
   SELECT 
    transaction_id,
    COUNT(*) AS duplicate_count
FROM fraudTest
GROUP BY transaction_id
HAVING COUNT(*) > 1;
-------------------------------------------------

SELECT 
    SUM(duplicate_count - 1) AS total_duplicates
FROM (
    SELECT 
        COUNT(*) AS duplicate_count
    FROM fraudTest
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
) t;

------------------------------------------------

SELECT 
    amount
FROM fraudTest
WHERE amount <= 0;

-------------------------------------

SELECT 
    SUM(duplicate_count - 1) AS total_full_duplicates
FROM (
    SELECT 
        COUNT(*) AS duplicate_count
    FROM fraudTest
    GROUP BY 
        transaction_datetime,
        credit_card_number,
        merchant_name,
        category,
        amount,
        first_name,
        last_name,
        gender,
        street_address,
        city,
        state,
        zip_code,
        customer_latitude,
        customer_longitude,
        city_population,
        job_title,
        date_of_birth,
        transaction_id,
        unix_timestamp,
        merchant_latitude,
        merchant_longitude,
        is_fraud
    HAVING COUNT(*) > 1
) t;

---------------------------------------------------

----Stage 3: Feature Engineering / Derived Fields Exploration

SELECT 
    CAST([transaction_datetime] AS DATE) AS [date],
    YEAR([transaction_datetime]) AS [year],
    MONTH([transaction_datetime]) AS [month],
    DAY([transaction_datetime]) AS [day],
    DATEPART(HOUR, [transaction_datetime]) AS [hour]
FROM fraudTest;

----------------------------------------------------

SELECT 
    amount,
    CASE 
        WHEN tile = 1 THEN 'Low'
        WHEN tile = 2 THEN 'Medium'
        ELSE 'High'
    END AS amount_level
FROM (
    SELECT 
        amount,
        NTILE(3) OVER (ORDER BY amount) AS tile
    FROM fraudTest
) t;

-----------------------------------------

SELECT 
    AVG(DATEDIFF(YEAR, date_of_birth, GETDATE()) ) AS AvgAge
    
FROM fraudTest;

SELECT 
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS age
FROM fraudTest;
----------------------------------------------------

SELECT 
    CONCAT([first_name], ' ', [last_name]) AS full_name,
    COUNT([is_fraud]) AS count_fraud
FROM fraudTest
WHERE [is_fraud] = 1
GROUP BY CONCAT([first_name], ' ', [last_name]);
----------------------------------------------------------
SELECT 
    CONCAT([first_name], ' ', [last_name]) AS full_name,
    AVG(amount) AS average_per_customer
FROM fraudTest
GROUP BY CONCAT([first_name], ' ', [last_name]);
------------------------------------------------------------
SELECT 
    CONCAT([first_name], ' ', [last_name]) AS full_name,
    COUNT(*) AS total_transactions
FROM fraudTest
GROUP BY CONCAT([first_name], ' ', [last_name]);
---------------------------------------------------------------

---Stage 4: Exploratory Fraud Analysis


SELECT TOP 10
    CONCAT([first_name], ' ', [last_name]) AS full_name,
    [job_title],
    [gender],
    [city],
    [credit_card_number],
    COUNT(*) AS fraud_count
FROM fraudTest
WHERE [is_fraud] = 1
GROUP BY 
    CONCAT([first_name], ' ', [last_name]),
    [city],
    [job_title],
    [gender],
    [credit_card_number]
ORDER BY fraud_count DESC;
----------------------------------------
SELECT TOP 10
    [job_title],
    COUNT(*) AS fraud_count
FROM fraudTest
WHERE [is_fraud] = 1
GROUP BY [job_title]
ORDER BY fraud_count DESC;
-------------------------------------
SELECT TOP 10
    [credit_card_number],
    COUNT(*) AS fraud_count
FROM fraudTest
WHERE [is_fraud] = 1
GROUP BY [credit_card_number]
ORDER BY fraud_count DESC;

------------------------------------------
SELECT 
[gender],
COUNT(*) AS fraud_count
FROM fraudTest
WHERE [is_fraud] = 1
GROUP BY [gender]
ORDER BY fraud_count DESC;

--------------------------------------------
SELECT
    state,
    city,
    COUNT(*) AS fraud_count
FROM fraudTest
WHERE is_fraud = 1
GROUP BY state, city
ORDER BY fraud_count DESC;

------------------------------------------
SELECT
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS age,
    COUNT(*) AS Count_Of_Appearance
FROM fraudTest
WHERE [is_fraud]=1
GROUP BY DATEDIFF(YEAR, date_of_birth, GETDATE())
ORDER BY Count_Of_Appearance DESC;
---Stage 5: Fraud Percentage Analysis

--------------------------------------------------
SELECT 
    DATEPART(WEEKDAY, [transaction_datetime]) AS day_num,
    [is_fraud],
    COUNT(*) AS count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 
        4
    ) AS percentage
FROM fraudTest
GROUP BY 
    DATEPART(WEEKDAY, [transaction_datetime]),
    [is_fraud]

ORDER BY percentage DESC;

------------------------------------------------------
SELECT 
    DATENAME(MONTH, [transaction_datetime]) AS Month_Name,
    COUNT(*) AS Total_t,
    SUM(CASE WHEN [is_fraud] = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN [is_fraud] = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_percentage
  
    
FROM fraudTest

GROUP BY 
   
        DATENAME(MONTH, [transaction_datetime]) 
ORDER BY  fraud_percentage DESC;
 ------------------------------------------ 
 SELECT 
    DATENAME(MONTH, [transaction_datetime]) AS month_name,
    COUNT(*) AS Total_t,
    SUM(CASE WHEN [is_fraud] = 0 THEN 1 ELSE 0 END) AS NON_fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN [is_fraud] = 0 THEN 1 ELSE 0 END) / COUNT(*), 4) AS NON_fraud_percentage
    
FROM fraudTest
GROUP BY 
   DATENAME(MONTH, [transaction_datetime])
ORDER BY  NON_fraud_percentage DESC;
-------------------------------------------------------
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage
FROM fraudTest
GROUP BY category
ORDER BY fraud_percentage DESC;
----------------------------------------------------
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) AS non_fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS non_fraud_percentage
FROM fraudTest
GROUP BY category
ORDER BY non_fraud_percentage DESC;
-------------------------------------------------------------------
SELECT
    category,
    SUM(amount) AS total_fraud_amount,
    AVG(amount) AS avg_fraud_amount,
    COUNT(*) AS fraud_transactions
FROM fraudTest
WHERE is_fraud = 1
GROUP BY category
ORDER BY fraud_transactions DESC;
-------------------------------------------------
--------------------------------------
SELECT
    gender,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage
FROM fraudTest
GROUP BY gender;

SELECT TOP 10
    CONCAT(first_name, ' ', last_name) AS full_name,
    credit_card_number,
    job_title,
    city,
    state,
    COUNT(*) AS fraud_count,
    SUM(amount) AS total_fraud_amount,
    AVG(amount) AS avg_fraud_amount
FROM fraudTest
WHERE is_fraud = 1
GROUP BY 
    first_name, last_name, credit_card_number, job_title, city, state;




-----------------------------
GO
-----------------------------

--Create Views

    
CREATE  VIEW vw_Fraud_OverallSummary AS
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) AS non_fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_percentage,
    ROUND(100.0 * SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) / COUNT(*), 4) AS non_fraud_percentage
FROM fraudTest;

-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_by_month AS
SELECT
    DATENAME(MONTH, transaction_datetime) AS month_name,
    MONTH(transaction_datetime) AS month_number,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) AS non_fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS non_fraud_percentage
FROM fraudTest
GROUP BY 
    DATENAME(MONTH, transaction_datetime),
    MONTH(transaction_datetime);

-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_by_category AS
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) AS non_fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS non_fraud_percentage
FROM fraudTest
GROUP BY category;

-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_by_day AS
SELECT
    DATENAME(WEEKDAY, transaction_datetime) AS day_name,
    DATEPART(WEEKDAY, transaction_datetime) AS day_number,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage
FROM fraudTest
GROUP BY 
    DATENAME(WEEKDAY, transaction_datetime),
    DATEPART(WEEKDAY, transaction_datetime);

-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_by_location AS
SELECT
    state,
    city,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage
FROM fraudTest
GROUP BY state, city;


-----------------------------
GO
-----------------------------
CREATE VIEW vw_top_fraud_cards AS
SELECT
    credit_card_number,
    COUNT(*) AS fraud_count
FROM fraudTest
WHERE is_fraud = 1
GROUP BY credit_card_number;

-----------------------------
GO
-----------------------------

CREATE OR ALTER VIEW vw_Fraud_ByJobTitle AS
SELECT 
    job_title,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_percentage
FROM fraudTest
GROUP BY job_title;


-----------------------------
GO
-----------------------------
CREATE OR ALTER VIEW vw_Top_Fraud_Customers AS
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    credit_card_number,
    job_title,
    city,
    state,
    COUNT(*) AS fraud_count,
    SUM(amount) AS total_fraud_amount,
    AVG(amount) AS avg_fraud_amount
FROM fraudTest
WHERE is_fraud = 1
GROUP BY 
    first_name, last_name, credit_card_number, job_title, city, state;
-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_by_age AS
SELECT
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS age,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS fraud_percentage
FROM fraudTest
GROUP BY DATEDIFF(YEAR, date_of_birth, GETDATE());

-----------------------------
GO
-----------------------------
CREATE VIEW vw_fraud_amount_by_category AS
SELECT
    category,
    SUM(amount) AS total_fraud_amount,
    AVG(amount) AS avg_fraud_amount,
    COUNT(*) AS fraud_transactions
FROM fraudTest
WHERE is_fraud = 1
GROUP BY category;


















