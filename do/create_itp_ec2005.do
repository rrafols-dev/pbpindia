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

use "$dta\ec2005_dist_ind1.dta",clear
do "$do\districtindustry_01to91borders.do"
unique c01_stdist
unique statename c01_state c01_state3 c01_stdist c01_distname 
merge m:1 c01_stdist using `x' // unmatched are backward states, not to worry about in this case
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
label var IntegratedInfrastructureDevelop "Integrated Infrastructure Development"
label var NorthEastIndustrialPolicy "North East Industrial Policy" 
tab NorthEastIndustrialPolicy, m
label var Transportsubsidyscheme "Transport Subsidy Scheme"
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
merge 1:m statename dist91 using `v' // make workfromhome tempfile here ***
keep if _merge==3
drop if weightedcountindex>500 & backwarddist==1

* Variable construction (with dummies):
rename statename state91 
unique state91 dist91
gen indqual=1 if industry>=15 & industry<=37
replace indqual=0 if indqual==.
gen indqual1=1 if industry>=15 & industry<=20
replace indqual1=1 if industry==26
replace indqual1=1 if industry==28
replace indqual1=1 if industry==36
replace indqual1=1 if industry==37
gen indqual2=1 if industry>=21 & industry<=25
replace indqual2=1 if industry>=30 & industry<=35
replace indqual2=1 if industry==27
replace indqual2=1 if industry==29
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
tab industry, m
tab did

gen did1=1 if industry>=1 & industry<=5
gen did2=1 if industry>=10 & industry<=14
gen did3=1 if industry>=15 & industry<=20
replace did3=1 if industry==26
replace did3=1 if industry==28
replace did3=1 if industry==36
replace did3=1 if industry==37
gen did4=1 if industry>=21 & industry<=25
replace did4=1 if industry>=30 & industry<=35
replace did4=1 if industry==27
replace did4=1 if industry==29
gen did5=1 if industry>=40 & industry<=41
gen did6=1 if industry==45
gen did7=1 if industry>=50 & industry<=52
gen did8=1 if industry==55
gen did9=1 if industry>=60 & industry<=64
gen did10=1 if industry>=65 & industry<=67
replace did10=1 if industry>=70 & industry<=71
gen did11=1 if industry>=72 & industry<=74
gen did12=1 if industry>=75 & industry<=85
gen did13=1 if industry>=90 & industry<=99
gen did14=1 if industry==888
forval i=1/14{
	replace did`i'=0 if did`i'==.
	gen DID_`i'=did`i'*backwarddist
}
label var DID_1 "Primary"
label var DID_2 "Mining"
label var DID_3 "Labor-intensive Manufacturing"
label var DID_4 "Capital-intensive Manufacturing"
label var DID_5 "Utility"
label var DID_6 "Construction"
label var DID_7 "Sales and trade"
label var DID_8 "Hotels and Restaurant"
label var DID_9 "Transport and Telecommunication"
label var DID_10 "Finance, Insurance, Real Estate and Rental"
label var DID_11 "Business Services and Research & Development"
label var DID_12 "Public administration, Health and Education"
label var DID_13 "Other Services"
label var DID_14 "Excluded manufacturing"

gen s_did1=1 if industry>=1 & industry<=5
gen s_did2=1 if industry>=10 & industry<=14
replace s_did2=1 if industry==45
gen s_did3=1 if industry>=15 & industry<=20
replace s_did3=1 if industry==26
replace s_did3=1 if industry==28
replace s_did3=1 if industry==36
replace s_did3=1 if industry==37
gen s_did4=1 if industry>=21 & industry<=25
replace s_did4=1 if industry>=30 & industry<=35
replace s_did4=1 if industry==27
replace s_did4=1 if industry==29
gen s_did5=1 if industry>=40 & industry<=41
replace s_did5=1 if industry>=50 & industry<=52
replace s_did5=1 if industry==55
replace s_did5=1 if industry>=60 & industry<=64
replace s_did5=1 if industry>=75 & industry<=85
gen s_did10=1 if industry>=65 & industry<=67
replace s_did10=1 if industry>=70 & industry<=71
replace s_did10=1 if industry>=72 & industry<=74
gen s_did13=1 if industry>=90 & industry<=99
gen s_did14=1 if industry==888
foreach i of num 1/5 10 13/14{
	replace s_did`i'=0 if s_did`i'==.
	gen SDID_`i'=s_did`i'*backwarddist
}
label var SDID_1 "Primary"
label var SDID_2 "Mining and Construction"
label var SDID_3 "Labor-intensive Manufacturing"
label var SDID_4 "Capital-intensive Manufacturing"
label var SDID_5 "Utility, SalesTrade, HotelsRestaurant, TransportTelecom, PublicAdminHealthEduc"
label var SDID_10 "FIRE, Business Services and Research & Development"
label var SDID_13 "Other Services"
label var SDID_14 "Excluded manufacturing"
drop SDID_2 s_did2

gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
drop DID_2

gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.

gen group1=1 if weightedcountindex<=250
gen group2=1 if weightedcountindex>=251 & weightedcountindex<=350
gen group3=1 if weightedcountindex>=351 & weightedcountindex<=500
gen group4=1 if weightedcountindex>=501 & weightedcountindex<=650
gen group5=1 if weightedcountindex>=651 & weightedcountindex<=850
gen group6=1 if weightedcountindex>=851
forval i=1/6{
	replace group`i'=0 if group`i'==.
	gen didgroup`i'=indqual*group`i'
}

label var group1 "250 and below"
label var group2 "251 to 350"
label var group3 "351 to 500"
label var group4 "501 to 650"
label var group5 "651 to 850"
label var group6 "851 and above"

label var didgroup1 "QualifiedIndistries*250 and below"
label var didgroup2 "QualifiedIndistries*251 to 350"
label var didgroup3 "QualifiedIndistries*351 to 500"
label var didgroup4 "QualifiedIndistries*501 to 650"
label var didgroup5 "QualifiedIndistries*651 to 850"
label var didgroup6 "QualifiedIndistries*Scores above 851"
drop group4 didgroup4 

forval j=1/6 {
	gen BDxNB`j'=nbcat_`j'*backwarddist
}
label var BDxNB1 "with neighbors 250 and below"
label var BDxNB2 "with neighbors 251 to 350"
label var BDxNB3 "with neighbors 351 to 500"
label var BDxNB4 "with neighbors 501 to 650"
label var BDxNB5 "with neighbors 651 to 850"
label var BDxNB6 "with neighbors 851 and above"
save ITP_ec2005_noIO.dta, replace

*Saving "_new" version:
use ITP_ec2005_noIO.dta, clear
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
keep loc_code num_firms tot_emp newind did3 did4
rename newind industry
collapse (sum) num_firms tot_emp, by(loc_code industry did3 did4)
gen lnum_firms=log(num_firms)
gen ltot_emp=log(tot_emp)
gen lnum_firms2=lnum_firms
gen ltot_emp2=ltot_emp
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
tempfile xyz
save `xyz'

use ITP_ec2005_noIO.dta, clear
keep loc_code weightedcountindex backwarddist  w1 w2 state91 dist91  logarea logpop work_partrate_t literacy_rate_t logag logmanuf logmainwork ///
nbcat* NIL_NB* group* BDxNB*
duplicates drop _all, force
merge 1:m loc_code using `xyz'
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
save "ITP_ec2005_noIO_new.dta", replace 


