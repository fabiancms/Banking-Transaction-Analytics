-- ============================================================
-- 1. ACCOUNT OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_accounts,

    COUNT(DISTINCT customer_id) AS customers_with_accounts,

    COUNT(DISTINCT branch_id) AS branches,

    COUNT(DISTINCT account_type) AS account_types

FROM accounts;


-- ============================================================
-- 2. ACCOUNTS BY TYPE AND STATUS
-- ============================================================

SELECT
    account_type,
    account_status,
    COUNT(*) AS total_accounts,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage,
    ROUND(AVG(current_balance), 2) AS average_balance,
    ROUND(SUM(current_balance), 2) AS total_balance

FROM accounts

GROUP BY
    account_type,
    account_status

ORDER BY
    account_type,
    total_accounts DESC;


-- ============================================================
-- 3. ACCOUNTS BY CITY
-- ============================================================

SELECT
    c.city,
    COUNT(a.account_id) AS total_accounts,
    COUNT(DISTINCT a.customer_id) AS customers,
    ROUND(AVG(a.current_balance), 2) AS average_balance,
    ROUND(SUM(a.current_balance), 2) AS total_balance

FROM accounts a

INNER JOIN customers c
    ON a.customer_id = c.customer_id

GROUP BY
    c.city

ORDER BY
    total_balance DESC;



-- ============================================================
-- 4. BALANCE BY ACCOUNT TYPE
-- ============================================================

SELECT
    account_type,

    COUNT(*) AS total_accounts,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(AVG(current_balance), 2) AS average_balance,

    ROUND(MIN(current_balance), 2) AS minimum_balance,

    ROUND(MAX(current_balance), 2) AS maximum_balance,

    ROUND(SUM(current_balance), 2) AS total_balance

FROM accounts

GROUP BY
    account_type

ORDER BY
    total_balance DESC;


-- ============================================================
-- 5. ACCOUNT STATUS ANALYSIS
-- ============================================================

SELECT
    account_status,

    COUNT(*) AS total_accounts,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage,

    ROUND(AVG(current_balance), 2) AS average_balance,

    ROUND(SUM(current_balance), 2) AS total_balance

FROM accounts

GROUP BY
    account_status

ORDER BY
    total_accounts DESC;



-- ============================================================
-- 6. ACCOUNTS OPENED BY YEAR
-- ============================================================

SELECT
    strftime('%Y', opening_date) AS opening_year,

    COUNT(*) AS total_accounts,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(AVG(current_balance), 2) AS average_balance,

    ROUND(SUM(current_balance), 2) AS total_balance

FROM accounts

GROUP BY
    opening_year

ORDER BY
    opening_year;



-- ============================================================
-- 7. ACCOUNT BALANCE DISTRIBUTION
-- ============================================================

SELECT
    CASE
        WHEN current_balance < 1000 THEN '0 - 999'
        WHEN current_balance < 5000 THEN '1,000 - 4,999'
        WHEN current_balance < 10000 THEN '5,000 - 9,999'
        WHEN current_balance < 25000 THEN '10,000 - 24,999'
        ELSE '25,000+'
    END AS balance_range,

    COUNT(*) AS total_accounts,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage,

    ROUND(AVG(current_balance), 2) AS average_balance,

    ROUND(SUM(current_balance), 2) AS total_balance

FROM accounts

GROUP BY
    balance_range

ORDER BY
    CASE balance_range
        WHEN '0 - 999' THEN 1
        WHEN '1,000 - 4,999' THEN 2
        WHEN '5,000 - 9,999' THEN 3
        WHEN '10,000 - 24,999' THEN 4
        WHEN '25,000+' THEN 5
    END;


