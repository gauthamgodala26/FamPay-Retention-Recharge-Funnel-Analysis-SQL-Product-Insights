-- METRIC 4: Avg, Min, Max transaction value

WITH cte AS (
    SELECT
        user_id,
        CASE WHEN COUNT(DISTINCT date_trunc('month', date_of_transaction)) >= 3
             THEN 'Retained' ELSE 'Not Retained' END AS retention_status
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
)
SELECT
    cte.retention_status,
    AVG(t.amount) AS avg_txn_value,
    MAX(t.amount) AS max_txn_value,
    MIN(t.amount) AS min_txn_value
FROM transaction_details t
INNER JOIN cte ON t.user_id = cte.user_id
WHERE t.status = 'Completed'
GROUP BY cte.retention_status;
