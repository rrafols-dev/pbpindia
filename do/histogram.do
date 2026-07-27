set more off
use "$dta\itp_jde.dta", clear
tab weightedcountindex, m
unique state91 dist91  //357
drop if weightedcountindex>9000 //3 districts
unique state91 dist91  //354
unique state91 dist91 if weightedcountindex>=0 & weightedcountindex<=1000 //216
unique state91 dist91 if weightedcountindex>=251 & weightedcountindex<=850 //162
twoway (hist weightedcountindex, xline(500) width(20)) || kdensity weightedcountindex, xlabel(0(100)1000) xsc(range(0(100)1000)) bw(40)

*Figure2:
twoway hist weightedcountindex if weightedcountindex>=0 & weightedcountindex<=6000, width(20) xline(500) xsc(range(0(500)6000)) || kdensity weightedcountindex if weightedcountindex>=0 & weightedcountindex<=6000, ///
xlabel(0(500)6000) bw(40) scheme(s1mono) legend(off)  xtitle("Gradation Scores", size(small)) 