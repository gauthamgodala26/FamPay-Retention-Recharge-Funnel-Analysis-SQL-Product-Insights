![FamApp Logo](https://bookface-images.s3.amazonaws.com/logos/ecf2156d9e82bcc5d049ec91e692bf481952c39e.png)
<p align="center">

# FamApp Retention & Funnel Analysis

This repository presents a comprehensive product and data analysis case study focused on user retention and recharge-funnel performance for **FamApp**, a payments platform built for teens and young adults.  
The project consolidates SQL-driven behavioural metrics, retention insights, funnel diagnostics, and product strategy recommendations into a single, structured, and business-ready deliverable.

---

## Project Overview

Retention and transactional reliability form the backbone of long-term growth in consumer fintech.  

- Strong retention directly contributes to higher lifetime value, lower acquisition costs, and sustained engagement.  
- A healthy recharge funnel is essential for revenue generation and trust — any instability immediately impacts user confidence.

This project investigates two critical analytical areas:

1. **User Retention Analysis**  
   Examines activation behaviour, transaction patterns, frequency, diversity, and early habit formation.  

2. **Recharge Funnel Diagnostics**  
   Evaluates stage-wise drop-offs, operator performance issues, UPI reliability, and the resulting impact on GMV and revenue.  

Both analyses are powered by SQL queries, data interpretation, structured documentation, and product-focused frameworks.

---

## Project Structure

SQL_QUERIES_TASK1.docx      — SQL queries for all retention metrics  
---  
TASK1_PRESENTATION.pptx     — Retention analysis (behavioural insights, habit formation, nudges)  
---  
TASK2_PRESENTATION.pptx     — Recharge funnel RCA (root causes, impact, prioritised solutions)  
---  
README.md                   — Project documentation  
---

---

## Key Analyses

### Retention Metrics (SQL-Based)

The retention study explores seven core behavioural dimensions that differentiate **retained** users from **non-retained** users:

- Average transactions per month  
- Time from activation to first transaction  
- Transaction type distribution (P2P, Merchant, Card)  
- Transaction value characteristics (average, minimum, maximum)  
- Age group segmentation  
- Active months across the three-month window  
- Diversity of transaction types (single-type vs multi-type users)

**Key Insight:**  
Retained users adopt meaningful behaviours early — they transact more frequently, use a broader set of transaction types, and show stronger, more consistent engagement patterns throughout the time period.

---

### Recharge Funnel Diagnostics

Recharge funnel performance was assessed across the full flow:  
**Browse → Plan Selected → Payment Initiated → Payment Successful → Recharge Confirmed**

The analysis revealed the following issues:

- A sharp increase in timeout errors from **Operator X**, which handles more than half of all recharge volume  
- Significant delays in confirmation from **Operator Y**  
- A measurable decline in UPI payment success rates  
- A rise in user complaints and frustration related to delayed or failed recharges  

**Key Insight:**  
The revenue and success-rate decline was driven primarily by operator-side instability and payment-rail reliability issues. These disruptions materially affected user trust and contributed to repeated funnel abandonment.

---



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
