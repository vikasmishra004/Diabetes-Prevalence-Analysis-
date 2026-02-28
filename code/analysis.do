clear all
set more off
set maxvar 20000

cd "C:\Users\Vikas\Desktop\Stata Assignment"

**| Que 1
log using Que1_ans.log, replace


use "Data1.dta"

rename hv001 v001
rename hv002 v002

save Data1_hh.dta, replace

use Data2.dta, clear

merge m:1 v001 v002 using Data1_hh.dta
keep if _merge == 3
drop _merge

gen wgt = v005/1000000
label var wgt "Adjusted Weight"

describe sb74
tab sb74
tab sb74, nolabel

gen glucose = sb74
label var glucose "Clean Glucose Level"
replace glucose = . if glucose >=995
mean glucose [iw=wgt]

tab v025
sort v025

by v025: summ glucose
ttest glucose, by(v025)


svyset v001 [pw=wgt]

* Place of Residence
svy: mean glucose, over(v025)

* BMI
svy: mean glucose, over(bmi_o)

*Age
svy: mean glucose, over(v013)

*Education
svy: mean glucose, over(v106)

*Caste
svy: mean glucose, over(caste)

*Religion
svy: mean glucose, over(religion)

*Sex of HH
svy: mean glucose, over(hv219)
tab hv219

*Wealth Index
svy: mean glucose, over(hv270)

log close

**| Que 2

log using Que2_ans.log, replace
use Data2.dta, clear

gen fast = .
replace fast = 1 if sb54 >= 8 & sb54 < .
replace fast = 0 if sb54 < 8

label define fastlbl 1 "Fasted for 8 hours or more" 0 "Not fasted"
label values fast fastlbl
label var fast "Fasting Status"

tab fast, missing

gen gly_status = .

replace gly_status = 0 if fast==1 & glucose < 100
replace gly_status = 1 if fast==1 & glucose>=100 & glucose<=125
replace gly_status = 2 if fast==1 & glucose >=126

replace gly_status = 0 if fast==0 & glucose <140
replace gly_status = 1 if fast==0 & glucose>=140 & glucose<=199
replace gly_status = 2 if fast==0 & glucose >=200

label define gly_lbl 0 "Normal" 1 "Prediabetic" 2 "Diabetic"
label values gly_status gly_lbl
label var gly_status "Glycaemic Status"

svyset v001[pw=wgt]
svy: tab gly_status, percent


*Place of Residence
svy: tab gly_status v025, column percent

*BMI
svy: tab gly_status bmi_o, column percent

*Age
svy: tab gly_status v013, column percent

*Education
svy: tab gly_status v106, column percent

*Caste
svy: tab gly_status caste, column percent cellwidth(15)

*Religion
svy: tab gly_status religion, column percent

*Sex of HH
svy: tab gly_status hv219, column percent

*Wealth Index
svy: tab gly_status hv270, column percent

log close

**| Que 3

log using Que3_ans.log, replace
use Data2.dta, clear

svyset v001 [pw=wgt]

svy: tab gly_status v013, column percent

gen prediab = (gly_status == 1)
label define prelbl 0 "Not prediabetic" 1 "Prediabetic"
label values prediab prelbl
label var prediab "Prediabetes"

gen diab = (gly_status == 2)
label define diablbl 0 "Not diabetic" 1 "Diabetic"
label values diab diablbl
label var diab "Diabetes"

tab prediab
tab diab

svy: mean prediab, over(v013)
svy: mean diab, over(v013)

gen prediab_pct = prediab*100
label var prediab_pct "Percentage Prediabetic"
gen diab_pct = diab*100
label var diab_pct "Percentage Diabetic"

graph bar (mean) prediab_pct diab_pct, over(v013, label(angle(45) labsize(small))) legend(label(1 "Prediabetes") label(2 "Diabetes") size(small)) ytitle("Women (%)", margin(medium)) title("Age-wise Percentage of Women with Prediabetes and Diabetes", size(small)) subtitle("Women aged 15–49 years", size(vsmall))

log close


**| Que 4

log using Que4_ans.log, replace
use Data2.dta, clear

svyset v001 [pw=wgt]
svy: ologit gly_status i.v013 i.bmi_o i.v025 i.hv270, or

log close













