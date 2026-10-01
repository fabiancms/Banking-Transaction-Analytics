-- ============================================================
-- BANKING CUSTOMER TRANSACTION ANALYTICS
-- 01 - DATA VALIDATION
-- ============================================================

-- ============================================================
-- 1. RECORD COUNTS
-- ============================================================

-- Customers
SELECT 
    'customers' AS table_name,
    COUNT(*) AS total_records
FROM customers;

-- Accounts
SELECT 
    'accounts' AS table_name,
    COUNT(*) AS total_records
FROM accounts;

-- Transactions
SELECT 
    'transactions' AS table_name,
    COUNT(*) AS total_records
FROM transactions;

-- Branches
SELECT 
    'branches' AS table_name,
    COUNT(*) AS total_records
FROM branches;


-- ============================================================
-- 2. EXPECTED RECORD COUNTS
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM accounts) AS accounts,
    (SELECT COUNT(*) FROM transactions) AS transactions,
    (SELECT COUNT(*) FROM branches) AS branches;


-- ============================================================
-- 3. DUPLICATE PRIMARY KEYS
-- ============================================================

-- Duplicate customers
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Duplicate accounts
SELECT
    account_id,
    COUNT(*) AS occurrences
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;


-- Duplicate transactions
SELECT
    transaction_id,
    COUNT(*) AS occurrences
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Duplicate branches
SELECT
    branch_id,
    COUNT(*) AS occurrences
FROM branches
GROUP BY branch_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. NULL VALUES
-- ============================================================

SELECT
    'customers' AS table_name,

    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS first_name_nulls,
    SUM(CASE WHEN middle_name IS NULL THEN 1 ELSE 0 END) AS middle_name_nulls,
    SUM(CASE WHEN last_name IS NULL THEN 1 ELSE 0 END) AS last_name_nulls,
    SUM(CASE WHEN second_last_name IS NULL THEN 1 ELSE 0 END) AS second_last_name_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS segment_nulls,
    SUM(CASE WHEN customer_since IS NULL THEN 1 ELSE 0 END) AS customer_since_nulls,
    SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS income_nulls,
    SUM(CASE WHEN customer_status IS NULL THEN 1 ELSE 0 END) AS status_nulls

FROM customers;


SELECT
    'accounts' AS table_name,

    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS account_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN branch_id IS NULL THEN 1 ELSE 0 END) AS branch_id_nulls,
    SUM(CASE WHEN account_type IS NULL THEN 1 ELSE 0 END) AS account_type_nulls,
    SUM(CASE WHEN opening_date IS NULL THEN 1 ELSE 0 END) AS opening_date_nulls,
    SUM(CASE WHEN current_balance IS NULL THEN 1 ELSE 0 END) AS balance_nulls,
    SUM(CASE WHEN account_status IS NULL THEN 1 ELSE 0 END) AS status_nulls

FROM accounts;


SELECT
    'transactions' AS table_name,

    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS transaction_id_nulls,
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS account_id_nulls,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS transaction_date_nulls,
    SUM(CASE WHEN transaction_type IS NULL THEN 1 ELSE 0 END) AS transaction_type_nulls,
    SUM(CASE WHEN channel IS NULL THEN 1 ELSE 0 END) AS channel_nulls,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS amount_nulls,
    SUM(CASE WHEN transaction_status IS NULL THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) AS merchant_category_nulls

FROM transactions;


-- ============================================================
-- 5. CUSTOMER DATA VALIDATION
-- ============================================================

-- Gender distribution
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


-- Customer segment distribution
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


-- Customer status distribution
SELECT
    customer_status,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY customer_status
ORDER BY customers DESC;


-- ============================================================
-- 6. CITY VALIDATION
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
-- 7. ACCOUNT VALIDATION
-- ============================================================

-- Account type distribution
SELECT
    account_type,
    COUNT(*) AS accounts,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage
FROM accounts
GROUP BY account_type
ORDER BY accounts DESC;


-- Account status distribution
SELECT
    account_status,
    COUNT(*) AS accounts,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage
FROM accounts
GROUP BY account_status
ORDER BY accounts DESC;


-- ============================================================
-- 8. TRANSACTION DATE RANGE
-- ============================================================

SELECT
    MIN(transaction_date) AS first_transaction,
    MAX(transaction_date) AS last_transaction
FROM transactions;


-- ============================================================
-- 9. TRANSACTION STATUS
-- ============================================================

SELECT
    transaction_status,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY transaction_status
ORDER BY transactions DESC;


-- ============================================================
-- 10. TRANSACTION TYPES
-- ============================================================

SELECT
    transaction_type,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY transaction_type
ORDER BY transactions DESC;


-- ============================================================
-- 11. TRANSACTION CHANNELS
-- ============================================================

SELECT
    channel,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY channel
ORDER BY transactions DESC;


-- ============================================================
-- 12. MERCHANT CATEGORIES
-- ============================================================

SELECT
    merchant_category,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY merchant_category
ORDER BY transactions DESC;


-- ============================================================
-- 13. INVALID TRANSACTION AMOUNTS
-- ============================================================

SELECT
    COUNT(*) AS invalid_amounts
FROM transactions
WHERE amount <= 0;


-- ============================================================
-- 14. FOREIGN KEY VALIDATION
-- ============================================================

-- Accounts without a valid customer
SELECT
    COUNT(*) AS accounts_without_customer
FROM accounts a
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Accounts without a valid branch
SELECT
    COUNT(*) AS accounts_without_branch
FROM accounts a
LEFT JOIN branches b
    ON a.branch_id = b.branch_id
WHERE b.branch_id IS NULL;


-- Transactions without a valid account
SELECT
    COUNT(*) AS transactions_without_account
FROM transactions t
LEFT JOIN accounts a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;


-- ============================================================
-- 15. CUSTOMERS WITHOUT ACCOUNTS
-- ============================================================

SELECT
    COUNT(*) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE a.customer_id IS NULL;


-- ============================================================
-- 16. CUSTOMERS WITH MULTIPLE ACCOUNTS
-- ============================================================

SELECT
    customer_id,
    COUNT(*) AS number_of_accounts
FROM accounts
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY number_of_accounts DESC;


-- ============================================================
-- 17. BASIC TRANSACTION STATISTICS
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction,
    ROUND(MIN(amount), 2) AS minimum_transaction,
    ROUND(MAX(amount), 2) AS maximum_transaction
FROM transactions;


-- ============================================================
-- 18. DATABASE VALIDATION SUMMARY
-- ============================================================

SELECT
    CASE
        WHEN
            (SELECT COUNT(*) FROM customers) = 10549
            AND
            (SELECT COUNT(*) FROM accounts) = 15824
            AND
            (SELECT COUNT(*) FROM transactions) = 306872
            AND
            (SELECT COUNT(*) FROM branches) = 15
        THEN 'PASS'
        ELSE 'CHECK'
    END AS record_count_validation;