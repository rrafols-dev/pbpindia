set more off
unique c01_stdist 
reshape wide
drop urban
collapse (sum) tot_emp* num_firms*, by(statename-c01_distname)
replace c01_distname="Saiha" if c01_stdist=="1507"
replace c01_distname="East Siang" if c01_stdist=="1209"
replace c01_stdist="1508" if c01_stdist=="1507" 
replace c01_stdist="1208" if c01_stdist=="1209"
replace c01_distname="East Khasi Hills" if c01_distname=="Ri Bhoi"
replace c01_stdist="1706" if c01_distname=="East Khasi Hills" 
assert c01_stdist!="1705"
gen rank=1
gen x=1

	local new=_N+1
	set obs `new'
	replace c01_stdist="0510" if c01_stdist==""
	replace x=.7844 if x==.
	replace x=.2156 if c01_stdist=="0510" & x==1 & c01_distname=="Champawat"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Nainital" if c01_distname==""
	replace c01_stdist="0511" if c01_distname=="Nainital" & c01_stdist=="0510" 
	replace c01_stdist="0507" if c01_distname=="Champawat" & c01_stdist=="0510" 
	replace c01_distname="Pithoragarh" if c01_stdist=="0507"
	assert c01_stdist!="0510"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="0811" if c01_stdist==""
	replace x=.8393 if x==.
	replace x=.1607 if c01_stdist=="0811" & x==1 & c01_distname=="Dausa"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Jaipur" if c01_distname==""
	replace c01_stdist="0812" if c01_distname=="Jaipur" & c01_stdist=="0811" 
	replace c01_stdist="0810" if c01_distname=="Dausa" & c01_stdist=="0811" 
	replace c01_distname="Sawai Madhopur" if c01_stdist=="0810"
	assert c01_stdist!="0811"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="0913" if c01_stdist==""
	replace x=.2489 if x==.
	replace x=.7511 if c01_stdist=="0913" & x==1 & c01_distname=="Hathras"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Mathura" if c01_distname==""
	replace c01_stdist="0914" if c01_distname=="Mathura" & c01_stdist=="0913" 
	replace c01_distname="Aligarh" if c01_distname=="Hathras"
	replace c01_stdist="0912" if c01_distname=="Aligarh"
	assert c01_stdist!="0913"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="0910" if c01_stdist==""
	replace x=.5511 if x==.
	replace x=.4489 if c01_stdist=="0910" & x==1 & c01_distname=="Gautam Buddha Nagar"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Ghaziabad" if c01_distname==""
	replace c01_stdist="0909" if c01_distname=="Ghaziabad" & c01_stdist=="0910" 
	replace c01_stdist="0911" if c01_distname=="Gautam Buddha Nagar" & c01_stdist=="0910" 
	replace c01_distname="Bulandshahar" if c01_distname=="Gautam Buddha Nagar"
	assert c01_stdist!="0910"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="2013" if c01_stdist==""
	replace x=.5014 if x==.
	replace x=.4986 if c01_stdist=="2013" & x==1 & c01_distname=="Bokaro"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Giridih" if c01_distname==""
	replace c01_stdist="2006" if c01_distname=="Giridih" & c01_stdist=="2013" 
	replace c01_distname="Dhanbad" if c01_distname=="Bokaro"
	replace c01_stdist="2012" if c01_distname=="Dhanbad" 
	assert c01_stdist!="2013"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="2208" if c01_stdist==""
	replace x=.6834 if x==.
	replace x=.3166 if c01_stdist=="2208" & x==1 & c01_distname=="Kawardha"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Rajnandgaon" if c01_distname==""
	replace c01_stdist="2209" if c01_distname=="Rajnandgaon"
	replace c01_distname="Bilaspur" if c01_distname=="Kawardha"
	replace c01_stdist="2207" if c01_distname=="Bilaspur" & c01_state3=="CHH"
	assert c01_stdist!="2208"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="2403" if c01_stdist==""
	replace x=.8252 if x==.
	replace x=.1748 if c01_stdist=="2403" & x==1 & c01_distname=="Patan"
	replace rank=2 if rank==.
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Mahesana" if c01_distname==""
	replace c01_stdist="2404" if c01_distname=="Mahesana" 
	replace c01_distname="Banas Kantha" if c01_distname=="Patan"
	replace c01_stdist="2402" if c01_distname=="Banas Kantha"
	assert c01_stdist!="2403"
	assert tot_emp1!=.

	local new=_N+1
	set obs `new'
	replace c01_stdist="2914" if c01_stdist==""
	replace x=.5565 if x==.
	local new=_N+1
	set obs `new'
	replace c01_stdist="2914" if c01_stdist==""
	replace x=.2934 if x==.
	replace x=.1501 if c01_stdist=="2914" & x==1 & c01_distname=="Davanagere"
	sort c01_stdist rank 
	carryforward statename c01_state c01_state3 tot_emp1-num_firms888, replace
	replace c01_distname="Chitradurga" if c01_stdist=="2914" & x<1 & x>.4 
	replace c01_distname="Shimoga" if c01_stdist=="2914" & x>.2 & x<.3
	replace c01_distname="Bellary" if c01_stdist=="2914" & x<.2 
	replace c01_stdist="2913" if c01_distname=="Chitradurga"
	replace c01_stdist="2915" if c01_distname=="Shimoga"
	replace c01_stdist="2912" if c01_distname=="Bellary"
	assert c01_stdist!="2914"
	assert tot_emp1!=.

set more off
foreach var of varlist tot_emp1-num_firms888 {
	replace `var'=`var'*x
}
drop x rank
collapse (sum) tot_emp1-num_firms888 , by(statename-c01_distname)
unique c01_stdist
unique statename c01_state c01_state3 c01_stdist c01_distname 
gen urban=1
reshape long
drop urban
