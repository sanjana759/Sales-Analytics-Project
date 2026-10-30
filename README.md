# Sales & Customer Analytics | SQL + Power BI

## Project overview
This project explores a retail sales dataset using MySQL and Power BI. The goal is to answer practical business questions about recorded sales by market, customer, and customer type, and to present the results in a dashboard.

> **Dataset and interpretation note:** This is a portfolio analysis of a tutorial-style Sales Insights dataset. The source contains both INR and USD currency labels, including values with trailing carriage-return characters. Therefore, raw `SUM(sales_amount)` values across the full dataset must **not** be described as comparable consolidated revenue until currency normalization/conversion is validated. Findings below are described as *recorded sales amounts* rather than verified financial revenue.

## Tools
- MySQL — joins, aggregation, grouping, sorting, data-quality checks
- Power BI — dashboarding and interactive visual analysis
- Power Query / DAX — use only for transformations and measures actually present in the supplied PBIX

## Business questions
1. Which markets have the largest recorded sales amounts?
2. What are the top customers by recorded sales amount?
3. How do Brick & Mortar and E-Commerce customer types compare?
4. What data-quality checks should be completed before interpreting the totals?

## SQL analysis included
The `sql/sales_analysis.sql` script includes:
- Recorded sales amount by market code
- Market name and zone lookup with a `JOIN`
- Top 10 customers by recorded sales amount
- Customer-type comparison using distinct customer counts
- Basic dataset quality checks for row counts, date range, nulls, non-positive values, and currency formatting

## Key findings from the analysis
- The transactions table contains **150,283 rows**.
- Recorded order dates span **2017-10-04 to 2020-06-26**.
- No `NULL` values were found in `sales_amount` or `sales_qty` in the audit performed.
- The customer-type aggregation showed 19 distinct customers in each of the two types: Brick & Mortar and E-Commerce.
- Before currency normalization, the recorded sales amount by customer type was 746,198,243 for Brick & Mortar and 240,367,523 for E-Commerce. These are raw sums, not currency-normalized totals, and should not be interpreted as a fair financial comparison.
- The market/customer ranking queries return raw recorded amounts. Currency consistency must be resolved before making cross-currency performance claims.

## Data-quality limitations
- Currency values contain both INR and USD, and some values have a trailing carriage-return character. This can cause exact string filters and groupings to split what appears to be the same currency.
- Currency conversion logic should be validated against a documented exchange-rate assumption before calculating consolidated revenue.
- Two transactions have a sales amount of `-1`; these were not deleted because there was insufficient evidence to classify them as duplicates or errors.
- A zero sales amount appears in the data. Zero-value rows were retained rather than silently removed.

## Repository structure
```text
Sales-Analytics-Project/
├── README.md
├── sql/
│   └── sales_analysis.sql
└── dashboard/
    └── ADD_DASHBOARD_SCREENSHOT_HERE.md
```

## How to run
1. Import the provided `db_dump.sql` into a local MySQL instance and select the `sales` database.
2. Open `sql/sales_analysis.sql` in MySQL Workbench.
3. Run the sections individually and review the results.
4. Open the Power BI `.pbix` file locally to explore the dashboard.

The database dump and `.pbix` are intentionally not bundled here. Add them only if you have permission to redistribute the dataset/report. A screenshot of the dashboard can be placed in the `dashboard/` folder for public viewing.

## Next improvements
- Standardize currency strings and document the normalization logic.
- Validate exchange-rate conversion before comparing currency totals.
- Add a time-series analysis by year/month after confirming date-table relationships.
- Add a dashboard screenshot and a short explanation of the report's KPIs and filters.

## Project status
Portfolio draft prepared. The SQL analysis and findings are documented; add the dashboard screenshot and verify currency treatment before publishing financial comparisons as definitive conclusions.
