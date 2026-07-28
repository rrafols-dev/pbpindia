set more off
use "$td1991\td1991", clear
rename state statename
rename district distname
drop if statename==""
drop SLNO townname tehsil
duplicates drop _all, force
keep rail_dist statename distname pop1991 Areasqkm sh_dist city_dist tot_rev tot_exp banks arts science commerce medical engg law polytech medical n_a_c_soc el_dom el_ind el_com total_roadlength avg_rain min_temp max_temp
	replace distname="24 Parganas*" if statename=="West Bengal" & distname=="Calcutta"
	replace distname="24 Parganas*" if distname=="Barasat" & statename=="West Bengal"
	replace distname="24 Parganas*" if distname=="Alipore" & statename=="West Bengal"
	replace distname="West Khasi Hills" if distname=="Nongstoin" & statename=="Meghalaya"
	replace distname="East Khasi Hills" if distname=="Shillong" & statename=="Meghalaya"
	replace distname="Jaintia Hills" if distname=="Jowai" & statename=="Meghalaya"
	replace distname="East Garo Hills" if distname=="Williamnagar" & statename=="Meghalaya"
	replace distname="West Garo Hills" if distname=="Tura" & statename=="Meghalaya"
	replace distname="Mayurbhanj" if distname=="Baripada" & statename=="Orissa"
	replace distname="Ganjam" if distname=="Chhatrapur" & statename=="Orissa"
	replace distname="Kalahandi" if distname=="Bhawanipatna" & statename=="Orissa"
	replace distname="Nadia" if distname=="Krishnanagar" & statename=="West Bengal"
	replace distname="Murshidabad" if distname=="Baharampur" & statename=="West Bengal"
	replace distname="Birbhum" if distname=="Suri" & statename=="West Bengal"
	replace distname="Hugli" if distname=="Chinsurah" & statename=="West Bengal"
	replace distname="West Dinajpur" if distname=="Balurghat" & statename=="West Bengal"
	replace distname="Maldah" if distname=="English Bazar" & statename=="West Bengal"
	replace distname="Sindhudurg" if distname=="Kudal" & statename=="Maharashtra"
	replace distname="Raigarh" if distname=="Alibag" & statename=="Maharashtra"
	replace distname="East Nimar" if distname=="Khandwa" & statename=="Madhya Pradesh"
	replace distname="Bastar" if distname=="Jagdalpur" & statename=="Madhya Pradesh"
	replace distname="Surguja" if distname=="Ambikapur" & statename=="Madhya Pradesh"
	replace distname="West Nimar" if distname=="Khargone" & statename=="Madhya Pradesh"
	replace distname="Sabar Kantha" if distname=="Himatnagar" & statename=="Gujarat"
	replace distname="The Dangs" if distname=="Ahwa" & statename=="Gujarat"
	replace distname="Panch Mahals" if distname=="Godhra" & statename=="Gujarat"
	replace distname="Kachchh" if distname=="Bhuj" & statename=="Gujarat"
	replace distname="Banas Kantha" if distname=="Palanpur" & statename=="Gujarat"
	replace distname="Rohtas" if distname=="Sasaram" & statename=="Bihar"
	replace distname="Bhojpur" if distname=="Arrah" & statename=="Bihar"
	replace distname="Purba Champaran" if distname=="Motihari" & statename=="Bihar"	
	replace distname="Saran" if distname=="Chapra" & statename=="Bihar"	
	replace distname="Pashchim Champaran" if distname=="Betia" & statename=="Bihar"	
	replace distname="Pashchimi Singhbhum" if distname=="Chaibasa" & statename=="Bihar"	
	replace distname="Palamu" if distname=="Daltonganj" & statename=="Bihar"	
	replace distname="Purbi Singhbhum" if distname=="Jamshedpur" & statename=="Bihar"	
	replace distname="Vaishali" if distname=="Hajipur" & statename=="Bihar"	
	replace distname="Sonitpur" if distname=="Tezpur" & statename=="Assam"
	replace distname="Karbi Anglong" if distname=="Diphu" & statename=="Assam"
	replace distname="North Cachar Hills" if distname=="Haflong" & statename=="Assam"
	replace distname="Cachar" if distname=="Silchar" & statename=="Assam"
	replace distname="Kamrup" if distname=="Guwahati" & statename=="Assam"
	replace distname="Sonitpur" if distname=="Tezpur" & statename=="Assam"
	replace distname="Darrang" if distname=="Mangaldoi" & statename=="Assam"
	replace distname="East Siang" if distname=="Pasighat" & statename=="Arunachal Pradesh"
	replace distname="West Siang" if distname=="Along" & statename=="Arunachal Pradesh"
	replace distname="Lower Subansiri" if distname=="Ziro" & statename=="Arunachal Pradesh"
	replace distname="West Kameng" if distname=="Bomdila" & statename=="Arunachal Pradesh"
	replace distname="Tirap" if distname=="Khonsa" & statename=="Arunachal Pradesh"
	replace distname="Lohit" if distname=="Tezu" & statename=="Arunachal Pradesh"
	replace distname="Dibang Valley" if distname=="Anini" & statename=="Arunachal Pradesh"
	replace distname="Krishna" if distname=="Machilipatnam" & statename=="Andhra Pradesh"
	replace distname="East Godavari" if distname=="Kakinada" & statename=="Andhra Pradesh"
	replace distname="Medak" if distname=="Sangareddy" & statename=="Andhra Pradesh"
	replace distname="West Godavari" if distname=="Eluru" & statename=="Andhra Pradesh"
	replace distname="Prakasam" if distname=="Ongole" & statename=="Andhra Pradesh"
	replace distname="DELHI (All Dists)" if distname=="Tis Hazari Delhi" & statename=="Delhi"
	replace distname="South Goa" if distname=="Margao" & statename=="Goa"
	replace distname="North Goa" if distname=="Panaji" & statename=="Goa"
	replace distname="Lakshadweep" if distname=="Kavaratti" & statename=="Lakshadweep"
	replace distname="Greater Mumbai" if distname=="Gr.Bombay" & statename=="Maharashtra"
	replace distname="Phulbani" if distname=="Phulabani" & statename=="Orissa"
	replace distname="South" if distname=="Namchi" & statename=="Sikkim"
	replace distname="East" if distname=="Gangtok" & statename=="Sikkim"
	replace distname="North" if distname=="Mangan" & statename=="Sikkim"
	replace distname="West" if distname=="Gyalshing" & statename=="Sikkim"
	replace distname="Mahendragarh" if distname=="Narnaul" & statename=="Haryana"	
	replace distname="Wayanad" if distname=="Kalpetta" & statename=="Kerala"
	replace distname="Thiruvananthapuram" if distname=="Trivandrum" & statename=="Kerala"
	replace distname="Ernakulam" if distname=="Kochi" & statename=="Kerala"
	replace	distname="Dakshina Kannada" if distname=="Mangalore" & statename=="Karnataka"
	replace	distname="Uttara Kannada" if distname=="Karwar" & statename=="Karnataka"
	replace distname="Kangra" if distname=="Kangra at Dharamsala" & statename=="Himachal Pradesh"		
	replace distname="Sirmaur" if distname=="Nahan" & statename=="Himachal Pradesh"	
	replace distname="Chennai" if distname=="Madras" & statename=="Tamil Nadu"
	replace distname="Virudhunagar" if distname=="Virudunagar" & statename=="Tamil Nadu"
	replace distname="Chengalpattu MGR" if distname=="Kanchipuram" & statename=="Tamil Nadu"
	replace distname="The Nilgiris" if distname=="Udhagamandalam" & statename=="Tamil Nadu"
	replace distname="Kanniyakumari" if distname=="Nagercoil" & statename=="Tamil Nadu"
	replace distname="South Arcot" if distname=="Cuddalore" & statename=="Tamil Nadu"
	replace distname="Thoothukkudi" if distname=="Tuticorin" & statename=="Tamil Nadu"
	replace distname="Bulandshahar" if distname=="Bulandshahr" & statename=="Uttar Pradesh"
	replace distname="Mahrajganj" if distname=="Maharajganj" & statename=="Uttar Pradesh"
	replace distname="Mau" if distname=="Maunath Bhanjan" & statename=="Uttar Pradesh"
	replace distname="Chamoli" if distname=="Chamoli Gopeshwar" & statename=="Uttar Pradesh"
	replace distname="Farrukhabad" if statename=="Uttar Pradesh" & distname=="Fatehgarh"
	replace distname="Jalaun" if statename=="Uttar Pradesh" & distname=="Orai"	
	replace distname="Kheri" if statename=="Uttar Pradesh" & distname=="Lakhimpur"
	replace distname="Tehri Garhwal" if statename=="Uttar Pradesh" & distname=="New Tehri"
	replace distname="Garhwal" if statename=="Uttar Pradesh" & distname=="Pauri"
	replace distname="Andamans" if statename=="Andaman & Nicobar Islands" & distname=="Port Blair"
	replace distname="Dadra & Nagar Haveli" if distname=="Silvassa" & statename=="Dadra & Nagar Haveli"
	replace distname="West Tripura" if distname=="Agartala" & statename=="Tripura"
	replace distname="North Tripura" if distname=="Kailasahar" & statename=="Tripura"
	rename min_temp max_temp2
	rename max_temp min_temp
	rename max_temp2 max_temp
collapse (mean) avg_rain (max) max_temp (min) min_temp sh_dist city_dist rail_dist (sum) pop1991 tot_rev tot_exp banks n_a_c_soc polytech arts science commerce medical engg law el_dom el_ind el_com total_roadlength Areasqkm, by(statename distname)
	gen lpop1991=log(pop1991)
	gen ldensity1991=log(pop1991/Areasqkm)
	egen bankcs_tot=rowtotal(banks n_a_c_soc)
	egen el_tot=rowtotal(el_dom el_ind el_com)
	egen educinst_total=rowtotal(polytech arts science commerce medical engg law)
	gen govern_ratio=tot_rev/tot_exp 
	drop polytech arts science commerce medical engg law banks n_a_c_soc el_dom el_ind el_com
	replace max_temp=. if min_temp==176.5
	replace min_temp=. if max_temp==1136.6
	label var city_dist "Distance in Km. To Nearest Large City"
	label var sh_dist "Distance in Km. To State Head Quarters"
	label var total_roadlength "Total road length (km)"
	label var avg_rain "Average Rainfall in Millimetres"
	label var max_temp "Maximum temperature in Centigrade"
	label var min_temp "Minimum temperature in Centigrade"
	label var bankcs_tot "Total number of banks and non-agricultural credit societies"	
	label var el_tot "Total number of electricity connections (domestic, industrial, commercial)"
	label var educinst_total "Total number of educational institutions"
	label var Areasqkm "Area in sq km"
	label var pop1991 "1991 District Population"
	label var lpop1991 "Log Population, 1991"
	label var ldensity1991 "Log Density, 1991"
	label var govern_ratio "Town revenue to expense ratio"
	label var rail_dist "Distance in Km. To Railway"


/*
use "$score\gradation_EC_1998_all", clear
drop c01_town_id c01_townname sdt statename _merge c01_stdist c01_distname statename
unique state91 district91 // 464
rename state91 statename
rename district91 distname
replace distname="Imphal" if distname=="Imphal East" | distname=="Imphal West"
duplicates drop _all, force
merge 1:1 statename distname using `x'
rename _merge mergeTD
*/
