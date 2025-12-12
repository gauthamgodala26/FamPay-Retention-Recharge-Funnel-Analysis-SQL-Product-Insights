-- METRIC 3: Transaction type distribution (Merchant vs P2P vs Card)

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
    t.type_of_transaction,
    COUNT(*) AS txn_count,
    CONCAT(
        ROUND(
            100.0 * COUNT(*) /
            SUM(COUNT(*)) OVER (PARTITION BY cte.retention_status),
        2),
        '%'
    ) AS percentage_share
FROM transaction_details t
INNER JOIN cte ON t.user_id = cte.user_id
WHERE t.status = 'Completed'
GROUP BY cte.retention_status, t.type_of_transaction
ORDER BY txn_count DESC;
