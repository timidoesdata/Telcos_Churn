# Customer Churn Analysis: Subscription-Based Business Models

## Introduction

Customer retention is a key metric for any subscription-based business, and understanding why customers leave is crucial to long-term profitability. 
In this project, I analyzed customer churn in the telecom industry using [data from Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn).

The objective is to **identify key factors influencing churn, extract actionable insights,** and **build a predictive model** to help businesses reduce customer attrition. The analysis follows a structured approach using **Python for data preprocessing,** **SQL for querying,** and **Power BI for visualization.**

## Dataset Used: 

The [Telco Customer Churn dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) contains 7,043 rows & 21 columns of customer information from a Telecom Company. The dataset is publicly available on [Kaggle.](https://www.kaggle.com/datasets/) <br>

**Key features include:**
- Customer Demographics
- Subscription Details
- Service Usage
- Churn Indicator

## Tools Used:
- Python
- Microsoft SQL
- Microsoft Power BI
- Scikit Learn

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
Some columns had the wrong datatype, so i had to fix:
```
# change seniorcitizen to obj, total charges to float
df["SeniorCitizen"] = df["SeniorCitizen"].astype(object)
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors= "coerce")
df.dtypes #confirm type change
```
At first glance, there were no null values, but I proceeded to further check using since *TotalCharges* is now a float;
```
df.isnull().sum()
```








