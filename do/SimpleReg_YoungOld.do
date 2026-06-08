use "$dta\itpdata_young.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
keep if (industry>=20 & industry<=38) | industry==888 //16 manuf industry dummies
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
**only eligible industries
keep if (industry>=20 & industry<=38) | industry==888 
keep if indqual==1 // 5712, same as keep if indqual==1
collapse (sum) num_firms tot_emp, by(state91 dist91)
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
merge 1:1 state91 dist91 using "$dta\DistLevel.dta"
assert _merge==3

set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Elgible_Young.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Elgible_Young.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Elgible_Young.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Elgible_Young.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
*********************
*********************

use "$dta\itpdata_young.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
*keep if (industry>=20 & industry<=38) | industry==888 // no all unqualified
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
drop if indqual==1 
collapse (sum) num_firms tot_emp, by(state91 dist91)
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
merge 1:1 state91 dist91 using "$dta\DistLevel.dta"
assert _merge==3

set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Untreatd_Young.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Untreatd_Young.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Untreatd_Young.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Untreatd_Young.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}


*****
*****
*****
*****
*****
*****
*****

clear
use "$dta\itpdata_old.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
keep if (industry>=20 & industry<=38) | industry==888 //16 manuf industry dummies
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
**only eligible industries
keep if indqual==1 // 5712, same as keep if indqual==1
collapse (sum) num_firms tot_emp, by(state91 dist91)
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
merge 1:1 state91 dist91 using "$dta\DistLevel.dta"
assert _merge==3

set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Elgible_Age5up.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Elgible_Age5up.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Elgible_Age5up.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Elgible_Age5up.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
*********************
*********************

use "$dta\itpdata_old.dta", clear
drop if weightedcountindex>500 & backwarddist==1
rename statename state91 
*keep if (industry>=20 & industry<=38) | industry==888 // all industries
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
drop if indqual==1 // 5712, same as keep if indqual==1
collapse (sum) num_firms tot_emp, by(state91 dist91)
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
merge 1:1 state91 dist91 using "$dta\DistLevel.dta"
assert _merge==3

set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Untreatd_Age5up.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Untreatd_Age5up.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Untreatd_Age5up.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Untreatd_Age5up.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
