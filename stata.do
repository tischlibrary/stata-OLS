version 13
capture log close
log using "your_path\tischstata\stata.log", replace

/* Intro Stata Workshop / Tisch Library*/
/* Syntax for the Tisch intro Stata wksp */
/* written by Josh Q. */
/* Spring 2016 */


/* clear previous data from memory, print and change working directory */

set more off
cd "your_path\tischstata"
ls

/* baby names dataset */
import delimited using bnames.csv, clear
drop v6

rename v1 year
rename v2 name
rename v3 prop
rename v4 sex
rename v5 soundex

list if missing(prop)

replace prop = .01 if name == "Kilgore" & year == 2008

drop in 258001

gen perc = prop * 100

sum
sum perc, detail
codebook

tabulate year sex

gsort -perc

list if name == "Joshua"
list if year == 1985 

/* line chart of name popularity over time*/

sort year
twoway (line perc year if name == "Joshua") ///
(line perc year if name == "Jacob"), ///
title("Popularity of Joshua and Jacob (1880-2008)") ///
legend(on order(1 "Joshua" 2 "Jacob"))

sort year
twoway (scatter perc year if name == "Joshua") ///
(scatter perc year if name == "Jacob"), ///
title("Popularity of Joshua and Jacob (1880-2008)") ///
legend(on order(1 "Joshua" 2 "Jacob"))

sort year
twoway (scatter perc year if name == "Joshua"), by(sex)

sort year
twoway (line perc year if name == "Joshua" & sex == "boy") ///
(line perc year if name == "Jacob"), ///
title("Popularity of Joshua and Jacob (1880-2008)") ///
legend(on order(1 "Joshua" 2 "Jacob"))


/*crime dataset */
use crime.dta, clear

scatter tc2009 low
scatter tc2009 low, mlabel(state)
regress tc2009 low
predict fitted
twoway (scatter tc2009 low) (line fitted low)

/* residual plot */
rvfplot

/* heights data set*/

use heights.dta, clear

regress earn height

predict fitted
twoway (scatter earn height) (line fitted height)
scatter earn height || lfit earn height

/* why doesn't this work? */
regress earn gender

/* gender needs to be coded numerically */
gen female = 0
replace female = 1 if gender == "female"

gen male = 0
replace male = 1 if gender == "male"

/* the xi command will automatically create categorical variables */
xi: regress earn i.gender

regress earn female
regress earn male
regress earn female height

/*show linear fit line by gender */
scatter earn height || lfit earn height || , by(female)


/*regress on education, height and female*/
regress earn height ed female

/*outreg2*/
outreg2 using table.doc, ctitle(Model1) label

/* close the log*/
log close

