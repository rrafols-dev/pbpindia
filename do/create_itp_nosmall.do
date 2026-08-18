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

label var nbcat_1 "250 and below" 
label var nbcat_2 "251 to 350" 
label var nbcat_3 "351 to 500" 
label var nbcat_4 "501 to 650" 
label var nbcat_5 "651 to 850"
label var nbcat_6 "851 and above" 

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
label var NIL_NB1 "Without neighbors scored 250 and below"	
label var NIL_NB2 "Without neighbors scored 251 to 350"	
label var NIL_NB3 "Without neighbors scored 351 to 500"	
label var NIL_NB4 "Without neighbors scored 501 to 650"	
label var NIL_NB5 "Without neighbors scored 651 to 850"	
label var NIL_NB6 "Without neighbors scored 851 and up"	
label var NIL_NB34 "Without neighbors scored 351 to 650"		 
label var NIL_NB41 "Without neighbors scored 250below and 501 to 650"			 
label var NIL_NB23 "Without neighbors scored 251 to 500"	
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

use "$dta\ec1998_dist_ind98_nosmall_1",clear 
replace industry=1 if industry==2
	drop if industry==88 | industry==86 | industry==87 | industry==100
	replace industry=35 if industry==36
	replace industry=20 if industry==21
	replace industry=20 if industry==22
collapse(sum) tot_emp num_firms, by(statename c01_state c01_state3 c01_stdist c01_distname urban industry)
do "$do\districtindustry_01to91borders.do"
replace industry=2 if industry==1
unique c01_stdist
unique statename c01_state c01_state3 c01_stdist c01_distname 
merge m:1 c01_stdist using `x'
drop if _merge!=3 
tab policy, m
tab policy, nolabel	
gen gradationlist=1 if policy!=.
gen backwarddist=1 if policy==1 | policy==2
replace backwarddist=0 if backwarddist==.
gen Adist=1 if policy==1
gen Bdist=1 if policy==2
label var gradationlist "Found in Gradation List"
label var backwarddist "Backward District"
label var Adist "A - backward district"
label var Bdist "B - backward district"

gen w1=weightedcountindex
gen w2=weightedcountindex^2
gen w3=weightedcountindex^3
label var w1 " score"
label var w2 "squared score"
label var w3 "cubic score"
label var DevelopmentofGrowthCentres "Development of Growth Centres"
*label var IntegratedInfrastructureDevelop "Integrated Infrastructure Development"
label var NorthEastIndustrialPolicy "North East Industrial Policy" 
tab NorthEastIndustrialPolicy, m
label var Transportsubsidyscheme "Transport Subsidy Scheme"
drop if weightedcountindex==.
unique c01_stdist  // 460
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
saveold itpdata_nosmall.dta, replace 
