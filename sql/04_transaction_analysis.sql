-- ============================================================
-- BANKING CUSTOMER TRANSACTION ANALYTICS
-- 04 - TRANSACTION ANALYSIS
-- ============================================================


-- ============================================================
-- 1. TRANSACTION OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount,
    ROUND(MIN(amount), 2) AS minimum_amount,
    ROUND(MAX(amount), 2) AS maximum_amount
FROM transactions;


-- ============================================================
-- 2. TRANSACTIONS BY TYPE
-- ============================================================

SELECT
    transaction_type,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY transaction_type
ORDER BY total_value DESC;


-- ============================================================
-- 3. TRANSACTIONS BY CHANNEL
-- ============================================================

SELECT
    channel,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY channel
ORDER BY total_value DESC;


-- ============================================================
-- 4. TRANSACTION STATUS
-- ============================================================

SELECT
    transaction_status,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY transaction_status
ORDER BY transactions DESC;


-- ============================================================
-- 5. MERCHANT CATEGORY
-- ============================================================

SELECT
    merchant_category,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY merchant_category
ORDER BY total_value DESC;

-- ============================================================
-- 6. TRANSACTION STATUS BY CHANNEL
-- ============================================================

SELECT
    channel,
    transaction_status,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (
            PARTITION BY channel
        ),
        2
    ) AS percentage,
    ROUND(SUM(amount), 2) AS total_value
FROM transactions
GROUP BY
    channel,
    transaction_status
ORDER BY
    channel,
    transactions DESC;


-- ============================================================
-- 7. TRANSACTION STATUS BY TYPE
-- ============================================================

SELECT
    transaction_type,
    transaction_status,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (
            PARTITION BY transaction_type
        ),
        2
    ) AS percentage,
    ROUND(SUM(amount), 2) AS total_value
FROM transactions
GROUP BY
    transaction_type,
    transaction_status
ORDER BY
    transaction_type,
    transactions DESC;


-- ============================================================
-- 8. TRANSACTIONS BY YEAR
-- ============================================================

SELECT
    strftime('%Y', transaction_date) AS year,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY year
ORDER BY year;

-- ============================================================
-- 9. TRANSACTIONS BY MONTH
-- ============================================================

SELECT
    strftime('%Y-%m', transaction_date) AS month,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS total_value,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY month
ORDER BY month;


-- ============================================================
-- 10. CUSTOMER TRANSACTION VALUE
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment,

    COUNT(DISTINCT a.account_id) AS number_of_accounts,

    COUNT(t.transaction_id) AS total_transactions,

    ROUND(
        COALESCE(SUM(t.amount), 0),
        2
    ) AS total_transaction_value,

    ROUND(
        COALESCE(AVG(t.amount), 0),
        2
    ) AS average_transaction_amount

FROM customers c

INNER JOIN accounts a
    ON c.customer_id = a.customer_id

LEFT JOIN transactions t
    ON a.account_id = t.account_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment

ORDER BY
    total_transaction_value DESC

LIMIT 20;


-- ============================================================
-- 11. TOP CUSTOMERS BY COMPLETED TRANSACTION VALUE
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment,

    COUNT(DISTINCT a.account_id) AS number_of_accounts,

    COUNT(t.transaction_id) AS completed_transactions,

    ROUND(
        SUM(t.amount),
        2
    ) AS completed_transaction_value,

    ROUND(
        AVG(t.amount),
        2
    ) AS average_transaction_amount

FROM customers c

INNER JOIN accounts a
    ON c.customer_id = a.customer_id

INNER JOIN transactions t
    ON a.account_id = t.account_id

WHERE t.transaction_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.customer_segment

ORDER BY
    completed_transaction_value DESC

LIMIT 20;


-- ============================================================
-- 12. TRANSACTION BEHAVIOR BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.customer_segment,

    COUNT(DISTINCT c.customer_id) AS customers,

    COUNT(DISTINCT a.account_id) AS total_accounts,

    COUNT(t.transaction_id) AS completed_transactions,

    ROUND(
        SUM(t.amount),
        2
    ) AS total_transaction_value,

    ROUND(
        SUM(t.amount) /
        COUNT(DISTINCT c.customer_id),
        2
    ) AS average_value_per_customer,

    ROUND(
        COUNT(t.transaction_id) * 1.0 /
        COUNT(DISTINCT c.customer_id),
        2
    ) AS average_transactions_per_customer,

    ROUND(
        AVG(t.amount),
        2
    ) AS average_transaction_amount

FROM customers c

INNER JOIN accounts a
    ON c.customer_id = a.customer_id

INNER JOIN transactions t
    ON a.account_id = t.account_id

WHERE t.transaction_status = 'Completed'

GROUP BY
    c.customer_segment

ORDER BY
    total_transaction_value DESC;

    


-- ============================================================
-- 13. TRANSACTION PERFORMANCE BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.customer_segment,

    COUNT(DISTINCT c.customer_id) AS customers,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Completed'
            THEN 1
            ELSE 0
        END
    ) AS completed_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        SUM(
            CASE
                WHEN t.transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        COUNT(t.transaction_id),
        2
    ) AS failure_rate,

    ROUND(
        SUM(
            CASE
                WHEN t.transaction_status = 'Completed'
                THEN t.amount
                ELSE 0
            END
        ),
        2
    ) AS completed_transaction_value

FROM customers c

INNER JOIN accounts a
    ON c.customer_id = a.customer_id

INNER JOIN transactions t
    ON a.account_id = t.account_id

GROUP BY
    c.customer_segment

ORDER BY
    failure_rate DESC;


    