# 🛍️ Customer Segmentation using eCommerce Data (SQL RFM Analysis)

## 📌 Project Overview
This project segments customers based on their purchasing behavior using the RFM model (Recency, Frequency, Monetary). SQL was used to calculate RFM scores and rank customers using CTEs and window functions.

## 🧠 Objective
Classify customers as VIPs, Loyal, At-Risk, etc., using:
- **Recency**: How recently they purchased
- **Frequency**: How often they purchase
- **Monetary**: How much they spend

## 🗃️ Dataset
Single table: `raw_transactions`

## 🛠️ Tools Used
- MySQL
- CTEs
- Window Functions (`NTILE`, `DATEDIFF`)
- Aggregations and JOINs

## 🔍 SQL Highlights
- Used `NTILE(5)` to assign RFM scores
- Combined metrics with CTEs
- Final RFM score = sum of R, F, M

## 🧮 Output
| CustomerID | Recency | Frequency | Monetary | R_Score | F_Score | M_Score | RFM_Score |
|------------|---------|-----------|----------|---------|---------|---------|-----------|



