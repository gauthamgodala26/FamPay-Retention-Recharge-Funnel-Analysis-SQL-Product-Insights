-- METRIC 6: Average active months (Retained vs Non Retained)

WITH active_months AS (
    SELECT
        user_id,
        COUNT(DISTINCT date_trunc('month', date_of_transaction)) AS active_months
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
),
retention_status AS (
    SELECT
        user_id,
        CASE WHEN COUNT(DISTINCT date_trunc('month', date_of_transaction)) >= 3
             THEN 'Retained' ELSE 'Not Retained' END AS retention_status
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
)
SELECT
    rs.retention_status,
    AVG(am.active_months) AS avg_active_months
FROM retention_status rs
INNER JOIN active_months am ON rs.user_id = am.user_id
GROUP BY rs.retention_status;
