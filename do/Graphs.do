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
	forval i=1(40)1500{
		replace rdplot_mean_x=`i' if w>=`i' & w<=`i'+50
	}
	bys rdplot_mean_x: egen rdplot_mean_y=mean(`var')
	qui lpoly `var' w if w<=500, tri deg(1) bw(200) se(u1) gen(x1 y1)
	qui lpoly `var' w if w>500 & w<=13000, tri deg(1) bw(200) se(u2) gen(x2 y2)
	gen x1l=y1+1.96*u1
	gen x1u=y1-1.96*u1
	gen x2l=y2+1.96*u2
	gen x2u=y2-1.96*u2
	twoway (scatter rdplot_mean_y rdplot_mean_x if rdplot_mean_x>=0 & rdplot_mean_x<=1520, msymbol(Oh) mlcolor() xline(500)) ///
	 (line y1 x1 if x1>=0 & x1<=1520, lcolor(black) connect(direct) lpattern(solid) lw(medthick)) ///
	 (line x1l x1 if x1>=0 & x1<=1520, lcolor(gs3) lpattern(dash)) ///
	 (line x1u x1 if x1>=0 & x1<=1520, lcolor(gs3) lpattern(dash)) ///
	 (line y2 x2 if x2>=0 & x2<=1520, lcolor(bl50ack) connect(direct) lpattern(solid) lw(medthick)) ///
	 (line x2l x2 if x2>=0 & x2<=1520, lcolor(gs3) lpattern(dash)) ///
	 (line x2u x2 if x2>=0 & x2<=1520, lcolor(gs3) lpattern(dash)), legend(off) xsc(range (0 1500)) ylabel(,angle(0) labsize(small)) ///
	  xlabel(0(250)1500, angle(0) labsize(small)) xtitle("Gradation Scores", size(small)) ytitle("`d'", size(small)) ///
	  subtitle("`j`f''", size(medium)) scheme(s1mono) saving(a`f', replace)
	local f=`f'+1
	drop rdplot_mean_x-x2u
}
graph combine a1.gph a2.gph a3.gph a4.gph a5.gph a6.gph, cols(2) commonscheme scheme(s1mono)  ///
 ysize(8) note("Source: 1998 India Economic Census", size(1.75))
graph export Fig3.png, replace
