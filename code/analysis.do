*******************************************************
* Diabetes Prevalence Analysis
* Age-Specific Patterns and Determinants
* Author: Vikas Kumar Mishra
*******************************************************

clear all
set more off
set maxvar 20000

*------------------------------------------------------*
* 1. Load and Merge Data
*------------------------------------------------------*

use "Data1.dta", clear
rename hv001 v001
rename hv002 v002
save "Data1_hh.dta", replace

use "Data2.dta", clear
merge m:1 v001 v002 using "Data1_hh.dta"
keep if _merge == 3
drop _merge

*------------------------------------------------------*
* 2. Weight Variable
*------------------------------------------------------*

gen wgt = v005/1000000
label var wgt "Adjusted sampling weight"

svyset v001 [pw=wgt]

*------------------------------------------------------*
* 3. Clean Glucose Variable
*------------------------------------------------------*

gen glucose = sb74
replace glucose = . if glucose >= 995
label var glucose "Blood Glucose Level (mg/dL)"

*------------------------------------------------------*
* 4. Descriptive Analysis (Mean Glucose)
*------------------------------------------------------*

svy: mean glucose, over(v025)    // Residence
svy: mean glucose, over(bmi_o)   // BMI
svy: mean glucose, over(v013)    // Age
svy: mean glucose, over(v106)    // Education
svy: mean glucose, over(caste)   // Caste
svy: mean glucose, over(religion)// Religion
svy: mean glucose, over(hv219)   // Sex of HH
svy: mean glucose, over(hv270)   // Wealth

*------------------------------------------------------*
* 5. Construct Glycaemic Status
*------------------------------------------------------*

gen fast = .
replace fast = 1 if sb54 >= 8 & sb54 < .
replace fast = 0 if sb54 < 8

gen gly_status = .

replace gly_status = 0 if fast==1 & glucose < 100
replace gly_status = 1 if fast==1 & glucose>=100 & glucose<=125
replace gly_status = 2 if fast==1 & glucose>=126

replace gly_status = 0 if fast==0 & glucose <140
replace gly_status = 1 if fast==0 & glucose>=140 & glucose<=199
replace gly_status = 2 if fast==0 & glucose>=200

label define gly_lbl 0 "Normal" 1 "Prediabetic" 2 "Diabetic"
label values gly_status gly_lbl
label var gly_status "Glycaemic Status"

*------------------------------------------------------*
* 6. Weighted Prevalence
*------------------------------------------------------*

svy: tab gly_status, percent

svy: tab gly_status v025, column percent
svy: tab gly_status bmi_o, column percent
svy: tab gly_status v013, column percent
svy: tab gly_status v106, column percent
svy: tab gly_status caste, column percent
svy: tab gly_status religion, column percent
svy: tab gly_status hv219, column percent
svy: tab gly_status hv270, column percent

*------------------------------------------------------*
* 7. Age-Specific Prevalence (Women 15–49)
*------------------------------------------------------*

gen prediab = (gly_status == 1)
gen diab    = (gly_status == 2)

svy: mean prediab, over(v013)
svy: mean diab, over(v013)

gen prediab_pct = prediab*100
gen diab_pct    = diab*100

graph bar (mean) prediab_pct diab_pct, ///
    over(v013, label(angle(45))) ///
    legend(label(1 "Prediabetes") label(2 "Diabetes")) ///
    ytitle("Women (%)") ///
    title("Age-wise Percentage of Women with Prediabetes and Diabetes") ///
    subtitle("Women aged 15–49 years")

*------------------------------------------------------*
* 8. Multivariate Analysis
*------------------------------------------------------*

svy: ologit gly_status i.v013 i.bmi_o i.v025 i.hv270, or

*******************************************************
* End of Analysis
*******************************************************













