-- Sales & Customer Analytics | MySQL
-- Database: sales
-- Note: sales_amount values include INR and USD transactions in the source.
-- Do not interpret raw cross-currency sums as consolidated revenue without
-- validating currency normalization/conversion first.

USE sales;

-- 1. Recorded sales amount by market code (raw sum; currency caveat applies)
SELECT
    market_code,
    SUM(sales_amount) AS recorded_sales_amount
FROM transactions
GROUP BY market_code
ORDER BY recorded_sales_amount DESC;

-- 2. Inspect market lookup values
SELECT *
FROM markets
LIMIT 10;

-- 3. Recorded sales amount by market name and zone
SELECT
    m.markets_name,
    m.zone,
    SUM(t.sales_amount) AS recorded_sales_amount
FROM transactions AS t
JOIN markets AS m
    ON t.market_code = m.markets_code
GROUP BY
    m.markets_name,
    m.zone
ORDER BY recorded_sales_amount DESC;

-- 4. Top 10 customers by recorded sales amount
SELECT
    c.customer_code,
    c.custmer_name,
    SUM(t.sales_amount) AS recorded_sales_amount
FROM transactions AS t
JOIN customers AS c
    ON t.customer_code = c.customer_code
GROUP BY
    c.customer_code,
    c.custmer_name
ORDER BY recorded_sales_amount DESC
LIMIT 10;

-- 5. Customer-type comparison
-- Amounts are raw sums and are not currency-normalized.
SELECT
    c.customer_type,
    COUNT(DISTINCT c.customer_code) AS customer_count,
    SUM(t.sales_amount) AS recorded_sales_amount
FROM transactions AS t
JOIN customers AS c
    ON t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY recorded_sales_amount DESC;

-- 6. Basic data-quality audit
SELECT
    COUNT(*) AS transaction_rows,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    SUM(sales_amount IS NULL) AS null_sales_amount_rows,
    SUM(sales_qty IS NULL) AS null_sales_qty_rows,
    SUM(sales_amount = 0) AS zero_sales_amount_rows,
    SUM(sales_amount < 0) AS negative_sales_amount_rows,
    SUM(sales_qty <= 0) AS nonpositive_sales_qty_rows
FROM transactions;

-- 7. Inspect currency values including hidden whitespace/carriage returns.
-- HEX() makes trailing control characters visible.
SELECT
    currency,
    HEX(currency) AS currency_hex,
    COUNT(*) AS row_count
FROM transactions
GROUP BY currency, HEX(currency)
ORDER BY row_count DESC;

-- 8. Count transactions by currency label (raw labels; inspect HEX output above)
SELECT
    TRIM(REPLACE(currency, CHAR(13), '')) AS normalized_currency_label,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY TRIM(REPLACE(currency, CHAR(13), ''))
ORDER BY transaction_count DESC;
