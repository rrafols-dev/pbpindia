global outreg "H:\Desktop\ITP\JDE"

set more off
use "H:\Desktop\ITP\itp_jde.dta", clear // contains final data for paper
drop if weightedcountindex>500 & backwarddist==1
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3


set more off
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' didl didc MaxbdIO  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' bdv2 did  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' didl didc MaxbdIO  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	
	local m7 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m8 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m9 "xi:reg lnum_firms`x' didl didc MaxbdIO  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m10 "xi:reg ltot_emp`x' bdv2 did  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m11 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m12 "xi:reg ltot_emp`x' didl didc MaxbdIO  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"	
	
	capture noi `m1'
	outreg2 using "$outreg\Tab5.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/12 { 
			`m`i''
			outreg2 using "$outreg\Tab5.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}

*new parametric
*Quadratic  scores
set more off
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m7 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m8 "xi:reg lnum_firms`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m9 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m10 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m11 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m12 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\New98_App.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/12 { 
			`m`i''
			outreg2 using "$outreg\New98_App.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}


****************1998
set more off
use "H:\Desktop\ITP\JDE\itp_formal.dta", clear
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
replace Sh_R_firms=0 if Sh_R_firms==.
replace Sh_R_emp=0 if Sh_R_emp==.
*Quadratic  scores
set more off
foreach x in  "2" {
	local m1 "xi:reg Sh_R_firms backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m2 "xi:reg Sh_R_firms bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m3 "xi:reg Sh_R_firms bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m4 "xi:reg Sh_R_emp backwarddist w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"	
	local m5 "xi:reg Sh_R_emp bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"
	local m6 "xi:reg Sh_R_emp bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=850, cluster(loc_code)"

	local m7 "xi:reg Sh_R_firms backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m8 "xi:reg Sh_R_firms bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m9 "xi:reg Sh_R_firms bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m10 "xi:reg Sh_R_emp backwarddist w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"	
	local m11 "xi:reg Sh_R_emp bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"
	local m12 "xi:reg Sh_R_emp bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork , cluster(loc_code)"

	capture noi `m1'
	outreg2 using "$outreg\New98_par_ShRF_App.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/18 { 
			`m`i''
			outreg2 using "$outreg\New98_par_ShRF_App.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}
