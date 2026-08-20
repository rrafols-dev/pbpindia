Replication package for "Place-based preferential tax policy and industrial development: Evidence from India’s program on industrially backward districts". 
Rana Hasan, Yi Jiang, and Radine Rafols

## Restricted Data
The enterprise-level Economic Census files are non-public use files and cannot be
shared. They are referenced but must be supplied by the user. Access is with MOSPI:
```
    ec1998_data_urb   ec1998_data_rur   ec1998_urb_dir   ec1998_dir_rur_sdt
    ec2005_data_urb   ec2005_data_rur   ec2005_urb_dir   ec2005_dir_rur_sdt
```


## File tree

```
pbpindia/
├── README.md
├── do/
│   ├── create_collapsed_ec1998.do          8,685    raw EC1998 -> district x industry
│   ├── create_collapsed_ec2005.do          3,129    raw EC2005 -> district x industry
│   ├── nic87_incexempt.do                  2,843    1987 NIC policy-coverage tagging
│   ├── nic87_incexempt1.do                 1,613
│   ├── nic87_incexempt2.do                   863
│   ├── nic04_incexempt1.do                   263    2004 NIC policy-coverage tagging
│   ├── addtd1991.do                       10,213    town directory 1991
│   ├── districtindustry_01to91borders.do   5,946    2001 -> 1991 district borders
│   ├── create_itp_conag.do                 5,626    -> itpdata_conser / itpdata_agress
│   ├── create_itp_nosmall.do               5,486    -> itpdata_nosmall
│   ├── create_itp_formal.do                4,725    -> itp_formal (1998)
│   ├── create_itp_jde.do                  10,250    -> itp_jde
│   ├── create_itp_ec2005.do               13,385    -> ITP_ec2005_noIO(_new)
│   ├── create_itp_formal05.do              7,431    -> itp_formal05_new
│   ├── create_dataforgraphs.do            10,711    -> dataforgraphs
│   ├── results_tables.do                  20,010    main tables
│   ├── Descstat_Table2.do                 10,092    descriptives
│   ├── Appendix.do                         8,417
│   ├── SuppApp.do                          9,260
│   ├── Graphs.do                           2,267
│   ├── histogram.do                          803
│   └── state_map.do                        3,672    maps; needs dist91 + dist91_coord
└── dta/
    ├── supplied inputs
    │   ├── ITP_BD_neighbor.dta                244,909
    │   ├── ITP_OverlappingPolicies.xls        105,472
    │   ├── gradation_EC_1998_all.dta        1,003,128
    │   ├── itp_pca1991.dta                    528,824
    │   ├── td1991.dta                       4,633,083
    │   ├── Matrix Construction2.xls         2,029,056    IO matrix
    │   ├── Matrix Construction3.xls         2,091,520
    │   ├── dist_nochange91.dta                 52,737
    │   ├── dist91.dta                         166,474    1991 district attributes (STATE_UT)
    │   └── dist91_coord.dta                29,247,370    1991 district polygons, for spmap
    ├── built by the codes in "/do" folder
    │   ├── ec1998_dist_ind98.dta            7,163,082
    │   ├── ec1998_dist_ind98_1.dta          7,163,082
    │   ├── ec1998_dist_ind98_2.dta          7,163,082
    │   ├── ec1998_dist_ind98_nosmall_1.dta  7,163,082
    │   ├── ec1998_dist_rf1_ind98.dta        6,859,764
    │   ├── ec2005_dist_ind1.dta             5,619,432
    │   ├── ec2005_dist_ind1_rf.dta          5,619,432
    │   ├── ITP_ec2005_noIO.dta             37,398,304
    │   ├── ITP_ec2005_noIO_new.dta          5,428,470
    │   ├── itp_formal.dta                  47,227,488
    │   ├── itp_formal05_new.dta             6,186,510
    │   ├── itp_jde.dta                     31,161,818
    │   ├── itpdata_conser.dta              36,822,059
    │   ├── itpdata_agress.dta              36,822,059    ## see note below
    │   ├── itpdata_nosmall.dta             36,822,059
    │   └── dataforgraphs.dta               41,649,711
    └── (no unreferenced files)
```

## Note: the conservative / aggressive switch:

`create_itp_conag.do` builds both variants from one script, and says so in place:
line 105 records that `ec1998_dist_ind98_2.dta` gives the conservative definition and
the unsuffixed `ec1998_dist_ind98.dta` gives the aggressive one, and line 167 records
the matching output name. Running it as shipped yields `itpdata_conser.dta`; to get
`itpdata_agress.dta` the user swaps those two lines. 

## Set Directory
```
* ---- the only line you need to edit -----------------------------------------
global root "<user main folder here>"


* -----------------------------------------------------------------------------
global do     "$root\do"
global dta    "$root\dta"
global outreg "$root\output"

global score  "$dta"
global td1991 "$dta"

capture mkdir "$outreg"

```
