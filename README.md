# SQL Layoffs Analysis

Data cleaning and exploratory analysis of a global layoffs dataset using SQL.  
This project demonstrates how raw datasets can be transformed into cleaner, more reliable data and then explored for meaningful business insights.

## Project Overview

The dataset contains global records of company layoffs between 2020 and 2023.  
The project was divided into two stages:

1. **Data Cleaning** – Removing duplicates, standardising values, handling nulls, and preparing the dataset for analysis.  
2. **Exploratory Analysis** – Using SQL queries to find patterns and insights, such as layoff trends by year, industry, and country.

This project also introduced me to **more advanced SQL techniques** like **window functions**. At the time, I found these concepts challenging to grasp (and still do in some cases), but working through them helped me build a stronger foundation and I am continuing to make an effort to wrap my head around them fully.

## Process

### Data Cleaning
- Removed duplicate records using `ROW_NUMBER()` with window functions.  
- Standardised inconsistent entries (e.g., trimming spaces, unifying country names, and industry labels).  
- Converted date formats into a usable `DATE` datatype.  
- Handled null and blank values by correcting, filling, or removing where appropriate.  
- Removed unnecessary staging columns after processing.

### Exploratory Analysis
- Analysed layoffs over time (by year, month, and cumulative rolling totals).  
- Ranked companies by total layoffs and by year using **window functions** (`DENSE_RANK`).  
- Identified industries and countries most affected.  
- Examined company shutdowns (100% layoffs).  
- Discovered 2022 had the highest layoffs, with the U.S being the most impacted country.

## Key Insights

- **2022 Peak** – 2022 recorded the most layoffs overall, with early 2023 numbers suggesting an even higher trend.  
- **Industries Hit Hardest** – Consumer and Retail industries saw the largest layoffs.  
- **Countries** – The United States had the most layoffs by far.  
- **Top Companies** – Certain high-profile companies (e.g., in Tech & Crypto) had complete shutdowns despite significant funding.  
- **Window Functions** – Used to rank the top 5 companies per year with the highest layoffs.  

## Lessons Learned

- How to approach real-world messy datasets with a structured cleaning workflow.  
- The importance of standardising and validating before analysis.  
- First experience applying **window functions** (`ROW_NUMBER`, `DENSE_RANK`) -- still a challenging area, but this project gave me valuable hands-on practice.  
