set more off
use "$dta\ITP_BD_neighbor" , clear
rename statename state91
rename dist91 district91
*neighbor dummy by categories
set more off
forval j=1/6{
	gen nbcat_`j'=.
}
forval i=1/11{
	replace nbcat_1=1 if score`i'<=250  & score`i'!=.
	replace nbcat_2=1 if score`i'>=251 & score`i'<=350
	replace nbcat_3=1  if score`i'>=351 & score`i'<=500
	replace nbcat_4=1  if score`i'>=501 & score`i'<=650
	replace nbcat_5=1  if score`i'>=651 & score`i'<=850
	replace nbcat_6=1 if score`i'>=851 & score`i'!=.
}
forval j=1/6{
	replace nbcat_`j'=0 if nbcat_`j'==.
}



*Tables of No Neighbors:
set more off
gen count_NB1=0
gen count_NB2=0
gen count_NB3=0
gen count_NB4=0
gen count_NB5=0
gen count_NB6=0
forval i=1/11 {
	replace count_NB1=count_NB1+1 if score`i'<=250
	replace count_NB2=count_NB2+1 if score`i'>=251 & score`i'<=350	
	replace count_NB3=count_NB3+1 if score`i'>=351 & score`i'<=500
	replace count_NB4=count_NB4+1 if score`i'>=501 & score`i'<=650
	replace count_NB5=count_NB5+1 if score`i'>=651 & score`i'<=850
	replace count_NB6=count_NB6+1 if score`i'>=851 & score`i'<=15000
}
foreach i in 1 2 3 4 5 6 {
	gen NIL_NB`i'=1 if count_NB`i'==0
	replace NIL_NB`i'=0 if NIL_NB`i'==.
}
gen NIL_NB34=1 if NIL_NB3==1 & NIL_NB4==1
replace NIL_NB34=0 if NIL_NB34==.
gen NIL_NB41=1 if NIL_NB1==1 & NIL_NB4==1
replace NIL_NB41=0 if NIL_NB41==.
gen NIL_NB23=1 if NIL_NB2==1 & NIL_NB3==1
replace NIL_NB23=0 if NIL_NB23==.
drop DISTRICTCODE DIST_STATE backwarddist Adist Bdist NEIGHBORID1 - score11 count_NB*
tempfile r
save `r'

set more off
do "$do\addtd1991.do"
rename statename state91
rename distname district91
merge 1:1 state91 district91 using `r'
unique state91 district91
drop _merge
tempfile q
save `q'

set more off	
use "$dta\gradation_EC_1998_all", clear
drop c01_town_id c01_townname sdt _merge
duplicates drop _all, force 
unique c01_stdist
duplicates tag c01_stdist, gen(x)
drop if x>0
drop x
merge m:1 state91 district91 using `q'
drop if _merge==2
rename _merge mergeTD
unique state91 district91 if policy!=. //should be 360
unique state91 district91 if policy==1 | policy==2 //123 backward districts
bys policy: sum weightedcountindex
replace district91 = ustrfix(district91, " ")
tempfile a
save `a'

import excel using "$dta\ITP_OverlappingPolicies.xls", firstrow clear sheet("OP")
replace district91 = usubinstr(district91, uchar(160), " ", .)
merge 1:m state91 district91  using `a'
assert policy==. if _merge!=3
drop if _merge!=3
drop _merge
count // 563
tempfile x
save `x'	

use "$dta\ec2005_dist_ind1_rf.dta",clear
do "$do\districtindustry_01to91borders.do"
unique c01_stdist
unique statename c01_state c01_state3 c01_stdist c01_distname 
merge m:1 c01_stdist using `x' // unmatched are backward states, not to worry about in this case
drop if _merge!=3 
gen gradationlist=1 if policy!=.
gen backwarddist=1 if policy==1 | policy==2
replace backwarddist=0 if backwarddist==.
gen Adist=1 if policy==1
gen Bdist=1 if policy==2
drop if weightedcountindex==.
unique c01_stdist  // 457
unique c01_stdist industry // 27420
rename statename state01
rename state91 statename
rename district91 dist91
drop _merge

*****Adding PCA 1991 details
preserve
keep dist91 statename industry tot_emp num_firms
collapse (sum) tot_emp num_firms, by(dist91 statename industry)
tempfile b
save `b'
restore
drop c01_state c01_state3 c01_stdist c01_distname industry tot_emp num_firms
duplicates drop _all, force
count
merge 1:m dist91 statename using `b'
drop _merge
tempfile v
save `v'

use "$dta\itp_pca1991", clear
replace dist91 = ustrfix(dist91, " ")
merge 1:m statename dist91 using `v' 
keep if _merge==3
drop if weightedcountindex>500 & backwarddist==1

* Variable construction (with dummies):
rename statename state91 
unique state91 dist91

gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)

gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.


rename tot_emp reg_emp
rename num_firms reg_firms
rename lnum_firms2 lreg_firms2
rename ltot_emp2 lreg_emp2 
drop _merge
keep loc_code industry reg_emp reg_firms lreg_firms2 lreg_emp2
tempfile xyz
save `xyz'


use "$dta\ITP_ec2005_noIO.dta", clear 
drop _merge
merge 1:1 loc_code industry using `xyz'
gen unr_emp=tot_emp-reg_emp 
gen unr_firms=num_firms-reg_firms
sum unr_emp unr_firms
gen l_unr_firms=log(unr_firms)
gen l_unr_emp=log(unr_emp)
gen l_reg_firms=log(reg_firms)
gen l_reg_emp=log(reg_emp)
replace l_unr_firms=0 if l_unr_firms==.
replace l_unr_emp=0 if l_unr_emp==.
replace l_reg_firms=0 if l_reg_firms==.
replace l_reg_emp=0 if l_reg_emp==.
gen Sh_U_firms=unr_firms/num_firms
gen Sh_U_emp=unr_emp/tot_emp
gen Sh_R_firms=reg_firms/num_firms
gen Sh_R_emp=reg_emp/tot_emp
drop if weightedcountindex>500 & backwarddist==1
gen score=weightedcountindex
gen bdv2=backwarddist*(1-indqual)
replace w1=w1/500
replace w2=w1^2
replace w3=w2^3
unique industry //59
unique loc_code //357
tempfile main
save `main'

replace did4=1 if industry==26 | industry==28
replace did3=0 if industry==26 | industry==28
gen newind=industry if did3!=1 & did4!=1 
replace newind=28 if (industry==22 | industry==21)
replace newind=31 if (industry==23 | industry==25)
replace newind=30 if  industry==24
replace newind=32 if  industry==26
replace newind=33 if  industry==27
replace newind=34 if (industry==29 | industry==28)
replace newind=35 if industry==30
replace newind=37 if (industry==34 | industry==35)
replace newind=38 if (industry==31 | industry==32 | industry==33)
replace industry=377 if industry==37
*labor
replace newind=industry if industry==15 
replace newind=industry if industry==17 
replace newind=industry if industry==18 
replace newind=industry if industry==19 
replace newind=industry if industry==20 
replace newind=industry if industry==36
replace newind=industry if industry==377
unique newind //53
tab newind if did3==1 //7
tab newind if did4==1 //9
keep loc_code num_firms reg_firms unr_firms tot_emp reg_emp unr_emp newind did3 did4
rename newind industry
collapse (sum) num_firms reg_firms unr_firms tot_emp reg_emp unr_emp, by(loc_code industry did3 did4)
gen Sh_R_firms=reg_firms/num_firms
gen Sh_R_emp=reg_emp/tot_emp
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
save "itp_formal05_new.dta"

use `main', clear
keep loc_code weightedcountindex backwarddist  w1 w2 state91 dist91 logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork ///
nbcat* NIL_NB* group* BDxNB*
duplicates drop _all, force
merge 1:m loc_code using "itp_formal05_new.dta"
drop _merge
gen indqual=1 if (did3==1 | did4==1)
gen indqual1=1 if did3==1 
gen indqual2=1 if did4==1
replace indqual=0 if indqual==.
replace indqual1=0 if indqual1==.
replace indqual2=0 if indqual2==.
gen bdv2=backwarddist*(1-indqual)
gen did=indqual*backwarddist
gen didl=indqual1*backwarddist
gen didc=indqual2*backwarddist
label var did "treatment industry interaction term"
label var didl "treatment (labor-manufacturing) interaction term"
label var didc "treatment (capital-manufacturing) interaction term"
save "itp_formal05_new.dta", replace 
