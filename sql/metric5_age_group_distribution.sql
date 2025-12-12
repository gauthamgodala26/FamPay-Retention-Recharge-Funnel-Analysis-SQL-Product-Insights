-- METRIC 5: Age group distribution (Teens, Young Adults, Adults)

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
    CASE
        WHEN u.age BETWEEN 13 AND 17 THEN 'Teen(13-17)'
        WHEN u.age BETWEEN 18 AND 21 THEN 'Young Adult(18-21)'
        WHEN u.age BETWEEN 22 AND 25 THEN 'Adult(22-25)'
        ELSE 'Other'
    END AS age_distribution,
    COUNT(*) AS users
FROM user_details u
INNER JOIN cte ON u.user_id = cte.user_id
GROUP BY cte.retention_status, age_distribution
ORDER BY cte.retention_status, users DESC;
