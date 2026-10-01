-- ============================================================
-- 1. TRANSACTION VALUE BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.customer_segment,

    COUNT(DISTINCT c.customer_id) AS customers,

    COUNT(DISTINCT a.account_id) AS accounts,

    COUNT(t.transaction_id) AS completed_transactions,

    ROUND(SUM(t.amount), 2) AS total_transaction_value,

    ROUND(
        SUM(t.amount) / COUNT(DISTINCT c.customer_id),
        2
    ) AS average_value_per_customer,

    ROUND(
        SUM(t.amount) / COUNT(DISTINCT a.account_id),
        2
    ) AS average_value_per_account

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
-- 2. CHANNEL PERFORMANCE AND FAILURE RATE
-- ============================================================

SELECT
    channel,

    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Completed'
            THEN 1
            ELSE 0
        END
    ) AS completed_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate,

    ROUND(
        SUM(
            CASE
                WHEN transaction_status = 'Completed'
                THEN amount
                ELSE 0
            END
        ),
        2
    ) AS completed_transaction_value,

    ROUND(
        AVG(amount),
        2
    ) AS average_transaction_amount

FROM transactions

GROUP BY
    channel

ORDER BY
    failure_rate DESC;


