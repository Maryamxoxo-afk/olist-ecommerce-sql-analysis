# olist-ecommerce-sql-analysis
SQL analysis of 100K Olist e-commerce orders: revenue trends, top categories, delivery performance, and how late deliveries affect reviews.
# Olist E-commerce SQL Analysis

SQL analysis of about 100,000 orders from Olist, a Brazilian online marketplace (2016 to 2018). I used SQL to study revenue growth, top product categories, delivery performance, and how delivery affects customer reviews, then summarized the findings in an Excel report.

<img width="1369" height="506" alt="image" src="https://github.com/user-attachments/assets/b541ea56-843d-4f34-8501-7c2c4b93e89a" />




## Business problem
Where is this marketplace growing, and where is it losing customer satisfaction? Questions I answered:
1. How do orders and revenue change month by month?
2. Which product categories earn the most revenue?
3. How long does delivery take, and how often is it late?
4. Do late deliveries get lower review scores?
5. Which states have the slowest delivery?

## Dataset
- [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
- 8 related tables: orders, order items, payments, reviews, customers, products, sellers, and category translations
- 99,441 orders and 96,096 unique customers

## Tools
SQLite and DB Browser for SQLite (JOINs, GROUP BY, aggregations, CASE WHEN, HAVING, date functions), Excel for the report and charts

## Approach
1. Imported 8 CSV files into SQLite and renamed the tables
2. Checked row counts against the source data
3. Wrote one query per business question (see [`olist_queries.sql`](olist_queries.sql))
4. Exported the results to Excel and added charts
5. Wrote insights and recommendations

## Key insights
- **Growth:** monthly revenue grew from about $127.5K in January 2017 to roughly $1M a month through 2018, peaking at about $1.15M in November 2017.
- **Top categories:** health_beauty ($1.23M), watches_gifts ($1.17M), and bed_bath_table ($1.02M) lead revenue. bed_bath_table has the most orders (9,272) but ranks third, so its items are cheaper.
- **Delivery time:** orders take 12.6 days on average, and 8.1% (7,826 of 96,470) arrive after the estimated date.
- **Late deliveries hurt reviews:** late orders average a review score of **2.57**, against **4.29** for on-time orders, a gap of about 1.7 points.
- **Slowest states:** Amazonas (26.4 days), Alagoas (24.5), and Pará (23.8) take about twice as long as the overall average.

## Recommendations
- Improve logistics in the slowest states (AM, AL, PA), for example with closer fulfillment partners.
- Set more realistic delivery estimates in slow regions, so fewer orders count as late.
- Contact customers with delayed orders early, since lateness is linked to much lower review scores.
- Keep investing in the top revenue categories (health_beauty, watches_gifts, bed_bath_table).

## Limitations
- Revenue in table 1 uses payment value (which includes shipping), while table 2 uses item price only, so the two aren't directly comparable.
- Only delivered orders are included.
- Some months in late 2016 have little or no data.
- The late vs review result shows a strong link, not proof that lateness alone causes low scores.

