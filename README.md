# SQL-swiggy-analysis
the project explores various findings of swiggy data set
This project delivers a comprehensive business intelligence analysis of order patterns, customer behavior, and sales growth on the Swiggy platform. Utilizing a 6-table star schema running locally on PostgreSQL, this analysis moves beyond raw transactional tracking to compute high-impact business metrics such as Month-over-Month (MoM) Growth, Average Order Value (AOV), Units Per Transaction (UPT), and Customer Retention Velocity.
The primary objective is to demonstrate production-grade SQL practices—leveraging Common Table Expressions (CTEs), dynamic window functions (LAG, RANK, ROW_NUMBER), and modular query architectures without relying on hardcoded date filters or redundant nested logic.

The analytical dataset is structured around a classic 6-table relational star schema optimized for fast analytical querying and BI dashboard consumption:

sales (Fact Table): Granular transactional records including order keys, customer IDs, product IDs, store/restaurant IDs, order dates, and monetary amounts.

customer (Dimension): Demographics, location attributes, and registration metadata.

products (Dimension): Item catalog, categories, subcategories, and pricing structures.

stores (Dimension): Restaurant and cloud-kitchen outlet locations, fulfillment types, and operational regions.

dates (Dimension): Comprehensive time-intelligence dimension supporting daily, weekly, monthly, and fiscal year aggregation.
