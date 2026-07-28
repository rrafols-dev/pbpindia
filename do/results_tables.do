*Table 4:
est clear
use "$dta\itp_jde.dta", clear  
drop w1
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
*if nonNB34=1 to indicate neighboring group 3 and 4 districts, then the opposite will be true
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' did bdv2  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"	
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x'  did bdv2    w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"	
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\Tab4.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\Tab4.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}

*________________________________________________________________________________

*Table 5:
*beware of sequence :
*m1/9=LogY
*m2/10=State clustering
*m3/11=3rd Order Polynomial
*m4/12=4th Order Polynomial
*m5/13=Incl. other policies
*m6/14=False cut-off at 350
*m7/15=False cut-off at 250
*m8/16=Polynomial int. with backward dummy
********************************************************************************
est clear
use "$dta\itp_jde.dta", clear 
gen backwarddist2=backwarddist
gen backwarddist3=backwarddist
replace backwarddist2=0 if weightedcountindex>=351 & weightedcountindex<=500
replace backwarddist3=0 if weightedcountindex>=251 & weightedcountindex<=350
gen didl2=indqual1*backwarddist2
gen didc2=indqual2*backwarddist2
gen bdv22=backwarddist2*(1-indqual)
gen didl3=indqual1*backwarddist3
gen didc3=indqual2*backwarddist3
gen bdv23=backwarddist3*(1-indqual)

drop w1
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3
replace w4=w1^4

forval i=1/2{
	gen w`i'_d=w`i'*backwarddist
	replace w`i'_d=0 if w`i'_d==. 
}

foreach x in  "2" {
	local m1 "xi:reg lnum_firms didl didc bdv2  w1 w2   i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' didl didc bdv2 w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m3 "xi:reg lnum_firms`x' didl didc bdv2 w1 w2 w3 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg lnum_firms`x' didl didc bdv2 w1 w2 w3 w4 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg lnum_firms`x' didl didc bdv2 w1 w2  DevelopmentofGrowthCentres IntegratedInfrastructureDevelopi NorthEastIndustrialPolicy Transportsubsidyscheme i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m6 "xi:reg lnum_firms`x' didl2 didc2 bdv22 w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=500, cluster(loc_code)"
	local m7 "xi:reg lnum_firms`x' didl3 didc3 bdv23 w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=0 & weightedcountindex<=350, cluster(loc_code)"
	local m8 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  w1_d w2_d  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	
	local m9 "xi:reg ltot_emp didl didc bdv2 w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m10 "xi:reg ltot_emp`x' didl didc bdv2 w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m11 "xi:reg ltot_emp`x' didl didc bdv2 w1 w2 w3 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m12 "xi:reg ltot_emp`x' didl didc bdv2 w1 w2 w3 w4 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m13 "xi:reg ltot_emp`x' didl didc bdv2 w1 w2 DevelopmentofGrowthCentres IntegratedInfrastructureDevelopi NorthEastIndustrialPolicy Transportsubsidyscheme i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(state91)"
	local m14 "xi:reg ltot_emp`x' didl2 didc2 bdv22 w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=251 & weightedcountindex<=500, cluster(loc_code)"
	local m15 "xi:reg ltot_emp`x' didl3 didc3 bdv23 w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=0 & weightedcountindex<=350, cluster(loc_code)"
	local m16 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  w1_d w2_d  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\robust2.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/16 { 
			`m`i''
			outreg2 using "$outreg\robust2.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}

*For the rest of the exercise, to complete table 5
local i=16
foreach name in "conser" "agress" "nosmall" {
	use "$dta\itpdata_`name'.dta", clear 
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
	sum area_t res_house_t t_popln_t work_partrate_t literacy_rate_t sex_ratio_t 
	gen logarea=log(area_t)
	gen logres_house=log(res_house_t)
	gen logpop=log(t_popln_t)
	gen logag=log(t_agfc_t)
	gen logmanuf=log(t_manuf_t)
	gen logmainwork=log(t_worker_t)
	label var logag "1991 log primary workers"
	label var logmanuf "1991 log manuf. workers"
	label var logmainwork "1991 log main workers"


	gen lnum_firms=log(num_firms)
	gen ltot_emp=log(tot_emp)
	gen lnum_firms2=lnum_firms
	gen ltot_emp2=ltot_emp
	replace lnum_firms2=0 if lnum_firms2==.
	replace ltot_emp2=0 if ltot_emp2==.

	** cutoff score:***
	replace w1=(w1/500)-1
	replace w2=w1^2
	gen bdv2=backwarddist*(1-indqual)
	
	xi:reg lnum_firms2 didl didc bdv2  w1 w2   i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)
	local i=`i'+1
	outreg2 using "$outreg\robust2.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)
	
	xi:reg ltot_emp2 didl didc bdv2  w1 w2   i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)
	local i=`i'+1
	outreg2 using "$outreg\robust2.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)

}


*________________________________________________________________________________

*Table 6:
est clear
use "$dta\itp_formal.dta", clear
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3

*Quadratic  scores
set more off
foreach x in  "2" {

	local m1 "xi:reg Sh_R_firms backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg Sh_R_firms bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg Sh_R_firms bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg Sh_R_emp backwarddist w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"	
	local m5 "xi:reg Sh_R_emp bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg Sh_R_emp bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=351 & weightedcountindex<=650, cluster(loc_code)"
	
	
	capture noi `m1'
	outreg2 using "$outreg\Tab6.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\Tab6.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}

*________________________________________________________________________________

*Table 7:
est clear
use "$dta\itp_jde.dta", clear  
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
keep if weightedcountindex>=351 & weightedcountindex<=650
drop w1
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
*if nonNB34=1 to indicate neighboring group 3 and 4 districts, then the opposite will be true
foreach x in  "2" {
	local m1 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if nonNB34==0, cluster(loc_code)"
	local m2 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if nonNB34==0, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if nonNB34==1, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if nonNB34==1, cluster(loc_code)"
	capture noi `m1'
	outreg2 using "$outreg\Tab7.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/4 { 
			`m`i''
			outreg2 using "$outreg\Tab7.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}



*________________________________________________________________________________

*Table 10:
est clear
use "$dta\ITP_ec2005_noIO_new.dta", clear
drop if weightedcountindex>500 & backwarddist==1
gen score=weightedcountindex
replace w1=(w1/500)-1
replace w2=w1^2
unique industry //53
unique loc_code //357


foreach x in  "2" {

	local m1 "xi:reg lnum_firms`x' backwarddist  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m2 "xi:reg lnum_firms`x' bdv2 did  w1 w2 i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m3 "xi:reg lnum_firms`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m4 "xi:reg ltot_emp`x' backwarddist  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m5 "xi:reg ltot_emp`x' bdv2 did  w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"
	local m6 "xi:reg ltot_emp`x' bdv2 didl didc w1 w2  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=650, cluster(loc_code)"


	capture noi `m1'
	outreg2 using "$outreg\Tab10.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
		forval i=2/6 { 
			`m`i''
			outreg2 using "$outreg\Tab10.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
		}
}


*________________________________________________________________________________

*Table 8:
global td1991 "$dta"

estimates clear
use "$dta\ITP_BD_neighbor.dta", clear
rename statename state91
rename dist91 district91
forval i=1/11{
	strparse NEIGH`i', gen(nst`i') parse(_)
	gen nbst`i'=1 if nst`i'1=="ASSAM"
	replace nbst`i'=1 if nst`i'1=="JAMMU"
	replace nbst`i'=1 if nst`i'1=="HIMACHAL"
	replace nbst`i'=1 if nst`i'1=="SIKKIM"
	replace nbst`i'=1 if nst`i'1=="WEST"
	replace nbst`i'=1 if nst`i'1=="NAGALAND"
	replace nbst`i'=1 if nst`i'1=="MIZORAM"
	replace nbst`i'=1 if nst`i'1=="TRIPURA"
	replace nbst`i'=1 if nst`i'1=="West Bengal"
	replace nbst`i'=0 if nbst`i'==.
}
*keep nst*1
*stack nst*1, into(new)
*keep new
*duplicates drop _all, force
gen nTNB1=0
gen nTNB3=0 
gen nTNB4=0  
gen nTNB6=0 
gen nTNB7=0 
gen nTNB8=0
forval i=1/11{
	replace nTNB1=nTNB1+1 if score`i'<=250 & score`i'!=.
	replace nTNB3=nTNB3+1 if score`i'>=251 & score`i'<=350
	replace nTNB4=nTNB4+1 if score`i'>=351 & score`i'<=500
	replace nTNB6=nTNB6+1 if score`i'>=501 & score`i'<=650
	replace nTNB7=nTNB7+1 if score`i'>=651 & score`i'<=850
	replace nTNB8=nTNB8+1 if score`i'>=851 & score`i'!=.
}

keep state91 district91 nTNB*
tempfile r
save `r'

set more off
do "$do\addtd1991.do"
rename statename state91
rename distname district91
merge 1:1 state91 district91 using `r'
unique state91 district91
drop _merge
rename district91 dist91
tempfile z
save `z'

use "$dta\itp_jde.dta", clear
drop _merge
merge m:1  state91 dist91 using `z'
drop if _merge==2 // nothing dropped from Restat data okay

label var nTNB1 "count of 250 and below neighbors"
label var nTNB3 "count of 251-350 neighbors"
label var nTNB4 "count of 351-500 neighbors"
label var nTNB6 "count of 501-650 neighbors"
label var nTNB7 "count of 651-850 neighbors"
label var nTNB8 "count of 851 and up neighbors"
drop if weightedcountindex>500 & backwarddist==1
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace w3=w1^3


*create a dummy D=1 if the district is adjacent to a district from group 3 and estimate:  
gen nBD=nTNB1+nTNB3+nTNB4 
gen nNBD=nTNB6+nTNB7+nTNB8
label var nBD "Total number of neighboring backward districts" 
label var nNBD "Total number of neighboring non-backward districts" 

*include a dummy I=1 if the district is adjacent to a district from the opposite treatment group
gen Ig4=1 if nTNB4>0 
replace Ig4=0 if Ig4==.
gen Ig3=1 if nTNB6>0 
replace Ig3=0 if Ig3==.
label var Ig3 "Neighboring opposite district"
label var Ig4 "Neighboring opposite district"


set more off
local m1 "xi:reg lnum_firms2 Ig3 w1 w2 nBD nNBD  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=500, cluster(loc_code)"
local m2 "xi:reg ltot_emp2 Ig3 w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=500, cluster(loc_code)"
local m3 "xi:reg lnum_firms2 Ig4   w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=501 & weightedcountindex<=650, cluster(loc_code)"
local m4 "xi:reg ltot_emp2 Ig4 w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=501 & weightedcountindex<=650, cluster(loc_code)"
`m1'
outreg2 using "$outreg\Tab8_panelA.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
forval i=2/4 { 
	`m`i''
	outreg2 using "$outreg\Tab8_panelA.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
}


set more off
local m1 "xi:reg lnum_firms2 nTNB6  w1 w2 nBD nNBD  i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=500, cluster(loc_code)"
local m2 "xi:reg ltot_emp2 nTNB6    w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=350 & weightedcountindex<=500, cluster(loc_code)"
local m3 "xi:reg lnum_firms2 nTNB4    w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=501 & weightedcountindex<=650, cluster(loc_code)"
local m4 "xi:reg ltot_emp2 nTNB4   w1 w2 nBD nNBD i.industry i.state91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork if weightedcountindex>=501 & weightedcountindex<=650, cluster(loc_code)"
`m1'
outreg2 using "$outreg\Tab8_panelB.xls", replace ctitle("Model 1") label drop(_Istate* _Iindustry*)
forval i=2/4 { 
	`m`i''
	outreg2 using "$outreg\Tab8_panelB.xls", append ctitle("Model `i'") label drop(_Istate* _Iindustry*)			
}
