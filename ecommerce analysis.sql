-- 0. number of sales record
SELECT COUNT(*) FROM raw_transactions;
-- 1. Number of unique products
SELECT COUNT(DISTINCT StockCode) FROM raw_transactions;


-- 2.  Number of unique customers
SELECT COUNT(DISTINCT CustomerID) FROM raw_transactions;

-- 3. Date range of sales
SELECT MIN(InvoiceDate) AS StartDate, MAX(InvoiceDate) AS EndDate FROM raw_transactions;

-- 4. top 10 best-selling products by revenue.
SELECT StockCode, 
       Description, 
       SUM(UnitPrice * Quantity) AS TotalRevenue
FROM raw_transactions
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 5. total revenue for each month.
SELECT EXTRACT(YEAR FROM InvoiceDate) AS Year,
       EXTRACT(MONTH FROM InvoiceDate) AS Month,
       SUM(UnitPrice * Quantity) AS total_revenue
FROM raw_transactions
GROUP BY Year, Month
ORDER BY Year, Month;

-- 6. the Average Order Value (AOV)
SELECT 
    SUM(UnitPrice * Quantity) / COUNT(DISTINCT InvoiceNo) AS avg_order_value
FROM raw_transactions;
 
-- 7. New vs Returning Customers
WITH first_orders AS (
    SELECT CustomerID, MIN(InvoiceDate) AS FirstPurchase
    FROM raw_transactions
    GROUP BY CustomerID
)

SELECT 
    t.CustomerID,
    t.InvoiceNo,
    t.InvoiceDate,
    f.FirstPurchase,
    CASE 
        WHEN t.InvoiceDate = f.FirstPurchase THEN 'New'
        ELSE 'Returning'
    END AS customer_type
FROM raw_transactions t
JOIN first_orders f ON t.CustomerID = f.CustomerID;

-- 8. New vs Returning Customers per Month
WITH first_orders AS (
    SELECT CustomerID, MIN(InvoiceDate) AS FirstPurchase
    FROM raw_transactions
    GROUP BY CustomerID
)

SELECT 
    EXTRACT(YEAR FROM t.InvoiceDate) AS Year,
    EXTRACT(MONTH FROM t.InvoiceDate) AS Month,
    CASE
        WHEN t.InvoiceDate = f.FirstPurchase THEN 'New'
        ELSE 'Returning'
    END AS customer_type,
    COUNT(DISTINCT t.CustomerID) AS customer_count
FROM raw_transactions t
JOIN first_orders f ON t.CustomerID = f.CustomerID
GROUP BY Year, Month, customer_type
ORDER BY Year, Month, customer_type;

-- RFM Analysis
-- 8. Recency
WITH last_purchase_date AS (
    SELECT CustomerID, MAX(InvoiceDate) AS last_purchase
    FROM raw_transactions
    GROUP BY CustomerID
)

SELECT 
    CustomerID,
    last_purchase,
    DATEDIFF('2011-12-10', last_purchase) AS recency_days
FROM last_purchase_date;

-- 9. Frequency
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS frequency
FROM raw_transactions
GROUP BY CustomerID;

-- 10.Monetary = Total amount a customer has spent
SELECT CustomerID, SUM(UnitPrice * Quantity) AS monetary_value
FROM raw_transactions
GROUP BY CustomerID;

-- OR
-- RFM
WITH recency_cte AS (
    SELECT CustomerID, MAX(InvoiceDate) AS last_purchase
    FROM raw_transactions
    GROUP BY CustomerID
),
frequency_cte AS (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS frequency
    FROM raw_transactions
    GROUP BY CustomerID
),
monetary_cte AS (
    SELECT CustomerID, SUM(UnitPrice * Quantity) AS monetary
    FROM raw_transactions
    GROUP BY CustomerID
)

SELECT 
    r.CustomerID,
    DATEDIFF('2011-12-10', r.last_purchase) AS recency,
    f.frequency,
    m.monetary
FROM recency_cte r
JOIN frequency_cte f ON r.CustomerID = f.CustomerID
JOIN monetary_cte m ON r.CustomerID = m.CustomerID;

-- 11. RFM Scoring
WITH recency_cte AS (
    SELECT CustomerID, MAX(InvoiceDate) AS last_purchase
    FROM raw_transactions
    GROUP BY CustomerID
),
frequency_cte AS (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS frequency
    FROM raw_transactions
    GROUP BY CustomerID
),
monetary_cte AS (
    SELECT CustomerID, SUM(UnitPrice * Quantity) AS monetary
    FROM raw_transactions
    GROUP BY CustomerID
),
rfm_base AS (
    SELECT 
        r.CustomerID,
        DATEDIFF('2011-12-10', r.last_purchase) AS recency,
        f.frequency,
        m.monetary
    FROM recency_cte r
    JOIN frequency_cte f ON r.CustomerID = f.CustomerID
    JOIN monetary_cte m ON r.CustomerID = m.CustomerID
)

SELECT 
    CustomerID,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency ASC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS m_score,
    NTILE(5) OVER (ORDER BY recency ASC) + 
    NTILE(5) OVER (ORDER BY frequency DESC) + 
    NTILE(5) OVER (ORDER BY monetary DESC) AS rfm_score
FROM rfm_base;



 
