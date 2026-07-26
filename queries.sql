-- ==============================================================================
-- Enterprise Churn & MRR Exposure Analysis - Complete SQL Workflow
-- Platform: Google BigQuery
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- STEP 1: Data Exploration & Validation
-- Purpose: Inspecting raw table structure and total churn counts.
-- ------------------------------------------------------------------------------
-- 
SELECT 
  COUNT(customerID) AS total_customers,
  SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS churn_rate_pct,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN MonthlyCharges ELSE 0 END), 2) AS lost_monthly_mrr
FROM `protean-mind-466016-s3.customer_analytics.telco_churn`;

-- ------------------------------------------------------------------------------
-- STEP 2: Revenue & MRR Aggregations
-- Purpose: Calculating total MRR lost across customer segments.
-- ------------------------------------------------------------------------------
-- 
WITH Customer_Risk_Profile AS (
  SELECT 
    customerID,
    tenure,
    Contract,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn,
    -- Custom Financial Risk Logic
    CASE 
      WHEN MonthlyCharges >= 80 AND tenure <= 12 THEN 'High Financial Risk'
      WHEN MonthlyCharges >= 50 AND tenure <= 24 THEN 'Medium Financial Risk'
      ELSE 'Low Financial Risk'
    END AS risk_category
  FROM `protean-mind-466016-s3.customer_analytics.telco_churn`
)

SELECT 
  risk_category,
  COUNT(customerID) AS total_customers,
  SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS churn_rate_pct,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN MonthlyCharges ELSE 0 END), 2) AS monthly_mrr_lost,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN MonthlyCharges ELSE 0 END) * 12, 2) AS annualized_revenue_impact
FROM Customer_Risk_Profile
GROUP BY risk_category
ORDER BY monthly_mrr_lost DESC;

-- ------------------------------------------------------------------------------
-- STEP 3: Contract & Payment Channel Analysis
-- Purpose: Segmenting churn rate percentages by contract and payment type.
-- ------------------------------------------------------------------------------
-- 
SELECT 
  Contract,
  PaymentMethod,
  COUNT(customerID) AS customer_count,
  SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) AS churned_count,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS churn_rate_pct,
  ROUND(SUM(CASE WHEN Churn IS TRUE THEN MonthlyCharges ELSE 0 END), 2) AS mrr_lost
FROM `protean-mind-466016-s3.customer_analytics.telco_churn`
GROUP BY Contract, PaymentMethod
ORDER BY mrr_lost DESC;

-- ------------------------------------------------------------------------------
-- STEP 4: High-Value Churned Customer Ranking
-- Purpose: Ranking accounts by monthly charges using window functions.
-- ------------------------------------------------------------------------------
-- 
WITH Ranked_Churners AS (
  SELECT 
    customerID,
    Contract,
    PaymentMethod,
    tenure,
    MonthlyCharges,
    TotalCharges,
    RANK() OVER (
      PARTITION BY Contract 
      ORDER BY TotalCharges DESC
    ) AS spend_rank_in_contract
  FROM `protean-mind-466016-s3.customer_analytics.telco_churn`
  WHERE Churn IS TRUE
)

SELECT * 
FROM Ranked_Churners
WHERE spend_rank_in_contract <= 5
ORDER BY Contract, spend_rank_in_contract ASC;

-- ------------------------------------------------------------------------------
-- STEP 5: Final Integrated Churn Risk Model (Fed directly into Power BI)
-- Purpose: Combining all metrics and risk tiers into a consolidated view.
-- ------------------------------------------------------------------------------
-- 
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn,
    IF(Churn IS TRUE, 1, 0) AS is_churned,
    IF(Churn IS TRUE, MonthlyCharges, 0) AS mrr_lost,
    CASE 
        WHEN MonthlyCharges >= 75 AND Contract = 'Month-to-month' THEN 'High Financial Risk'
        WHEN MonthlyCharges >= 45 AND Contract = 'Month-to-month' THEN 'Medium Financial Risk'
        WHEN MonthlyCharges >= 75 THEN 'Medium Financial Risk'
        ELSE 'Low Financial Risk'
    END AS risk_category
FROM `protean-mind-466016-s3.customer_analytics.telco_churn`
