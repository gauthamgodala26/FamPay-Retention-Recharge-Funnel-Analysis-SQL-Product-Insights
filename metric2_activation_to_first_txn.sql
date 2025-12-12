-- METRIC 2: Average Time between activation and first transaction

WITH cte AS (
    SELECT
        u.user_id,
        CASE WHEN COUNT(DISTINCT date_trunc('month', t.date_of_transaction)) >= 3
             THEN 'Retained' ELSE 'Not Retained' END AS retention_status,
        MIN(t.date_of_transaction) - u.activation_date AS days_to_first_txn
    FROM transaction_details t
    INNER JOIN user_details u ON t.user_id = u.user_id
    WHERE t.status = 'Completed'
    GROUP BY u.user_id
)
SELECT
    retention_status,
    AVG(days_to_first_txn) AS avg_days2_first_txn
FROM cte
GROUP BY retention_status;
