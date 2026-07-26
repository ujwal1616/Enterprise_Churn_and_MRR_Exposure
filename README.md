# Customer Churn & MRR Risk Analysis

A data analytics project built using **Google BigQuery** and **Power BI** to analyze customer churn, measure lost Monthly Recurring Revenue (MRR), and identify high-risk subscriber segments.

---

## 📌 Project Overview & Why I Built This

When analyzing churn, looking at customer counts alone (e.g., "we lost 26% of our users") doesn't give the full picture. A customer paying $20/month leaving is very different from a customer paying $110/month leaving. 

The goal of this project was to shift from simple volume-based churn tracking to a **revenue-first approach**. By combining customer spend with contract types, I wanted to figure out:
1. Exactly how much monthly recurring revenue (MRR) we are losing.
2. Which specific customer cohorts are driving the majority of that financial loss.
3. How customer success teams can target high-spend accounts before they churn.

---

## 🔍 How I Approached the Problem

### 1. Finding the Signal in the Data (BigQuery)
Before building visuals, I ran exploratory SQL queries in BigQuery to understand the raw data. A few key patterns popped up quickly:
* **Contract Type:** Month-to-month subscribers churned at a significantly higher rate than long-term contract holders.
* **Payment Method:** Electronic check users had disproportionately high churn rates compared to automated credit card/bank transfer users.
* **Spend Impact:** High-paying users on flexible contracts represented our biggest financial exposure.

To prepare the dataset for reporting without slowing down Power BI, I wrote custom SQL transformations to pre-calculate key metrics:
* Created binary flags for churned status (`is_churned`).
* Isolated row-level revenue loss (`mrr_lost`).
* Built a custom `CASE` statement to bucket users into **High, Medium, and Low Financial Risk** tiers.

### 2. Dashboard Design (Power BI)
I structured the dashboard layout using a simple top-to-bottom hierarchy:
* **Header / KPIs:** Quick top-line summary for leadership (Total Lost MRR, Overall Churn %, Churned Customer Count).
* **Middle Section:** Visual breakdowns comparing churn rates across contract types, payment methods, and risk tiers.
* **Bottom Section:** A detailed, filterable table listing customer IDs, contract info, and monthly spend so team members can take direct action on specific accounts.

---

## 💡 Key Takeaways & Findings

* **Concentrated Revenue Loss:** A massive portion of total lost MRR is tied up in the **High Financial Risk** segment (high monthly charges + month-to-month contracts).
* **Payment Friction:** Month-to-month customers paying via Electronic Check showed churn rates over 50%, pointing to potential billing friction or onboarding drop-off.
* **Targeted Retention:** Because high-spend accounts make up a disproportionate amount of lost revenue, retention campaigns should focus heavily on converting high-charge month-to-month users into 1- or 2-year plans.

---

## 🛠️ Tools Used

* **Database / SQL:** Google BigQuery (CTEs, conditional logic, risk modeling)
* **Visualization:** Power BI Desktop (Data modeling, interactive cross-filtering, report layout)
* **Version Control:** Git & GitHub

---

## 📁 Repository Contents

* `queries.sql` — Complete SQL script containing exploratory queries and the final data model.
* `BigQuery_PowerBI_Customer_Retention_Analytics.pbix` — Power BI desktop report file.
* `README.md` — Project documentation.
