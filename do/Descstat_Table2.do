*************************
*Descriptive Statistics
*************************
*pick1:
global outreg "H:\Desktop\ITP\JDE"

set more off
use "H:\Desktop\ITP\itp_Restat.dta", clear // contains final data for paper
drop if weightedcountindex>500 & backwarddist==1
*replace weightedcountindex=250 if weightedcountindex>500 & backwarddist==1

gen sgroup1=1 if weightedcountindex<=250
gen sgroup2=1 if weightedcountindex>=251 & weightedcountindex<=350
gen sgroup3=1 if weightedcountindex>=351 & weightedcountindex<=500
gen sgroup4=1 if weightedcountindex>=501 & weightedcountindex<=650
gen sgroup5=1 if weightedcountindex>=651 & weightedcountindex<=850
gen sgroup6=1 if weightedcountindex>=851

gen did1=1 if industry>=1 & industry<=6
gen did2=1 if industry>=10 & industry<=19
gen did3=1 if industry>=20 & industry<=27
replace did3=1 if industry==29
gen did4=1 if industry>=30 & industry<=38
replace did4=1 if industry==28
gen did5=1 if industry>=40 & industry<=43
gen did6=1 if industry==50 | industry==51
gen did7=1 if industry>=60 & industry<=69
gen did8=1 if industry>=70 & industry<=75
gen did9=1 if industry>=80 & industry<=85
replace did9=1 if industry==89
gen did10=1 if industry>=90 & industry<=99
gen did11=1 if industry==888
gen did12=1 if industry==39

label var did1 "Agriculture, hunting, forestry, and fishing"
label var did2 "Mining and quarrying"
label var did3 "Labor-intensive Manufacturing"
label var did4 "Capital-intensive Manufacturing"
label var did5 "Electricity, Gas and Water"
label var did6 "Construction"
label var did7 "Wholesale trade and retail trade and restaurants and hotels"
label var did8 "Transport, storage, and communication"
label var did9 "Financing, insurance, real estate and business services"
label var did10 "Community, social and personal services"
label var did11 "Excluded manufacturing"
label var did12 "Repair of capital goods"

/**num_firms and tot_emp total:
gen g=1 if sgroup1==1
forval i=2/6{
 replace g=`i' if sgroup`i'==1
}
keep if did3==1 | did4==1
collapse (sum) num_firms tot_emp, by(g industry)
reshape wide num_firms tot_emp, i(industry) j(g)
*/
foreach x in "num_firms" "tot_emp" {
	gen oth_`x'=`x' if did3!=1 & did4!=1 
	gen lm_`x'=`x' if did3==1
	gen hm_`x'=`x' if did4==1
}

cd "$outreg"
set more off
set matsize 11000
forval i=0/1 {
	preserve
	keep if backwarddist==`i'
	keep oth_num_firms  lm_num_firms hm_num_firms oth_tot_emp  lm_tot_emp hm_tot_emp
	outreg2 using "$outreg\sumdist_bd`i'.xls", replace sum(log) 
	restore
}


cd "$outreg"
set more off
set matsize 11000
forval i=1/6 {
	preserve
	keep if sgroup`i'==1
	keep oth_num_firms  lm_num_firms hm_num_firms oth_tot_emp  lm_tot_emp hm_tot_emp
	outreg2 using "$outreg\sumdist_grp`i'.xls", replace sum(log) 
	restore
}


****************1998
set more off
use "H:\Desktop\ITP\JDE\itp_formal.dta", clear
drop if _merge==2
drop if weightedcountindex>500 & backwarddist==1


gen sgroup1=1 if weightedcountindex<=250
gen sgroup2=1 if weightedcountindex>=251 & weightedcountindex<=350
gen sgroup3=1 if weightedcountindex>=351 & weightedcountindex<=500
gen sgroup4=1 if weightedcountindex>=501 & weightedcountindex<=650
gen sgroup5=1 if weightedcountindex>=651 & weightedcountindex<=850
gen sgroup6=1 if weightedcountindex>=851

gen did1=1 if industry>=1 & industry<=6
gen did2=1 if industry>=10 & industry<=19
gen did3=1 if industry>=20 & industry<=27
replace did3=1 if industry==29
gen did4=1 if industry>=30 & industry<=38
replace did4=1 if industry==28
gen did5=1 if industry>=40 & industry<=43
gen did6=1 if industry==50 | industry==51
gen did7=1 if industry>=60 & industry<=69
gen did8=1 if industry>=70 & industry<=75
gen did9=1 if industry>=80 & industry<=85
replace did9=1 if industry==89
gen did10=1 if industry>=90 & industry<=99
gen did11=1 if industry==888
gen did12=1 if industry==39

label var did1 "Agriculture, hunting, forestry, and fishing"
label var did2 "Mining and quarrying"
label var did3 "Labor-intensive Manufacturing"
label var did4 "Capital-intensive Manufacturing"
label var did5 "Electricity, Gas and Water"
label var did6 "Construction"
label var did7 "Wholesale trade and retail trade and restaurants and hotels"
label var did8 "Transport, storage, and communication"
label var did9 "Financing, insurance, real estate and business services"
label var did10 "Community, social and personal services"
label var did11 "Excluded manufacturing"
label var did12 "Repair of capital goods"

replace num_firms=Sh_R_firms
replace tot_emp=Sh_R_emp
/* Please show for all districts, all backward districts, all non-backward districts, group 3, group 4*/
tabstat num_firms tot_emp, stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp, by(backwarddist) stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp if sgroup3==1,  stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp if sgroup4==1,  stat(N mean sd min p5 p25 p50 p75 p95 max)

foreach x in "num_firms" "tot_emp" {
	gen oth_`x'=`x' if did3!=1 & did4!=1 
	gen lm_`x'=`x' if did3==1
	gen hm_`x'=`x' if did4==1
}
/*, group 3*light manufacturing, group 3*heavy manufacturing, group 3*ineligible industries, group 4*light manufacturing, 
group 4*heavy manufacturing, and group 4*ineligible industries.*/
tabstat lm_num_firms lm_tot_emp hm_num_firms hm_tot_emp oth_num_firms oth_tot_emp if sgroup3==1, stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat lm_num_firms lm_tot_emp hm_num_firms hm_tot_emp oth_num_firms oth_tot_emp if sgroup4==1, stat(N mean sd min p5 p25 p50 p75 p95 max)



cd "$outreg"
set more off
set matsize 11000
forval i=0/1 {
	preserve
	keep if backwarddist==`i'
	keep  lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_bd`i'.xls", replace sum(log) 
	restore
}


cd "$outreg"
set more off
set matsize 11000
forval i=1/6 {
	preserve
	keep if sgroup`i'==1
	keep lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_grp`i'.xls", replace sum(log) 
	restore
}


****************2005
set more off 
use "H:\Desktop\ITP\JDE\itp_formal05_new.dta", clear
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2
replace did4=1 if industry==26 | industry==28
replace did3=0 if industry==26 | industry==28
*replace Sh_R_firms=0 if Sh_R_firms==.
*replace Sh_R_emp=0 if Sh_R_emp==.

gen sgroup1=1 if weightedcountindex<=250
gen sgroup2=1 if weightedcountindex>=251 & weightedcountindex<=350
gen sgroup3=1 if weightedcountindex>=351 & weightedcountindex<=500
gen sgroup4=1 if weightedcountindex>=501 & weightedcountindex<=650
gen sgroup5=1 if weightedcountindex>=651 & weightedcountindex<=850
gen sgroup6=1 if weightedcountindex>=851

replace num_firms=Sh_R_firms
replace tot_emp=Sh_R_emp
/* Please show for all districts, all backward districts, all non-backward districts, group 3, group 4*/
tabstat num_firms tot_emp, stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp, by(backwarddist) stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp if sgroup3==1,  stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat num_firms tot_emp if sgroup4==1,  stat(N mean sd min p5 p25 p50 p75 p95 max)


foreach x in "num_firms" "tot_emp" {
	gen oth_`x'=`x' if did3!=1 & did4!=1 
	gen lm_`x'=`x' if did3==1
	gen hm_`x'=`x' if did4==1
}
/*, group 3*light manufacturing, group 3*heavy manufacturing, group 3*ineligible industries, group 4*light manufacturing, 
group 4*heavy manufacturing, and group 4*ineligible industries.*/
tabstat lm_num_firms lm_tot_emp hm_num_firms hm_tot_emp oth_num_firms oth_tot_emp if sgroup3==1, stat(N mean sd min p5 p25 p50 p75 p95 max)
tabstat lm_num_firms lm_tot_emp hm_num_firms hm_tot_emp oth_num_firms oth_tot_emp if sgroup4==1, stat(N mean sd min p5 p25 p50 p75 p95 max)


cd "$outreg"
set more off
set matsize 11000
forval i=0/1 {
	preserve
	keep if backwarddist==`i'
	keep  lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_bd`i'_05.xls", replace sum(log) 
	restore
}


cd "$outreg"
set more off
set matsize 11000
forval i=1/6 {
	preserve
	keep if sgroup`i'==1
	keep lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_grp`i'_05.xls", replace sum(log) 
	restore
}


**************************
set more off
use "H:\Desktop\ITP\JDE\ITP_ec2005_noIO_new.dta", clear
replace lnum_firms2=0 if lnum_firms2==.
replace ltot_emp2=0 if ltot_emp2==.
*Rescale score
drop w1 
gen w1=(weightedcountindex/500)-1
replace w2=w1^2

gen sgroup1=1 if weightedcountindex<=250
gen sgroup2=1 if weightedcountindex>=251 & weightedcountindex<=350
gen sgroup3=1 if weightedcountindex>=351 & weightedcountindex<=500
gen sgroup4=1 if weightedcountindex>=501 & weightedcountindex<=650
gen sgroup5=1 if weightedcountindex>=651 & weightedcountindex<=850
gen sgroup6=1 if weightedcountindex>=851

foreach x in "num_firms" "tot_emp" {
	gen oth_`x'=`x' if did3!=1 & did4!=1 
	gen lm_`x'=`x' if did3==1
	gen hm_`x'=`x' if did4==1
}

/*num_firms and tot_emp total:
gen g=1 if sgroup1==1
forval i=2/6{
 replace g=`i' if sgroup`i'==1
}
keep if did3==1 | did4==1
collapse (sum) num_firms tot_emp, by(g industry did3 did4)
reshape wide num_firms tot_emp, i(industry) j(g)
*/

cd "$outreg"
set more off
set matsize 11000
forval i=0/1 {
	preserve
	keep if backwarddist==`i'
	keep  lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_bd`i'_05.xls", replace sum(log) 
	restore
}


cd "$outreg"
set more off
set matsize 11000
forval i=1/6 {
	preserve
	keep if sgroup`i'==1
	keep lm_num_firms hm_num_firms  oth_num_firms   lm_tot_emp hm_tot_emp oth_tot_emp
	outreg2 using "$outreg\sumdist_grp`i'_05.xls", replace sum(log) 
	restore
}
