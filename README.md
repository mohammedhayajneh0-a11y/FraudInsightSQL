# FraudInsightSQL

## Overview
FraudInsightSQL is a SQL-based fraud detection and transaction behavior analysis project designed to uncover fraud patterns, customer risk factors, and business insights from financial transaction data.

The project combines SQL analytics with Power BI visualization to support fraud investigation and data-driven decision-making.

---

## Objectives
- Analyze fraudulent transaction behavior
- Identify high-risk customers and transaction patterns
- Explore fraud distribution across categories, demographics, and locations
- Build reusable SQL views for reporting and dashboarding
- Visualize fraud insights using Power BI

---

## Project Workflow

### 1. Data Understanding
- Transaction distribution analysis
- Fraud vs non-fraud comparison
- Category and demographic exploration
- Statistical summaries

### 2. Data Quality Validation
- Duplicate detection
- Missing value checks
- Invalid transaction validation
- Data consistency verification

### 3. Feature Engineering
- Date and time extraction
- Age calculation
- Transaction amount segmentation
- Customer-level aggregations

### 4. Exploratory Fraud Analysis
- Fraud trends by category
- Fraud by location and customer behavior
- Fraud analysis by gender and age
- High-risk transaction identification

### 5. Fraud Percentage Analysis
- Monthly fraud rates
- Fraud by weekday
- Fraud percentage by category
- Fraud amount analysis

---

## Dashboard Screenshots

### Fraud Overview Dashboard
![Fraud Overview](Images/dashboard_overview.png)

### Fraud Category Analysis
![Fraud Category Analysis](Images/category_analysis.png)

### Geographic Fraud Distribution
![Geographic Analysis](Images/geographic_analysis.png)

---

## Key Insights

- The overall fraud rate in the dataset is relatively low compared to legitimate transactions, indicating a highly imbalanced fraud detection problem.

- Fraud activity peaked during months 9 and 10, while month 12 showed the lowest fraud rate.

- The `shopping_net` category recorded the highest fraud rate among all transaction categories, followed by `misc_net` and `grocery_pos`.

- Certain states exhibited noticeably higher fraud activity, with Alaska showing the highest number of fraud cases in the analysis.

- Fraud activity increased significantly during days 4 and 5 of the week, suggesting potential temporal fraud patterns.

- Specific customer groups and occupations demonstrated higher fraud exposure compared to others.

- A small number of customers and credit cards contributed disproportionately to fraudulent transaction amounts, indicating concentrated fraud behavior.
---

## Technologies Used
- SQL Server
- Power BI
- T-SQL

---

## Project Structure

```text
FraudInsightSQL/
│
├── SQL/
│   └── fraud_analysis.sql
│
├── PowerBI/
│   └── FraudDashboard.pbix
│
├── Images/
│   ├── dashboard_overview.png
│   ├── category_analysis.png
│   └── geographic_analysis.png
│
└── README.md
