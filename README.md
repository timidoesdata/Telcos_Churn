# Customer Churn Analysis: Subscription-Based Business Models

## Introduction

Customer retention is a key metric for any subscription-based business, and understanding why customers leave is crucial to long-term profitability. 
In this project, I analyzed customer churn in the telecom industry using [data from Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn).

The objective is to **identify key factors influencing churn, and extract actionable insights** to help this business reduce customer attrition. The analysis follows a structured approach using **Python for data preprocessing** & **EDA** **SQL for querying,** and **Power BI for visualization.**

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









