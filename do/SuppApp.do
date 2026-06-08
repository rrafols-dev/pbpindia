global outreg "H:\Desktop\ITP\JDE"
***************1998
set more off
use "$dta\itp_jde.dta", clear
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
*Quadratic  scores
set more off
foreach z in  "Rajasthan" { //"Bihar" "Madhya Pradesh" "Rajasthan" "Uttar Pradesh"
preserve
drop if state91=="`z'"
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\New98_no`z'.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\New98_no`z'.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
restore
}
/* Second, we drop the districts which neighbor the backward states and union territories receiving similar policy support under the Finance Act of 1993, 
which may have generated some spillovers over the state borders */
set more off
use "$dta\itp_jde.dta", clear
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
keep if  wTNB5==0
set more off
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\New98_noTDNB.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\New98_noTDNB.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}

/*2) How many group 4 districts that do not neighbor with any treated districts? If there are a 
few of them (10 or more), then use the 14 group 3 districts above and these group 4 districts to replicate 
Table 4. Otherwise, may be not worth doing it.*/
*9 districts from group 4 without any treated district NB; 14 G3 districts //  "Point1" sheet
set more off
use "$dta\itp_jde.dta", clear
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
label var nbsample3 "250 and below" // 38 districts
label var nbsample4 "251 to 350" // 44 districts
label var nbsample5 "351 to 500" // 38 districts
label var nbsample6 "501 to 650" // 39 districts
label var nbsample7 "651 to 850" // 41 districts
label var nbsample8 "851 and above" // 157 districts
gen nonNB34=0 if weightedcountindex>=351 & weightedcountindex<=650 // group 3 and 4
replace nonNB34=1 if weightedcountindex>=351 & weightedcountindex<=500 & NIL_NB4==1 & nonNB34==0
replace nonNB34=1 if weightedcountindex>=501 & weightedcountindex<=650 & NIL_NB3==1 & nonNB34==0
replace nonNB34=0 if nonNB34==.
gen nonNB34_2=nonNB34
replace nonNB34_2=0 if weightedcountindex>=501 & weightedcountindex<=650 & wTNB5==1
keep if nonNB34_2==1
set more off
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\New98_noG4td.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\New98_noG4td.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}


*no boundary change districts
set more off
use "$dta\itp_jde.dta", clear
drop _merge

tempfile x
save `x'
use "$dta\dist_nochange91.dta", clear
rename district91 dist91
keep dist91 state91 drop
replace drop=1 if drop==2
unique state91 dist91 //463
unique state91 dist91 drop //463, should be the same
duplicates drop _all, force
merge 1:m state91 dist91 using `x'
drop if _merge==1 // 106 districts
unique state91 dist91 //357
drop if drop==1 //keeps district without boundary changes
unique state91 dist91 //277
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
set more off
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\New98_noboundchange.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\New98_noboundchange.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
