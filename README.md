# FraudInsightSQL

## Overview
FraudInsightSQL is a SQL-based fraud detection and transaction behavior analysis project focused on uncovering fraud patterns, customer risk factors, and business insights from financial transaction data.

The project combines SQL analysis with Power BI dashboards to support fraud investigation and data-driven decision-making.

---

## Objectives
- Analyze fraudulent transaction behavior
- Identify high-risk customers and transaction patterns
- Explore fraud distribution across categories, demographics, and locations
- Build reusable SQL views for reporting and dashboarding
- Visualize fraud insights using Power BI

---

## Dashboard Screenshots

### Fraud Overview Dashboard
![Fraud Overview](Images/fraud_overview.png)

### Fraud Risk Analysis Dashboard
![Fraud Risk Analysis](Images/fraud_risk_analysis.png)

---

## Key Insights

- The overall fraud rate in the dataset is relatively low compared to legitimate transactions.

- Fraud activity peaked during months 9 and 10, while month 12 showed the lowest fraud rate.

- The `shopping_net` category recorded the highest fraud rate among all transaction categories, followed by `misc_net` and `grocery_pos`.

- Certain states exhibited noticeably higher fraud activity, with Alaska showing the highest number of fraud cases.

- Fraud activity increased significantly during days 4 and 5 of the week.

- Specific customer groups and occupations demonstrated higher fraud exposure compared to others.

- A small number of customers and credit cards contributed disproportionately to fraudulent transaction amounts.

---

## Technologies Used
- SQL Server
- SQL
- Power BI

---

## Files
- FraudInsightSQL.sql → Main SQL analysis file
- Power BI Dashboard → Interactive fraud analysis dashboard

---

## Author
Mohammad Hadi Hayajneh
