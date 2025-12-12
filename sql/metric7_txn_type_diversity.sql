-- METRIC 7: Transaction type diversity (Single vs Multi-type users)

WITH retention_status AS (
    SELECT
        user_id,
        CASE WHEN COUNT(DISTINCT date_trunc('month', date_of_transaction)) >= 3
             THEN 'Retained' ELSE 'Not Retained' END AS retention_status
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
),
txn_type AS (
    SELECT
        user_id,
        COUNT(DISTINCT type_of_transaction) AS txn_type_count
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
)
SELECT
    rs.retention_status,
    SUM(CASE WHEN t.txn_type_count >= 2 THEN 1 ELSE 0 END) AS multiple_users,
    COUNT(*) AS total_users,
    CONCAT(
        ROUND(
            100.0 *
            SUM(CASE WHEN t.txn_type_count >= 2 THEN 1 ELSE 0 END) /
            COUNT(*),
        2),
        '%'
    ) AS percentage_of_multipletype_users
FROM retention_status rs
INNER JOIN txn_type t ON rs.user_id = t.user_id
GROUP BY rs.retention_status;
