
use "$dta\gradation_EC_1998_all", clear
drop c01_town_id c01_townname sdt _merge c01_stdist c01_distname
replace district91="Imphal" if district91=="Imphal East" | district91=="Imphal West"
duplicates drop _all, force 
unique district91 state91
tempfile x
save `x'

use dist91, clear
gen state91=proper(STATE_UT)
replace state91=subinstr(state91,"_"," ",.)
replace state91="Andaman & Nicobar Islands" if state91=="Andaman & Nicobar Is"
replace state91="Karnataka" if state91=="Karnatak"
replace state91="Jammu and Kashmir" if state91=="Jammu & Kashmir"
gen district91=proper(NAME)
replace district91=subinstr(district91,"_"," ",.)
replace district91=subinstr(district91,"-"," ",.)
replace district91="DELHI (All Dists)" if district91=="Delhi"
replace district91="Leh (Ladakh)" if district91=="Ladakh"
replace district91="Dakshina Kannada" if district91=="Dakshin Kannad"
replace district91="Uttara Kannada" if district91=="Uttar Kannad"
replace district91="Greater Mumbai" if district91=="Greater Bombay"
replace district91="Dhaulpur" if district91=="Dholpur"
replace district91="24 Parganas*" if district91=="North 24 Parganas"| district91=="South 24 Parganas" | district91=="Calcutta"
replace district91="Uttarkashi" if district91=="Uttar Kashi"
replace district91="Hazaribagh" if district91=="Hazaribag"
replace district91="Purba Champaran" if district91=="Purbi Champaran"
replace district91="Junagadh" if district91=="Junagarh"
replace district91="Hisar" if district91=="Hissar"
replace district91="Ahmadabad" if district91=="Ahmedabad"
replace district91="Chhatarpur" if district91=="Chhatapur"
replace district91="Phulbani" if district91=="Phulabani"
replace district91="The Nilgiris" if district91=="Nilgiri"
replace district91="Bulandshahar" if district91=="Bulandshahr"
replace district91="West Dinajpur" if district91=="West Dinajpur"
replace district91="Mahrajganj" if district91=="Maharajganj"
replace district91="Chennai" if district91=="Madras"
replace district91="Dindigul" if district91=="Dindigul Anna"
replace district91="South Arcot" if district91=="South Arcot"
replace district91="Tiruchirappalli" if district91=="Tiruchchirappalli"
replace district91="Virudhunagar" if district91=="Kamarajar"
replace district91="Vellore" if district91=="North Arcot Ambedkar"
replace district91="Thoothukkudi" if district91=="Chidambaranar"
replace district91="Erode" if district91=="Periyar"
replace district91="Sivaganga" if district91=="Pasumpon Thevar Thir"
replace district91="Tirunelveli" if district91=="Tirunelveli Kattabo"
replace district91="Tiruvannamalai" if district91=="Tiruvannamalai Sambu"
replace district91="Chengalpattu MGR" if district91=="Chengai Anna"
merge m:m state91 district91 using `x'
save "newmap_wBD91.dta", replace

use "newmap_wBD91.dta", clear
assert weightedcountindex==. if _merge!=3
drop if weightedcountindex==.
assert _merge==3
gen backwarddist=1 if policy==1 | policy==2
replace backwarddist=0 if backwarddist==.
drop if weightedcountindex>500 & backwarddist==1 
label define bd2 1 "Backward" 0 "Non-backward" 
label val backwarddist bd2
spmap backwarddist using dist91_coord, id(id) clmethod(unique) fcolor(white gs4) //whole map 
preserve
keep if STATE_UT=="MADHYA_PRADESH"
spmap backwarddist using dist91_coord, id(id) clmethod(unique) fcolor(white gs4) ///
title("Madhya Pradesh", size(*0.8)) legend(cols(2))
graph save MP, replace
restore

preserve
keep if STATE_UT=="RAJASTHAN"
spmap backwarddist using dist91_coord, id(id) clmethod(unique) fcolor(white gs4) ///
title("Rajasthan", size(*0.8)) legend(cols(2))
graph save RAJ, replace
restore