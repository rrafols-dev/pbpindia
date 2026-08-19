****Generating district-industry employment and firm totals from establishment-level observations

*1998
set more off
cd "$ec1998" // *data from  this directory cannot be shared -- firm-level microdata and not public use version. Request access from MOSPI
use sdt tot_emp years_op nic agri_nagri reg_code* act_code using ec1998_data_urb, clear	
drop if sdt=="19050100" & tot_emp==5200 & nic=="3101" // outlier firm of 5,200 dropped
merge m:1 sdt using "$ec1998\ec1998_urb_dir"
assert _merge!=1
keep if _merge==3
drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
order statename c01* 
gen urban=1
tempfile x
save `x'

use sdt tot_emp act_code years_op reg_code* nic using ec1998_data_rur, clear      
merge m:1 sdt using ec1998_dir_rur_sdt 
assert _merge!=1
keep if _merge==3
drop _merge sdt c01_sdt c01_tehsilname link_type _merge blockname cd_block tehsilname tehsil distname stdist state
order statename c01* 
gen urban=0
append using `x'

gen num_firms=1
do "$do\nic87_incexempt.do" // tag firms not covered in the policy. 1=medium, ""=restrictive, 2=generous
count if tag==1 

gen string=1 if strpos(nic, ".")
replace string=1 if strpos(nic, "x")
replace string=1 if strpos(nic, "X")
replace string=1 if strpos(nic, "N")
replace string=1 if strpos(nic, "n")
replace string=1 if strpos(nic, "+")
replace string=1 if strpos(nic, "*")
replace string=1 if strpos(nic, "O")
replace string=1 if strpos(nic, "q")
tab act_code if string==1 // 2 belongs to manufacturing the rest are non-manufacturing
gen nic1987_2=substr(nic, 1, 2)
drop if string==1 
drop string
destring nic nic1987_2, replace
rename nic1987_2 nic2004_harm
replace nic2004_harm=100 if act_code==16
replace nic2004_harm=888 if tag==1

order urban nic2004_harm, after(c01_distname)
collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
unique c01_stdist //584
unique statename c01_state c01_state3 c01_stdist c01_distname //584
rename nic2004_harm industry
reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
foreach var of varlist tot_emp2-num_firms888 {
	replace `var'=0 if `var'==.
}
reshape long
save "$dta\ec1998_dist_ind98", replace

***
forval xxx=1/2 {
	set more off
	cd "$ec1998" 
	use sdt tot_emp years_op nic agri_nagri reg_code* act_code using ec1998_data_urb, clear	
	drop if sdt=="19050100" & tot_emp==5200 & nic=="3101" // outlier firm of 5,200 dropped
	merge m:1 sdt using "$ec1998\ec1998_urb_dir"
	assert _merge!=1
	keep if _merge==3
	drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
	order statename c01* 
	gen urban=1
	tempfile x
	save `x'

	use sdt tot_emp act_code years_op reg_code* nic using ec1998_data_rur, clear      
	merge m:1 sdt using ec1998_dir_rur_sdt 
	assert _merge!=1
	keep if _merge==3
	drop _merge sdt c01_sdt c01_tehsilname link_type _merge blockname cd_block tehsilname tehsil distname stdist state
	order statename c01* 
	gen urban=0
	append using `x'

	gen num_firms=1
	do "$do\nic87_incexempt`xxx'.do" // tag firms not covered in the policy. 1=medium, ""=restrictive, 2=generous
	count if tag==1 

	gen string=1 if strpos(nic, ".")
	replace string=1 if strpos(nic, "x")
	replace string=1 if strpos(nic, "X")
	replace string=1 if strpos(nic, "N")
	replace string=1 if strpos(nic, "n")
	replace string=1 if strpos(nic, "+")
	replace string=1 if strpos(nic, "*")
	replace string=1 if strpos(nic, "O")
	replace string=1 if strpos(nic, "q")
	tab act_code if string==1 // 2 belongs to manufacturing the rest are non-manufacturing
	gen nic1987_2=substr(nic, 1, 2)
	drop if string==1 
	drop string
	destring nic nic1987_2, replace
	rename nic1987_2 nic2004_harm
	replace nic2004_harm=100 if act_code==16
	replace nic2004_harm=888 if tag==1

	order urban nic2004_harm, after(c01_distname)
	collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
	unique c01_stdist //584
	unique statename c01_state c01_state3 c01_stdist c01_distname //584
	rename nic2004_harm industry
	reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
	foreach var of varlist tot_emp2-num_firms888 {
		replace `var'=0 if `var'==.
	}
	reshape long
	save "$dta\ec1998_dist_ind98_`xxx'", replace
}

***
*1998 ; no small firms
set more off
cd "$ec1998"
use sdt tot_emp years_op nic agri_nagri reg_code* act_code using ec1998_data_urb, clear
drop if tot_emp<=2	
drop if sdt=="19050100" & tot_emp==5200 & nic=="3101" // outlier firm of 5,200 dropped
merge m:1 sdt using "$ec1998\ec1998_urb_dir"
assert _merge!=1
keep if _merge==3
drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
order statename c01* 
gen urban=1
tempfile x
save `x'

use sdt tot_emp act_code years_op reg_code* nic using ec1998_data_rur, clear    
drop if tot_emp<=2	  
merge m:1 sdt using ec1998_dir_rur_sdt 
assert _merge!=1
keep if _merge==3
drop _merge sdt c01_sdt c01_tehsilname link_type _merge blockname cd_block tehsilname tehsil distname stdist state
order statename c01* 
gen urban=0
append using `x'

gen num_firms=1
do "$xmpt\nic87_incexempt1.do" // tag firms not covered in the policy. 1=medium, 0=restrictive, 2=generous, paper uses 1
count if tag==1 

gen string=1 if strpos(nic, ".")
replace string=1 if strpos(nic, "x")
replace string=1 if strpos(nic, "X")
replace string=1 if strpos(nic, "N")
replace string=1 if strpos(nic, "n")
replace string=1 if strpos(nic, "+")
replace string=1 if strpos(nic, "*")
replace string=1 if strpos(nic, "O")
replace string=1 if strpos(nic, "q")
tab act_code if string==1 // 2 belongs to manufacturing the rest are non-manufacturing
gen nic1987_2=substr(nic, 1, 2)
drop if string==1 
drop string
destring nic nic1987_2, replace
rename nic1987_2 nic2004_harm
replace nic2004_harm=100 if act_code==16
replace nic2004_harm=888 if tag==1

order urban nic2004_harm, after(c01_distname)
collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
unique c01_stdist //584
unique statename c01_state c01_state3 c01_stdist c01_distname //584
rename nic2004_harm industry
reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
foreach var of varlist tot_emp2-num_firms888 {
	replace `var'=0 if `var'==.
}
reshape long
save "$mr\ec1998_dist_ind98_nosmall_1", replace

***
*1998 ; registered firms only
cd "$ec1998"
use sdt tot_emp years_op nic agri_nagri reg_code* act_code using ec1998_data_urb, clear	
drop if sdt=="19050100" & tot_emp==5200 & nic=="3101" // outlier firm of 5,200 dropped
merge m:1 sdt using "$ec1998\ec1998_urb_dir"
assert _merge!=1
keep if _merge==3
drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
order statename c01* 
gen urban=1
tempfile x
save `x'

use sdt tot_emp act_code years_op reg_code* nic using ec1998_data_rur, clear      
merge m:1 sdt using ec1998_dir_rur_sdt 
assert _merge!=1
keep if _merge==3
drop _merge sdt c01_sdt c01_tehsilname link_type _merge blockname cd_block tehsilname tehsil distname stdist state
order statename c01* 
gen urban=0
append using `x'

gen num_firms=1
do "$do\nic87_incexempt1.do" // remove firms not covered in the policy
count if tag==1 

gen string=1 if strpos(nic, ".")
replace string=1 if strpos(nic, "x")
replace string=1 if strpos(nic, "X")
replace string=1 if strpos(nic, "N")
replace string=1 if strpos(nic, "n")
replace string=1 if strpos(nic, "+")
replace string=1 if strpos(nic, "*")
replace string=1 if strpos(nic, "O")
replace string=1 if strpos(nic, "q")
tab act_code if string==1 // 2 belongs to manufacturing the rest are non-manufacturing
gen nic1987_2=substr(nic, 1, 2)
drop if string==1 
drop string
destring nic nic1987_2, replace
rename nic1987_2 nic2004_harm
replace nic2004_harm=100 if act_code==16
replace nic2004_harm=888 if tag==1

order urban nic2004_harm, after(c01_distname)
gen reg_code=reg_code1
replace reg_code=reg_code2 if reg_code==0
drop if reg_code==0 //ONLY REGISTERED FIRMS CONSIDERED
collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
unique c01_stdist //584
unique statename c01_state c01_state3 c01_stdist c01_distname //584
rename nic2004_harm industry
reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
foreach var of varlist tot_emp2-num_firms888 {
	replace `var'=0 if `var'==.
}
reshape long
save "$mr\ec1998_dist_rf1_ind98", replace
