
**1 to 1000 <<< Paper Ready Figure>>>

 ******LPOLY
cd "$outreg"
use "$outreg\dataforgraphs.dta", clear
 *generate mean per bandwith:
label var tot_emp_oi "Employment (log)"
label var tot_emp_cm "Employment (log)" 
label var tot_emp_lm "Employment (log)"
label var num_firms_oi "Number of Firms (log)" 
label var num_firms_cm "Number of Firms (log)"
label var num_firms_lm "Number of Firms (log)"
gen w=weightedcountindex

set more off
local i=1
local f=1
local j1 "Light Manufacturing"
local j2 "Light Manufacturing"
local j3 "Heavy Manufacturing" 
local j4 "Heavy Manufacturing"
local j5 "Other Industries"
local j6 "Other Industries" 
local j7 "Other Industries" 
foreach var of varlist num_firms_lm tot_emp_lm num_firms_cm tot_emp_cm num_firms_oi tot_emp_oi {
	local d: variable label `var'
	gen rdplot_mean_x=.
	set more off
	forval i=351(20)650{
		replace rdplot_mean_x=`i' if w>=`i' & w<=`i'+50
	}
	bys rdplot_mean_x: egen rdplot_mean_y=mean(`var')
	lpoly `var' w if w>350 & w<=500, tri deg(4) bw(50) se(u1) gen(x1 y1)
	lpoly `var' w if w>500 & w<=650, tri deg(4) bw(50) se(u2) gen(x2 y2)
	gen x1l=y1+1.96*u1
	gen x1u=y1-1.96*u1
	gen x2l=y2+1.96*u2
	gen x2u=y2-1.96*u2
	twoway (scatter rdplot_mean_y rdplot_mean_x if rdplot_mean_x>=350 & rdplot_mean_x<=650, msymbol(Oh) mlcolor() xline(500)) ///
	 (line y1 x1 if x1>=350 & x1<=500, lcolor(black) connect(direct) lpattern(solid) lw(medthick)) ///
	 (line x1l x1 if x1>=350 & x1<=500, lcolor(gs3) lpattern(dash)) ///
	 (line x1u x1 if x1>=350 & x1<=500, lcolor(gs3) lpattern(dash)) ///
	 (line y2 x2 if x2>=500 & x2<=650, lcolor(bl50ack) connect(direct) lpattern(solid) lw(medthick)) ///