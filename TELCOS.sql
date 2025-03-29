SELECT * FROM cleaned_Telcos_Churn;

SELECT DISTINCT InternetService FROM cleaned_Telcos_Churn

SELECT COUNT(*) AS no_of_customers FROM cleaned_Telcos_Churn;

---1. How many customers churned or stayed?
SELECT Churn, COUNT(*) AS churn_count
FROM cleaned_Telcos_Churn
WHERE Churn = 1 OR Churn = 0
GROUP BY Churn
ORDER BY churn_count ASC;

---2. What is the churn rate in %?
SELECT COUNT(CASE WHEN Churn = 1
	THEN 1 END) * 100 / COUNT(*) AS churn_rate 
FROM cleaned_Telcos_Churn;

---3. Churn by contract type
SELECT 
    Contract, 
    COUNT(CASE WHEN CHURN = 1 THEN 1 END) AS churn_count,
    (COUNT(CASE WHEN CHURN = 1 THEN 1 END) * 100.0) / SUM(COUNT(CASE WHEN CHURN = 1 THEN 1 END)) OVER() AS churn_rate
FROM cleaned_Telcos_Churn
GROUP BY Contract;

---4. Churn by payment method
SELECT 
	PaymentMethod, 
	COUNT(CASE WHEN Churn = 1 THEN 1 END) AS churn_count,
	(COUNT(CASE WHEN CHURN = 1 THEN 1 END) * 100.0) / SUM(COUNT(CASE WHEN CHURN = 1 THEN 1 END)) OVER() AS churn_rate
FROM cleaned_Telcos_Churn
GROUP BY PaymentMethod
ORDER BY churn_count DESC;

SELECT DISTINCT tenure FROM cleaned_Telcos_Churn
ORDER BY tenure DESC

---5. Churn by Tenure
SELECT 
	CASE 
	WHEN tenure <= 12 THEN '0-1 year'
	WHEN tenure <= 24 THEN '1-2 years'
	WHEN tenure <= 48 THEN '2-4 years'
	ELSE '4+ years'
	END AS tenure_category,
COUNT(CASE WHEN Churn = 1 THEN 1 END) AS churn_count,
(COUNT(CASE WHEN CHURN = 1 THEN 1 END) * 100.0) / SUM(COUNT(CASE WHEN CHURN = 1 THEN 1 END)) OVER() AS churn_rate
FROM cleaned_Telcos_Churn
GROUP BY 
	CASE 
	WHEN tenure <= 12 THEN '0-1 year'
	WHEN tenure <= 24 THEN '1-2 years'
	WHEN tenure <= 48 THEN '2-4 years'
	ELSE '4+ years'
	END
ORDER BY tenure_category ASC

---6. Revenue made from churned customers 
SELECT Churn, SUM(TotalCharges) AS Revenue
FROM cleaned_Telcos_Churn
GROUP BY Churn

---7. Acquisition vs. Survival 
SELECT 
    CASE 
	WHEN tenure <= 12 THEN '1st year'
	WHEN tenure <= 24 THEN '2nd year'
	WHEN tenure <= 36 THEN '3rd year'
	WHEN tenure <= 48 THEN '4th year'
	WHEN tenure <= 60 THEN '5th year'
	ELSE '6th year'
	END AS tenure_category,
    COUNT(CustomerID) AS Customers_At_Start,
    COUNT(CASE WHEN Churn = 1 THEN 1 END) AS Churned_Customers
FROM cleaned_Telcos_Churn
GROUP BY CASE  
	WHEN tenure <= 12 THEN '1st year'
	WHEN tenure <= 24 THEN '2nd year'
	WHEN tenure <= 36 THEN '3rd year'
	WHEN tenure <= 48 THEN '4th year'
	WHEN tenure <= 60 THEN '5th year'
	ELSE '6th year'
	END
ORDER BY tenure_category

---8. 
SELECT 'revenue_at_total_retention' AS metric, SUM(MonthlyCharges) * 72 AS value
FROM cleaned_Telcos_Churn
UNION ALL
SELECT 'revenue_at_half_retention' AS metric, SUM(MonthlyCharges) * 36 AS value
FROM cleaned_Telcos_Churn
UNION ALL
SELECT 'actual_revenue' AS metric, SUM(TotalCharges) AS value
FROM cleaned_Telcos_Churn;

SELECT PaymentMethod, COUNT(customerID) 
FROM cleaned_Telcos_Churn
---WHERE SeniorCitizen = 1
GROUP BY PaymentMethod