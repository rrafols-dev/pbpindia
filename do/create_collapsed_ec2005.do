*all firms:
set more off
cd "$ec2005"
use sdt tot_emp nic agri_nagri reg_code* act_code using ec2005_data_urb, clear	
merge m:1 sdt using "$ec2005\ec2005_urb_dir"
assert _merge!=1
keep if _merge==3
drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
order statename c01* 
gen urban=1
tempfile x
save `x'

use sdt tot_emp act_code reg_code* nic using ec2005_data_rur, clear      
merge m:1 sdt using ec2005_dir_rur_sdt 
assert _merge!=1
keep if _merge==3
drop _merge sdt c01_sdt c01_tehsilname link_type _merge tehsilname tehsil distname stdist state
order statename c01* 
gen urban=0
append using `x'

gen num_firms=1
gen nic2004_harm=substr(nic,1,2)
destring nic2004_harm, replace
do "$do\nic04_incexempt1.do" // tag firms not covered in the policy. 1=medium, 0=restrictive, 2=generous
count if tag==1 

tab act_code if nic2004_harm==.
drop if nic2004_harm==.
replace nic2004_harm=888 if tag==1

order urban nic2004_harm, after(c01_distname)
collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
unique c01_stdist //592
unique statename c01_state c01_state3 c01_stdist c01_distname //592
rename nic2004_harm industry
reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
foreach var of varlist tot_emp1-num_firms888 { // change when done removing exempted manuf.
	replace `var'=0 if `var'==.
}
reshape long
save "$dta\ec2005_dist_ind1", replace

*registered firms only
set more off
cd "$ec2005"
use sdt tot_emp nic agri_nagri reg_code* act_code using ec2005_data_urb, clear	
merge m:1 sdt using "$ec2005\ec2005_urb_dir"
assert _merge!=1
keep if _merge==3
drop _merge sdt link_type c01_town_id c01_level state stdist distname town townname c01_townname
order statename c01* 
gen urban=1
tempfile x
save `x'

use sdt tot_emp act_code reg_code* nic using ec2005_data_rur, clear      
merge m:1 sdt using ec2005_dir_rur_sdt 
assert _merge!=1
keep if _merge==3
drop _merge sdt c01_sdt c01_tehsilname link_type _merge tehsilname tehsil distname stdist state
order statename c01* 
gen urban=0
append using `x'

gen num_firms=1
gen nic2004_harm=substr(nic,1,2)
destring nic2004_harm, replace
do "$do\nic04_incexempt1.do" // tag firms not covered in the policy. 1=medium, 0=restrictive, 2=generous
count if tag==1 

tab act_code if nic2004_harm==.
drop if nic2004_harm==.
replace nic2004_harm=888 if tag==1

order urban nic2004_harm, after(c01_distname)
gen reg_code=reg_code1
replace reg_code=reg_code2 if reg_code==0
drop if reg_code==0 //ONLY REGISTERED FIRMS CONSIDERED
collapse (sum) tot_emp num_firms, by(statename-nic2004_harm)
unique c01_stdist //592
unique statename c01_state c01_state3 c01_stdist c01_distname //592
rename nic2004_harm industry
reshape wide tot_emp num_firms, i(statename c01_state c01_state3 c01_stdist c01_distname urban) j(industry)
foreach var of varlist tot_emp1-num_firms888 { // change when done removing exempted manuf.
	replace `var'=0 if `var'==.
}
reshape long
save "$dta\ec2005_dist_ind1_rf", replace
