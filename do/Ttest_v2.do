*Genereate T-test for untreated industries
set more off
use "F:\ADB\ITP Revise\itp_jde.dta", clear
tab didl didc, m
tab did, m
tab did backwarddist, m
**only eligible industries
gen num_firms_qual=num_firms if indqual==1
gen tot_emp_qual=tot_emp if indqual==1
gen num_firms_unq=num_firms if indqual==0
gen tot_emp_unq=tot_emp if indqual==0
collapse (sum) num_firms* tot_emp*, by(state91 dist91)
label var num_firms_qua "Qualified manufacturing firms"
label var num_firms_unq "Unqualified firms" 
label var tot_emp_qual "Employment from qualified manufacturing firms"
label var tot_emp_unq "Employment from unqualified firms"
label var tot_emp "Employment from all firms"
label var num_firms "Total firms"
label var tot_emp_unq "Employment from unqualified firms"
label var tot_emp "Employment from all firms"
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace


set more off
use "F:\ADB\Geography of Jobs\MR\ITP\itpdata_large10.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
* Variable construction
*qualified industries
gen indqual=1 if industry>=20 & industry<=38
*labor intensive:
gen indqual1=1 if industry>=20 & industry<=27
replace indqual1=1 if industry==29
*capital intensive
gen indqual2=1 if industry>=30 & industry<=38
replace indqual2=1 if industry==28
replace indqual=0 if indqual==.
replace indqual1=0 if indqual1==.
replace indqual2=0 if indqual2==.
gen did=indqual*backwarddist
gen didl=indqual1*backwarddist
gen didc=indqual2*backwarddist
label var did "treatment industry interaction term"
label var didl "treatment (labor-manufacturing) interaction term"
label var didc "treatment (capital-manufacturing) interaction term"
tab didl didc, m
tab did, m
tab did backwarddist, m
gen num_firms_quaL10=num_firms if indqual==1
gen tot_emp_quaL10=tot_emp if indqual==1
gen num_firms_unqL10=num_firms if indqual==0
gen tot_emp_unqL10=tot_emp if indqual==0
drop num_firms tot_emp
collapse (sum) num_firms* tot_emp*, by(state91 dist91)
gen num_firmsL10=num_firms_quaL10+num_firms_unqL10
gen tot_empL10=tot_emp_quaL10+tot_emp_unqL10
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta"
assert _merge==3
drop _merge
label var num_firms_quaL10 "Qualified manufacturing firms, 10+ workers"
label var num_firms_unqL10 "Unqualified firms, 10+ workers"
label var tot_emp_quaL10 "Employment from qualified manufacturing firms, 10+ workers"
label var tot_emp_unqL10 "Employment from unqualified firms, 10+ workers"
label var tot_empL10 "Employment from all firms, 10+ workers"
label var num_firmsL10 "Total firms, 10+ workers"
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace


set more off
use "F:\ADB\Geography of Jobs\MR\ITP\itpdata_below10.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
* Variable construction
*qualified industries
gen indqual=1 if industry>=20 & industry<=38
*labor intensive:
gen indqual1=1 if industry>=20 & industry<=27
replace indqual1=1 if industry==29
*capital intensive
gen indqual2=1 if industry>=30 & industry<=38
replace indqual2=1 if industry==28
replace indqual=0 if indqual==.
replace indqual1=0 if indqual1==.
replace indqual2=0 if indqual2==.
gen did=indqual*backwarddist
gen didl=indqual1*backwarddist
gen didc=indqual2*backwarddist
label var did "treatment industry interaction term"
label var didl "treatment (labor-manufacturing) interaction term"
label var didc "treatment (capital-manufacturing) interaction term"
tab didl didc, m
tab did, m
tab did backwarddist, m
gen num_firms_quaB10=num_firms if indqual==1
gen tot_emp_quaB10=tot_emp if indqual==1
gen num_firms_unqB10=num_firms if indqual==0
gen tot_emp_unqB10=tot_emp if indqual==0
drop num_firms tot_emp
collapse (sum) num_firms* tot_emp*, by(state91 dist91)
gen num_firmsB10=num_firms_quaB10+num_firms_unqB10
gen tot_empB10=tot_emp_quaB10+tot_emp_unqB10
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta"
assert _merge==3
drop _merge
label var num_firms_quaB10 "Qualified manufacturing firms, <10 workers"
label var num_firms_unqB10 "Unqualified firms, <10 workers" 
label var tot_emp_quaB10 "Employment from qualified manufacturing firms, <10 workers"
label var tot_emp_unqB10 "Employment from unqualified firms, <10 workers"
label var tot_empB10 "Employment from all firms, <10 workers"
label var num_firmsB10 "Total firms, <10 workers"
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace


set more off
use "F:\ADB\Geography of Jobs\MR\ITP\itpdata_young.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
* Variable construction
*qualified industries
gen indqual=1 if industry>=20 & industry<=38
*labor intensive:
gen indqual1=1 if industry>=20 & industry<=27
replace indqual1=1 if industry==29
*capital intensive
gen indqual2=1 if industry>=30 & industry<=38
replace indqual2=1 if industry==28
replace indqual=0 if indqual==.
replace indqual1=0 if indqual1==.
replace indqual2=0 if indqual2==.
gen did=indqual*backwarddist
gen didl=indqual1*backwarddist
gen didc=indqual2*backwarddist
label var did "treatment industry interaction term"
label var didl "treatment (labor-manufacturing) interaction term"
label var didc "treatment (capital-manufacturing) interaction term"
tab didl didc, m
tab did, m
tab did backwarddist, m
gen num_firms_quayng=num_firms if indqual==1
gen tot_emp_quayng=tot_emp if indqual==1
gen num_firms_unqyng=num_firms if indqual==0
gen tot_emp_unqyng=tot_emp if indqual==0
drop num_firms tot_emp
collapse (sum) num_firms* tot_emp*, by(state91 dist91)
gen num_firmsYNG=num_firms_quayng+num_firms_unqyng
gen tot_empYNG=tot_emp_quayng+tot_emp_unqyng
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta"
assert _merge==3
drop _merge
label var num_firms_quayng "Qualified manufacturing firms aged 0-4"
label var num_firms_unqyng "Unqualified firms aged 0-4"
label var tot_emp_quayng "Employment from qualified manufacturing firms aged 0-4"
label var tot_emp_unqyng "Employment from  unqualified firms aged 0-4"
label var tot_empYNG "Employment from all firms aged 0-4"
label var num_firmsYNG "Total firms aged 0-4"
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace

set more off
use "F:\ADB\Geography of Jobs\MR\ITP\itpdata_old.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
* Variable construction
*qualified industries
gen indqual=1 if industry>=20 & industry<=38
*labor intensive:
gen indqual1=1 if industry>=20 & industry<=27
replace indqual1=1 if industry==29
*capital intensive
gen indqual2=1 if industry>=30 & industry<=38
replace indqual2=1 if industry==28
replace indqual=0 if indqual==.
replace indqual1=0 if indqual1==.
replace indqual2=0 if indqual2==.
gen did=indqual*backwarddist
gen didl=indqual1*backwarddist
gen didc=indqual2*backwarddist
label var did "treatment industry interaction term"
label var didl "treatment (labor-manufacturing) interaction term"
label var didc "treatment (capital-manufacturing) interaction term"
tab didl didc, m
tab did, m
tab did backwarddist, m
gen num_firms_quaold=num_firms if indqual==1
gen tot_emp_quaold=tot_emp if indqual==1
gen num_firms_unqold=num_firms if indqual==0
gen tot_emp_unqold=tot_emp if indqual==0
drop num_firms tot_emp
collapse (sum) num_firms* tot_emp*, by(state91 dist91)
gen num_firmsOLD=num_firms_quaold+num_firms_unqold
gen tot_empOLD=tot_emp_quaold+tot_emp_unqold
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta"
assert _merge==3
drop _merge
label var num_firms_quaold "Qualified manufacturing firms aged 5+"
label var num_firms_unqold "Unqualified firms aged 5+"
label var tot_emp_quaold "Employment from qualified manufacturing firms aged 5+"
label var tot_emp_unqold "Employment from unqualified firms aged 5+"
label var tot_empOLD "Employment from all firms aged 5+"
label var num_firmsOLD "Total firms 5+"
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace

use "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", clear
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\DistLevel.dta"
assert _merge==3
drop  loc_code-work_partrate_t w1-_merge
save "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", replace


*generate tables:
global outreg "C:\Users\Michelle Rafols\Documents\ITP"
*Ttest
cd "$outreg" 
set more off
use "C:\Users\Michelle Rafols\Documents\ITP\Dist_TTest_v2.dta", clear
putexcel set "PCA2_T-test.xlsx", sheet("t_test_`y'") modify
putexcel A1=("Variable") B1=("Control (Mean)") C1=("Treatment (Mean)") D1=("Difference") E1=("p value")
local row=2
foreach var of varlist  num_firms_quaold-tot_emp_unq {
	qui ttest `var', by(backwarddist)
	local d: variable label `var'
	putexcel A`row' = ("`d'")
	putexcel B`row' = (r(mu_1))
	putexcel C`row' = (r(mu_2))
	putexcel D`row' = (r(mu_2)-r(mu_1))
	putexcel E`row' = (r(p))
	local ++row
	putexcel B`row' = (r(sd_1)/sqrt(r(N_1)))
	putexcel C`row' = (r(sd_2)/sqrt(r(N_2)))
	putexcel D`row' = (r(se))
	local ++row
}
putexcel A`row'=("Scores: 251 to 850")
local ++row
foreach var of varlist  num_firms_quaold-tot_emp_unq {
	qui ttest `var' if weightedcountindex>=251 & weightedcountindex<=850, by(backwarddist)
	local d: variable label `var'
	putexcel A`row' = ("`d'")
	putexcel B`row' = (r(mu_1))
	putexcel C`row' = (r(mu_2))
	putexcel D`row' = (r(mu_2)-r(mu_1))
	putexcel E`row' = (r(p))
	local ++row
	putexcel B`row' = (r(sd_1)/sqrt(r(N_1)))
	putexcel C`row' = (r(sd_2)/sqrt(r(N_2)))
	putexcel D`row' = (r(se))
	local ++row
}
putexcel A`row'=("Scores: 351 to 650")
local ++row
foreach var of varlist  num_firms_quaold-tot_emp_unq {
	qui ttest `var' if weightedcountindex>=351 & weightedcountindex<=650, by(backwarddist)
	local d: variable label `var'
	putexcel A`row' = ("`d'")
	putexcel B`row' = (r(mu_1))
	putexcel C`row' = (r(mu_2))
	putexcel D`row' = (r(mu_2)-r(mu_1))
	putexcel E`row' = (r(p))
	local ++row
	putexcel B`row' = (r(sd_1)/sqrt(r(N_1)))
	putexcel C`row' = (r(sd_2)/sqrt(r(N_2)))
	putexcel D`row' = (r(se))
	local ++row
}
