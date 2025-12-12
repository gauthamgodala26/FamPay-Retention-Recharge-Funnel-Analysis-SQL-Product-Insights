![FamApp Logo](https://bookface-images.s3.amazonaws.com/logos/ecf2156d9e82bcc5d049ec91e692bf481952c39e.png)
<p align="center">

# FamApp Retention & Recharge Funnel Analysis (SQL + Product Case Study)

## Overview
FamApp is a teen-focused payments platform where retention and transaction reliability directly impact growth.  
This project uses SQL to analyze user behaviour, understand habit formation, evaluate retention metrics, and diagnose the recharge funnel drop that led to a 25% revenue decline.

---

## Skills Used
- SQL Querying & Behavioural Analysis  
- Cohort, Retention & Funnel Analysis  
- Window Functions, Aggregations, CTEs  
- Product Thinking, RCA, User Habit Identification  
- Data Interpretation & Insight Communication  

---

## Why This Project Matters
Retention is the strongest driver of long-term fintech growth, and reliable recharges build user trust.  
This analysis helps FamApp:

- Improve user activation & repeat transaction behaviour  
- Identify habit-forming patterns  
- Reduce funnel leakage & operator failures  
- Improve revenue, trust, and overall user experience  

---

## Project Objectives
- Define retained vs non-retained users  
- Identify habit-forming actions  
- Build seven SQL-based behavioural metrics  
- Diagnose recharge funnel drop (40% decline in success)  
- Identify P0/P1 root causes and propose fixes  
- Recommend product nudges to improve retention  

---

## Dataset & Schema  
Two tables were analyzed:

### `user_details`  
- user_id, activation_date, age, name  

### `transaction`  
- user_id, txn_id, type_of_transaction, date_of_transaction, status, amount  

Metrics were developed entirely using SQL (PostgreSQL).

---

## SQL Metrics (Task 1)
SQL scripts for all 7 retention metrics are available in the `/sql` folder:

- Average transactions per month  
- Activation → first transaction delay  
- Transaction type distribution  
- Min/Max/Avg transaction value  
- Age segmentation  
- Active months  
- Transaction diversity (multi-type users)  

These metrics reveal how early engagement, transaction frequency, and behaviour depth predict long-term retention.

---

## Recharge Funnel RCA (Task 2)

### Key Findings
- Operator X timeout errors increased 3× (55% traffic share)  
- Operator Y confirmations delayed by 1–2 hours  
- UPI payment success dropped 15%  
- User complaints doubled (trust erosion)  

### Primary Causes
- Operator-side instability  
- UPI reliability issues  
- Poor in-app communication during failures  

### Business Impact
- 25% revenue drop in 10 days  
- 40% decline in successful recharges  
- Higher churn risk and reduced retry attempts  

---

## Proposed Solutions

### Immediate Fixes (P0)
- Outage alerts & fallback messages  
- Instant refunds for failed recharges  
- Retry logic for failed UPI attempts  

### Mid-Term (P1)
- Operator SLAs & dynamic routing  
- Delay fallback notifications  
- Improved reliability tracking  

### Long-Term (P2)
- Operator diversification  
- Real-time reliability dashboards  
- Trust indicators (success rates, refund guarantees)  

---

## Key Insights
- Retained users transact 2–3× more often  
- Multi-type transaction users show highest long-term retention  
- Faster first transaction strongly predicts habit formation  
- Recharge issues are structural (operators + UPI), not behavioural  

---

## Deliverables
- `/sql` — All metric-wise SQL queries  
- `TASK1_PRESENTATION.pptx` — Retention insights & nudges  
- `TASK2_PRESENTATION.pptx` — Recharge RCA & roadmap  
- `README.md` — Project documentation  

---

## Author  
**Sai Gautham Godala**




---

## SQL Queries (Task 1)

### Metric 1: Average Transactions per Month (Retained vs Not Retained)

```sql
WITH cte AS (
    SELECT
        user_id,
        CASE WHEN COUNT(DISTINCT date_trunc('month', date_of_transaction)) >= 3
             THEN 'Retained' ELSE 'Not Retained' END AS retention_status,
        COUNT(*) AS txn_count
    FROM transaction_details
    WHERE status = 'Completed'
    GROUP BY user_id
)

SELECT
    retention_status,
    ROUND(AVG(txn_count), 2) AS avg_transactions
FROM cte
GROUP BY retention_status;

```

### METRIC 2: Average Time between activation and first transaction
```sql
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
```
### METRIC 3: Transaction type distribution (Merchant vs P2P vs Card)
```sql
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
            SUM(COUNT(*)) OVER (PARTITION BY cte.retention_status), 2
        ),
        '%'
    ) AS percentage_share
FROM transaction_details t
INNER JOIN cte ON t.user_id = cte.user_id
WHERE t.status = 'Completed'
GROUP BY cte.retention_status, t.type_of_transaction
ORDER BY txn_count DESC;
```
### METRIC 4: Avg, Min, Max transaction value
```sql
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
```
### METRIC 5: Age group distribution (Teens, Young Adults, Adults)
```sql
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
```

### METRIC 6: Average active months (Retained vs Non Retained)
```sql
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
```
### METRIC 7: Transaction type diversity (Single vs Multi-type users)
```sql
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
```
