-- ============================================================
-- BANKING CUSTOMER TRANSACTION ANALYTICS
-- 02 - CUSTOMER ANALYSIS
-- ============================================================


-- ============================================================
-- 1. CUSTOMER OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT city) AS cities,
    COUNT(DISTINCT customer_segment) AS segments
FROM customers;


-- ============================================================
-- 2. CUSTOMERS BY GENDER
-- ============================================================

SELECT
    gender,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY gender
ORDER BY customers DESC;


-- ============================================================
-- 3. CUSTOMERS BY CITY
-- ============================================================

SELECT
    city,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY city
ORDER BY customers DESC;


-- ============================================================
-- 4. CUSTOMER SEGMENTS
-- ============================================================

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY customer_segment
ORDER BY customers DESC;


-- ============================================================
-- 5. AVERAGE INCOME BY SEGMENT
-- ============================================================

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(annual_income), 2) AS average_income,
    ROUND(MIN(annual_income), 2) AS minimum_income,
    ROUND(MAX(annual_income), 2) AS maximum_income
FROM customers
GROUP BY customer_segment
ORDER BY average_income DESC;


-- ============================================================
-- 6. CUSTOMER STATUS BY SEGMENT
-- ============================================================

SELECT
    customer_segment,
    customer_status,
    COUNT(*) AS customers
FROM customers
GROUP BY
    customer_segment,
    customer_status
ORDER BY
    customer_segment,
    customers DESC;


-- ============================================================
-- 7. CUSTOMERS BY CITY AND SEGMENT
-- ============================================================

SELECT
    city,
    customer_segment,
    COUNT(*) AS customers
FROM customers
GROUP BY
    city,
    customer_segment
ORDER BY
    city,
    customers DESC;


-- ============================================================
-- 8. CUSTOMERS WITH ACCOUNTS
-- ============================================================

SELECT
    COUNT(DISTINCT c.customer_id) AS customers_with_accounts
FROM customers c
INNER JOIN accounts a
    ON c.customer_id = a.customer_id;


-- ============================================================
-- 9. CUSTOMERS WITHOUT ACCOUNTS
-- ============================================================

SELECT
    COUNT(*) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE a.customer_id IS NULL;


-- ============================================================
-- 10. NUMBER OF ACCOUNTS PER CUSTOMER
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment,
    COUNT(a.account_id) AS number_of_accounts
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment
ORDER BY number_of_accounts DESC;


-- ============================================================
-- 11. CUSTOMERS WITH MULTIPLE ACCOUNTS
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment,
    COUNT(a.account_id) AS number_of_accounts
FROM customers c
INNER JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment
HAVING COUNT(a.account_id) > 1
ORDER BY number_of_accounts DESC;


-- ============================================================
-- 12. AVERAGE NUMBER OF ACCOUNTS PER CUSTOMER
-- ============================================================

SELECT
    ROUND(
        COUNT(a.account_id) * 1.0 /
        COUNT(DISTINCT c.customer_id),
        2
    ) AS average_accounts_per_customer
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id;


-- ============================================================
-- 13. CUSTOMER ACCOUNT DISTRIBUTION
-- ============================================================

WITH customer_accounts AS (

    SELECT
        c.customer_id,
        COUNT(a.account_id) AS number_of_accounts

    FROM customers c

    LEFT JOIN accounts a
        ON c.customer_id = a.customer_id

    GROUP BY c.customer_id
)

SELECT
    CASE
        WHEN number_of_accounts = 0 THEN '0 accounts'
        WHEN number_of_accounts = 1 THEN '1 account'
        WHEN number_of_accounts = 2 THEN '2 accounts'
        ELSE '3+ accounts'
    END AS account_group,

    COUNT(*) AS customers

FROM customer_accounts

GROUP BY account_group

ORDER BY
    CASE
        WHEN account_group = '0 accounts' THEN 1
        WHEN account_group = '1 account' THEN 2
        WHEN account_group = '2 accounts' THEN 3
        ELSE 4
    END;


-- ============================================================
-- 14. TOP CUSTOMERS BY ANNUAL INCOME
-- ============================================================

SELECT
    customer_id,
    first_name,
    middle_name,
    last_name,
    second_last_name,
    city,
    customer_segment,
    annual_income
FROM customers
ORDER BY annual_income DESC
LIMIT 20;


-- ============================================================
-- 15. INCOME BY CITY
-- ============================================================

SELECT
    city,
    COUNT(*) AS customers,
    ROUND(AVG(annual_income), 2) AS average_income,
    ROUND(SUM(annual_income), 2) AS total_reported_income
FROM customers
GROUP BY city
ORDER BY average_income DESC;


-- ============================================================
-- 16. CUSTOMER TENURE
-- ============================================================

SELECT
    customer_segment,
    ROUND(
        AVG(
            julianday('2025-12-31')
            - julianday(customer_since)
        ) / 365.25,
        2
    ) AS average_years_as_customer
FROM customers
GROUP BY customer_segment
ORDER BY average_years_as_customer DESC;


-- ============================================================
-- 17. CUSTOMER TENURE GROUPS
-- ============================================================

WITH customer_tenure AS (

    SELECT
        customer_id,
        customer_segment,
        (
            julianday('2025-12-31')
            - julianday(customer_since)
        ) / 365.25 AS years_as_customer

    FROM customers
)

SELECT
    CASE
        WHEN years_as_customer < 2 THEN 'Less than 2 years'
        WHEN years_as_customer < 4 THEN '2-4 years'
        ELSE '4+ years'
    END AS tenure_group,

    COUNT(*) AS customers

FROM customer_tenure

GROUP BY tenure_group

ORDER BY
    CASE
        WHEN tenure_group = 'Less than 2 years' THEN 1
        WHEN tenure_group = '2-4 years' THEN 2
        ELSE 3
    END;


-- ============================================================
-- 18. PREMIUM CUSTOMERS
-- ============================================================

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    annual_income,
    customer_since
FROM customers
WHERE customer_segment = 'Premium'
ORDER BY annual_income DESC
LIMIT 20;


-- ============================================================
-- 19. PREMIUM CUSTOMERS BY CITY
-- ============================================================

SELECT
    city,
    COUNT(*) AS premium_customers,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers
WHERE customer_segment = 'Premium'
GROUP BY city
ORDER BY premium_customers DESC;


-- ============================================================
-- 20. CUSTOMER VALUE PROFILE
-- ============================================================

SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(annual_income), 2) AS average_income,
    ROUND(
        AVG(
            CASE
                WHEN customer_status = 'Active'
                THEN 1.0
                ELSE 0.0
            END
        ) * 100,
        2
    ) AS active_customer_percentage
FROM customers
GROUP BY customer_segment
ORDER BY average_income DESC;

-- ============================================================
-- 21. CUSTOMER ACTIVITY BY NUMBER OF ACCOUNTS
-- ============================================================

WITH customer_activity AS (

    SELECT
        c.customer_id,
        c.customer_segment,
        COUNT(DISTINCT a.account_id) AS number_of_accounts,
        COUNT(t.transaction_id) AS total_transactions,
        ROUND(COALESCE(SUM(t.amount), 0), 2) AS total_transaction_value

    FROM customers c

    INNER JOIN accounts a
        ON c.customer_id = a.customer_id

    LEFT JOIN transactions t
        ON a.account_id = t.account_id

    GROUP BY
        c.customer_id,
        c.customer_segment
)

SELECT
    CASE
        WHEN number_of_accounts = 1 THEN '1 account'
        WHEN number_of_accounts = 2 THEN '2 accounts'
        ELSE '3+ accounts'
    END AS account_group,

    COUNT(*) AS customers,

    ROUND(
        AVG(total_transactions),
        2
    ) AS avg_transactions_per_customer,

    ROUND(
        AVG(total_transaction_value),
        2
    ) AS avg_transaction_value_per_customer,

    ROUND(
        SUM(total_transaction_value),
        2
    ) AS total_transaction_value

FROM customer_activity

GROUP BY account_group

ORDER BY
    number_of_accounts;



-- ============================================================
-- 22. CUSTOMER ACTIVITY BY SEGMENT
-- ============================================================

WITH customer_activity AS (

    SELECT
        c.customer_id,
        c.customer_segment,

        COUNT(DISTINCT a.account_id) AS number_of_accounts,

        COUNT(t.transaction_id) AS total_transactions,

        ROUND(
            COALESCE(SUM(t.amount), 0),
            2
        ) AS total_transaction_value

    FROM customers c

    INNER JOIN accounts a
        ON c.customer_id = a.customer_id

    LEFT JOIN transactions t
        ON a.account_id = t.account_id

    GROUP BY
        c.customer_id,
        c.customer_segment
)

SELECT
    customer_segment,

    COUNT(*) AS customers,

    SUM(number_of_accounts) AS total_accounts,

    SUM(total_transactions) AS total_transactions,

    ROUND(
        AVG(total_transactions),
        2
    ) AS avg_transactions_per_customer,

    ROUND(
        AVG(total_transaction_value),
        2
    ) AS avg_transaction_value_per_customer,

    ROUND(
        SUM(total_transaction_value),
        2
    ) AS total_transaction_value

FROM customer_activity

GROUP BY customer_segment

ORDER BY total_transaction_value DESC;


