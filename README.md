![FamPay Logo](https://bookface-images.s3.amazonaws.com/logos/ecf2156d9e82bcc5d049ec91e692bf481952c39e.png)
<p align="center">
 

#  FamPay Retention & Funnel Analysis

This repository showcases a **complete product + data analysis case study** on **user retention** and **recharge funnel optimization** for **FamPay**, India’s teen-focused payments app.  
It combines **SQL queries, retention metrics, funnel diagnostics, and product strategy recommendations** into a single structured project.  



##  Project Overview

Retention and reliability are the lifeblood of fintech apps like **FamPay**.  
- **Retention** drives long-term growth — acquiring new users costs 5–7x more than keeping existing ones.  
- **Recharge funnel success** is critical for revenue — sudden drops signal systemic issues that erode trust.  

This project deep-dives into:  
1. **User Retention Analysis** (Habit formation, active months, transaction diversity).  
2. **Recharge Funnel Diagnostics** (Identifying drop-offs, operator failures, UPI reliability).  
3. **Actionable Product Insights** (Data-backed nudges, loyalty programs, transparency measures).  



##  Project Structure

├── SQL_QUERIES_TASK1.docx # SQL queries for retention metrics
---
├── TASK1_PRESENTATION.pptx # Retention analysis presentation (Insights + Nudges)
---
├── TASK2_PRESENTATION.pptx # Recharge funnel analysis (Root causes + Fixes)
---
└── README.md # Project documentation
---




##  Key Analyses

### **Retention Metrics (SQL-based)**
- Avg. transactions per month (Retained vs Non-Retained)  
- Avg. time from activation → first transaction  
- Transaction type distribution (Merchant / P2P / Card)  
- Avg, Min, Max transaction value  
- Age group distribution (Teens, Young Adults, Adults)  
- Average active months  
- % of multi-type users (diversity of transactions)  

➡ **Insight:** Retained FamPay users transact **2–3x more frequently**, adopt **multiple transaction types**, and show **higher average spend**.  


### **Recharge Funnel Diagnostics**
- **Stage drops:** Browse → Plan → Payment → Success → Confirmation  
- **Key issues identified:**  
  - Operator X timeout failures (3× spike, 55% share).  
  - UPI reliability dip (−15% success).  
  - Operator Y delays (1–2 hrs confirmation).  
  - Growing **trust erosion**: complaints doubled, social mentions spiked.  

➡ **Insight:** FamPay’s funnel leakages were driven primarily by **infrastructure failures** (operator & UPI), amplified by **lack of user transparency**.  



##  Recommendations

- **Retention Playbook for FamPay:**  
  - Onboarding rewards for **first transaction**.  
  - Cashback nudges for **repeat usage**.  
  - Cross-sell multiple transaction types early (UPI + Card).  
  - Loyalty program with **progressive unlocks**.  

- **Recharge Funnel Fixes for FamPay:**  
  - Short term: In-app outage alerts, fallback payment suggestions, instant refunds.  
  - Medium term: Operator reliability SLAs, retry logic for UPI failures.  
  - Long term: Operator diversification, real-time monitoring, **user trust signals** (live success rates, “Recharge or Refund in 30 mins”).  



##  Tech Stack

- **SQL (PostgreSQL)** – for retention & funnel queries  
- **Excel** – for visualization 
- **Business/Product Frameworks** – root cause analysis, prioritization, user nudges  

---

##  Outcomes

- Built **7 retention metrics** entirely in SQL.  
- Identified **3 major recharge funnel bottlenecks** with quantified impact.  
- Proposed **short-term + long-term fixes** balancing **user trust** and **infra resilience**.  

---

##  Author  
**Sai Gautham Godala**  
 

---
