![FamApp Logo](https://bookface-images.s3.amazonaws.com/logos/ecf2156d9e82bcc5d049ec91e692bf481952c39e.png)
<p align="center">

# FamApp Retention & Funnel Analysis

This repository presents a complete product and data analysis case study on user retention and recharge-funnel performance for FamApp, a teen-focused financial application.  
It brings together SQL-based retention metrics, behavioural insights, funnel diagnostics, and product strategy recommendations in a single structured project.

---

## Project Overview

Retention and transaction reliability are foundational to growth in consumer fintech.  
- Retained users contribute to higher lifetime value and word-of-mouth acquisition.  
- Recharge funnel performance directly impacts revenue and user trust.

This project covers two major analytical tracks:

1. User Retention Analysis (habit formation, transaction patterns, behavioural segmentation)  
2. Recharge Funnel Diagnostics (conversion issues, operator failures, UPI success decline)

Both analyses are driven using SQL and data interpretation, supported by structured presentations and detailed reasoning.

---

## Project Structure

SQL_QUERIES_TASK1.docx      # SQL queries for retention metrics  
---  
TASK1_PRESENTATION.pptx     # Retention analysis (Insights + Nudges)  
---  
TASK2_PRESENTATION.pptx     # Recharge funnel RCA (Root causes + Fixes)  
---  
README.md                   # Project documentation  
---

---

## Key Analyses

### Retention Metrics (SQL-Based)

The retention study evaluates seven core behavioural dimensions:

- Average transactions per month  
- Time from activation to first transaction  
- Transaction type distribution (Merchant / P2P / Card)  
- Average, minimum, and maximum transaction value  
- Age group distribution  
- Active months distribution  
- Transaction-type diversity (single vs multi-type users)

Insight: Retained FamApp users engage more consistently, transact across more categories, and establish behaviour patterns earlier in their lifecycle.

---

### Recharge Funnel Diagnostics

Recharge funnel performance was analysed across: Browse → Plan Selected → Payment Initiated → Payment Successful → Recharge Confirmed.

Key Issues Identified:
- Significant timeout increase from Operator X (55% share of volume)  
- Delayed confirmations from Operator Y  
- Drop in UPI success rate  
- Surge in user complaints and delay reports  

Insight: The revenue decline stemmed from operator-side failures and UPI reliability issues, which led to customer frustration and reduced repeat attempts.

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

## METRIC 2: Average Time between activation and first transaction

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



