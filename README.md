# 📊 Customer Churn & MRR Risk Analytics Dashboard


> A data analytics project built using **Google BigQuery (SQL)** and **Power BI** to analyze customer churn, measure lost Monthly Recurring Revenue (MRR), and identify high-risk subscriber segments.

---

## 📸 Executive Dashboard Preview

[Customer Churn & Revenue Risk Dashboard]

---

## 📈 Key Metrics & Business Impact (By the Numbers)

### 💼 Business Loss & Risk Exposure
* **$139.13K Total Lost MRR:** Evaluated across **2,000 churned accounts** out of a **7,043 total customer base**.
* **26.54% Overall Churn Rate:** Measured and isolated across customer contract and payment cohorts.
* **$84K Financial Risk Concentration:** Proved that **60.4% of all lost revenue** came directly from the **High Financial Risk segment** ($\ge \$80$/month on month-to-month plans).
* **>50% Peak Segment Churn:** Uncovered that Month-to-Month subscribers paying via **Electronic Check** churned at **more than double** the baseline rate.

### 🛠️ Data Pipeline & Technical Complexity
* **7,000+ Raw Rows Processed:** Transformed and queried efficiently in **Google BigQuery**.
* **3 Custom SQL Logic Fields:** Engineered binary status flags (`is_churned`), row-level lost revenue (`mrr_lost`), and a 3-tier financial risk classification system.
* **4 Core DAX Measures:** Developed custom metrics for dynamic churn percentage, total MRR loss, account counts, and automated DAX dynamic narrative text.
* **2 Interactive Slicers & 4 Visual Cards:** Integrated full cross-filtering capabilities across contract types, payment methods, and risk levels.

---

## 📌 Project Overview & Why I Built This

When analyzing churn, looking at customer counts alone (*e.g., "we lost 26% of our users"*) misses critical financial context. A customer paying **$20/month** leaving has a vastly different impact than a high-value account paying **$110/month** leaving.

The goal of this project was to shift from simple volume-based churn tracking to a **revenue-first analytics approach**. By combining customer spend with contract types and payment channels, this project answers:
1. **Revenue Impact:** Exactly how much Monthly Recurring Revenue (MRR) is being lost?
2. **Cohort Drivers:** Which specific customer cohorts drive the majority of that financial loss?
3. **Actionable Outreach:** How can Customer Success teams prioritize outreach to high-spend accounts before they churn?

---

## 🔍 Analytical Approach & Execution

### 1. Finding the Signal in the Data (BigQuery SQL)
Before building visuals, I ran exploratory SQL queries in BigQuery to analyze raw subscriber trends. Three patterns emerged:
* **Contract Type:** Month-to-month subscribers churned at significantly higher rates than 1-year and 2-year contract holders.
* **Payment Method:** Electronic check users exhibited disproportionately high churn compared to automated credit card/bank transfer users.
* **Spend Exposure:** High-paying users on flexible contracts represented the largest revenue leakage.

To prepare the dataset efficiently and keep Power BI fast, I wrote custom SQL transformations:
* Engineered binary flags for churned status (`is_churned`).
* Isolated row-level revenue loss (`mrr_lost`).
* Constructed a `CASE` statement bucketing users into **High ($\ge \$80$/mo)**, **Medium ($40–$79/mo)**, and **Low ($<\$40$/mo)** Financial Risk tiers.

### 2. Dashboard Design & UX (Power BI)
I structured the dashboard layout using an executive visual hierarchy:
* **Top KPI Header:** Instant top-line visibility into **$139.13K Total MRR Lost**, **26.54% Churn Rate**, and **2K Churned Customers**.
* **Middle Section:** Visual comparison charts comparing churn rates across contract types, payment channels, and financial risk tiers.
* **Bottom Section:** A detailed, filterable Top 10 customer table displaying Customer IDs, contract types, monthly charges, and tenure so account management teams can execute targeted outreach.

---

## 💡 Strategic Recommendations for Retention

1. **Incentivize Auto-Pay Migration:** Implement a small monthly incentive (e.g., $5/mo discount) to switch Month-to-Month Electronic Check users to automated Credit Card or Bank Transfer payment methods.
2. **Targeted Contract Upgrades:** Prioritize outreach to Month-to-Month accounts paying $\ge \$80$/month, offering discounted 12-month upgrades before their peak churn tenure window.

---

## 🛠️ Tech Stack & Tools

* **Database / SQL:** Google BigQuery (*CTEs, conditional logic, feature engineering*)
* **Business Intelligence:** Power BI Desktop (*Data modeling, DAX measures, UX design*)
* **Version Control:** Git & GitHub

## 📁 Repository Contents

* `queries.sql` — Complete SQL script containing exploratory queries and the final data model.
* `BigQuery_PowerBI_Customer_Retention_Analytics.pbix` — Power BI desktop report file.
* `README.md` — Project documentation.
* `Images` — `dashboard_preview.png` — High-resolution dashboard screenshot
