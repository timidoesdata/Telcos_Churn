# Customer Churn Pattern Analysis: Subscription-Based Business Models

## Introduction

Churn is almost inevitable, but understanding its patterns is where the real opportunity lies. For this project, I set out to explore the patterns and characteristics of customers who churn in a telecommunications company with a subscription-based model, with the goal of uncovering trends that could inform future strategies. The patterns uncovered here pave the way for future analyses aimed at tackling churn head-on.

The analysis follows a structured approach using **Python for data preprocessing**, **SQL for EDA & querying,** and **Power BI for visualization.**

## Dataset Used: 

The [Telco Customer Churn dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) contains 7,043 rows & 21 columns of customer information from a Telecom Company. 

**Key features include:**
- Customer Demographics
- Subscription Details
- Service Usage
- Churn Indicator

## Tools Used:
- Python
- Microsoft SQL
- Microsoft Power BI

## Data Cleaning & Prep

- First, I downloaded the dataset and loaded it as a Pandas DataFrame into Jupyter Notebooks.
```
import pandas as pd
file_path = "C:/Users/DELL/Downloads/archive (12)/Telcos_Churn.csv"
df = pd.read_csv(file_path)
df.head() #confirm loaded dataframe by checking first few rows
```
![image](https://github.com/user-attachments/assets/87c9ef83-9dee-46b4-8b02-13bf91f5b6fd)


- I wanted to understand the dataset structure before getting into the cleaning using;
```
df.shape
df.info()
```

- Some columns had the wrong datatype, so i had to fix:
```
# change seniorcitizen to obj, total charges to float
df["SeniorCitizen"] = df["SeniorCitizen"].astype(object)
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors= "coerce")
df.dtypes #confirm type change
```

- At first glance, there were no null values, but I proceeded to further check using since *TotalCharges* is now a float. There are 11 missing values in the *TotalCharges* column, but these can be determined using the formular *MonthlyCharges* * *tenure*. 

- Some variables with yes/no values can be changed to binary format for easier process later on 
```
# highlight the columns with yes/no values
yesno_cols = ["Partner", "Dependents", "PhoneService", "PaperlessBilling", "Churn"]
df[yesno_cols] = df[yesno_cols].apply(lambda x: x.map({"Yes": 1, "No": 0}))
df[yesno_cols].head()
```

- Saved the now clean dataset
```
df.to_csv("cleaned_Telcos_Churn.csv", index= False)
```

## Exploratory Data Analysis 

I explored the clean data to understand customer behaviour, identify trends and patterns. 

- First, I loaded my *cleaned_Telcos_Churn.csv* into Microsoft SQL, under my *TELCOS* database. Ensured the data loaded correctly by returning all the columns using the query below;
```
SELECT * FROM cleaned_Telcos_Churn
```

- How many customers stayed / churned?
```
SELECT Churn, COUNT(*) AS churn_count
FROM cleaned_Telcos_Churn
WHERE Churn = 1 OR Churn = 0
GROUP BY Churn
```
I createed a calculated column in Power BI using the "IF" function in DAX to assign the value "Churned" to 1, and "Stayed" to 0. 
![image](https://github.com/user-attachments/assets/42233e4c-8ff8-4db7-b04f-fa84fc3f25fc)

From the results of the above, **5,174** customers were retained, while the remaining **1,869** churned/left. Let us find the percentage churn, which we can do by either calculating *(number of churned customers / total number of customers) * 100* or simply writing the query below:
```
SELECT COUNT(CASE WHEN Churn = 1
	THEN 1 END) * 100 / COUNT(*) AS churn_rate 
FROM cleaned_Telcos_Churn
```
![image](https://github.com/user-attachments/assets/1607c1fe-4871-4f64-bce8-c6a2bffb0655)

- Churn by contract type
```
SELECT 
    Contract, 
    COUNT(CASE WHEN CHURN = 1 THEN 1 END) AS churn_count,
    (COUNT(CASE WHEN CHURN = 1 THEN 1 END) * 100.0) / SUM(COUNT(CASE WHEN CHURN = 1 THEN 1 END)) OVER() AS churn_rate
FROM cleaned_Telcos_Churn
GROUP BY Contract;
```
![image](https://github.com/user-attachments/assets/d0ef36f9-10a7-4f9c-9686-f6553fb69d76)

From the results above, a larger percentage of those who churned are *monthly* subscribers, while *2-year* subscribers churned the least. This could be explained by the fact that it is easier for monthly subscribers to opt out quicker when their payments expire. It also shows that monthly subscribers either testing the product or at their first time trial did not find enough value to return for. Behavioral analysis of user drop-off points will give more insights on user behavior. 

- Churn by payment method
```
SELECT 
	PaymentMethod, 
	COUNT(CASE WHEN Churn = 1 THEN 1 END) AS churn_count,
	(COUNT(CASE WHEN CHURN = 1 THEN 1 END) * 100.0) / SUM(COUNT(CASE WHEN CHURN = 1 THEN 1 END)) OVER() AS churn_rate
FROM cleaned_Telcos_Churn
GROUP BY PaymentMethod
ORDER BY churn_count DESC;
```
![image](https://github.com/user-attachments/assets/3147948b-6c6f-4bc8-b024-80fec3fe48cb)

From the results above, automatic payment methods (credit card & bank transfer) have the least churn rate, which could be explained by the speed and ease of their subscription through this method. Customers paying with electronic checks churn the highest, likely due to less financial stability and a slower payment process. 

- Churn by tenure category
Here, I categorized customers according to how many months they were suscribed before dropping the Telcos service.
I first determined the highest number of months spent (72) using:
```
SELECT DISTINCT tenure
FROM cleaned_Telcos_Churn
ORDER BY tenure DESC
```

Next, I classified the months into four sections *less than a year*, *1-2 years*, *2-4 years*, *4+ years*
```
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
```
![image](https://github.com/user-attachments/assets/76318cca-d875-42d6-b0d1-7bbd02ebee35)

- Customer acquistion vs. Churn over time
```
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
```
![image](https://github.com/user-attachments/assets/353250cb-af93-4a51-9c48-639a7dc1bb8f)

The first year saw the highest rate of customer acquisition, dropping year-on-year at an median of 18% until year 5, picking up at a rate of 46% by the 6th year. Churn also decreased, with year 6 seeing the least rate of customer drop-offs. 

- Customer Value vs. Perfect Value
```
SELECT 'revenue_at_total_retention' AS metric, SUM(MonthlyCharges) * 72 AS value
FROM cleaned_Telcos_Churn 
UNION ALL
SELECT 'revenue_at_half_retention' AS metric, SUM(MonthlyCharges) * 36 AS value 
FROM cleaned_Telcos_Churn
UNION ALL
SELECT 'actual_revenue' AS metric, SUM(TotalCharges) AS value 
FROM cleaned_Telcos_Churn
```
![image](https://github.com/user-attachments/assets/5b89b0d2-2938-41a5-ac43-942db9fd0b6d)

The above shows a long-term retention issue, as revenue realized is below 50% of projected revenue if all acquired customers were retained. It is also below the projected revenue if half the customers acquired over the 6-year period were retained. 

## DASHBOARD
**[View Dashboard](https://4h8nvq-my.sharepoint.com/:u:/g/personal/timi_4h8nvq_onmicrosoft_com/EbDvdDfp0bZPvFe3Ar4ykukBDmNg2Ivc5Z__Vyg0rNreww?e=bzdSuZ)**

![image](https://github.com/user-attachments/assets/846611a6-bb34-4507-893b-1e845ea6c4f6)

## INSIGHTS

- Within the first year of launch, more than half of the subscribers dropped off, however, churn rates dropped significantly between the second and sixth year, which might be an indication of updates or improvement based on initial feedback. 
Strengthening onboarding, offering incentives for early engagement, or creating better first-year experiences could be key to improving retention.

- Customers on month-to-month contracts were far more likely to leave, making up nearly 89% of all churned customers. On the other hand, customers who committed to one-year or two-year contracts were significantly more loyal. There is the potential of revisiting contract strategies to encourage longer stays.
Encouraging longer contracts or offering discounts for annual plans could be an effective way to reduce churn.

- If all customers had been retained, revenue could have reached 32.8 million. In reality, it only hit about 16.1 million, which is less than half of the potential. This signals that even though churn is about 26%, much more revenue is being lost or valuable customers are churning.
Understanding which customers contribute the most value and targeting them with retention strategies could significantly improve revenue, and reduce churn on high revenue generating customers.

- Although in general more customers appeared to use the *Electronic Check* payment method, this category churned more. This could be an indication that adopting / prioritizing easier payment methods increases chances of retention.
Encouraging more customers to switch to automated payments could be a subtle but effective way to handle churn.

## CONCLUSION

This analysis has uncovered patterns with the users and their relationship with this Telcos company, however more data would be required for a more indepth analysis towards a solution to significantly reduce churn. 

While available data is limited,collecting data from the customer service department will help inform what customers have complained about the most, or their feedback in general. This could help to inform subsequent updates and find out pain points that have yet to be addressed, leading to user drop-offs or a search for a better product. 

Data and collaboration from the product team would give more insight into user behaviour and how they interact with the service, helping to note at what point they struggled with the interface, any features or updates. 


