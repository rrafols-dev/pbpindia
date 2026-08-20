gen tag=.
replace tag=1 if nic=="1551"
replace tag=1 if nic=="1552"
replace tag=1 if nic=="1553"
replace tag=1 if nic=="1600"
replace tag=1 if nic=="2424"
replace tag=1 if nic=="1554"
replace tag=1 if nic=="1543"
replace tag=1 if nic=="3320"
tab tag, m
