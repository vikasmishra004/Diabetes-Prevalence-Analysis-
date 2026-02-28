# Diabetes Prevalence Analysis

## Overview
This project examines age-specific prevalence and socio-demographic determinants of prediabetes and diabetes among women aged 15–49 years using nationally representative survey data. The study situates metabolic risk within a demographic framework, emphasizing structural and socioeconomic differentials in health outcomes.

## Outcome Variable
- Diabetes status (prediabetes / diabetes)

## Explanatory Variables
- Age (five-year age groups: 15–19 to 45–49)
- Body Mass Index (BMI)
- Educational attainment
- Household wealth index
- Place of residence (urban/rural)
- Social group (caste categories)
- Religion

## Methods
- Estimation of age-specific prevalence rates  
- Cross-tabulation and percentage distribution  
- Multivariate logistic regression modelling  
- Assessment of demographic and socioeconomic gradients in metabolic risk  
- Statistical analysis conducted using Stata  

## Repository Structure
- `code/analysis.do` → Main Stata analysis script  
- `.gitignore` → Excludes raw data and temporary files  

## Data Note
Raw survey data are not included due to usage restrictions. The repository contains only reproducible analysis code.Users must place Data1.dta and Data2.dta in the working directory before running the script.
