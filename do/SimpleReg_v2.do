global outreg "C:\Users\Michelle Rafols\Documents\ITP"


use "F:\ADB\ITP Revise\itp_jde.dta", clear
keep state91 dist91 backwarddist w1 w2 w3 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork weightedcountindex loc_code
duplicates drop _all, force
assert _N==357
save "C:\Users\Michelle Rafols\Documents\ITP\DistLevel.dta", replace


/*
e.	(R2C2) Collapse the data (firm counts and employment) to district level for manufacturing (treated) industries 
and non-manufacturing (untreated) industries, respectively.Estimate the following models for the three samples (G3-G4, G2-G5, and full sample) 
and for manufacturing and non-manufacturing industries (3x2=6 regressions in total):
*/
use "F:\ADB\ITP Revise\itp_jde.dta", clear
keep if (industry>=20 & industry<=38) | industry==888 //16 manuf industry dummies
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
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\DistLevel.dta"
assert _merge==3

set more off
foreach x in "" "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Elgible.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Elgible.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "" "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Elgible.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Elgible.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
*********************
*********************
use "F:\ADB\ITP Revise\itp_jde.dta", clear
/*
e.	(R2C2) Collapse the data (firm counts and employment) to district level for manufacturing (treated) industries 
and non-manufacturing (untreated) industries, respectively.Estimate the following models for the three samples (G3-G4, G2-G5, and full sample) 
and for manufacturing and non-manufacturing industries (3x2=6 regressions in total):
*/
*keep if (industry>=20 & industry<=38) | industry==888 //16 manuf industry dummies
drop if indqual==1 // all untreated industries out
collapse (sum) num_firms tot_emp, by(loc_code state91 dist91)
assert _N==357
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
merge 1:1 state91 dist91 using "C:\Users\Michelle Rafols\Documents\ITP\DistLevel.dta"
assert _merge==3

set more off
foreach x in "" "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3  i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_DistCl_Untreatd.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_DistCl_Untreatd.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
set more off
foreach x in "" "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m2 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	local m4 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m5 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(state91)"
	local m6 "xi:reg ltot_emp`x' backwarddist w1 w2 w3 i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork, cluster(state91)"
	capture noi `m1'
	outreg2 using "$outreg\RD`x'_StateCl_Untreatd.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\RD`x'_StateCl_Untreatd.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
