/* Mini Example: auto.dta
   - Loads auto.dta
   - Cleans minimal
   - Descriptive stats
   - Simple regression
   - Figures export
   - Markdown report
*/


version 17.0
clear 
set more off
set linesize 120


// Project paths
global project "C:/Users/kerry/Desktop/auto-mini"
global results "$project/results"
global figures "$results/figures"
global logs    "$results/logs"

// Create output directories
foreach dir in "$results" "$figures" "$logs" {
    capture mkdir `dir'
}
capture log close
log using "$logs/auto-mini.md", replace text

statacell "### Data Preparation"
statacell 0
/*---------------------------------
Data: sysuse auto
-----------------------------------*/
* "=== Load and Clean ==="
sysuse auto, clear
disp "Loaded auto.dta. Observations: `c(N)', Variables: `c(k)'"

// Minimal cleaning
drop if missing(price, mpg, weight, foreign)
disp "Dropped missing. Remaining observations: `c(N)'"

// Generate analysis variables
gen lprice   = ln(price)
gen weightkg = weight*0.453592
label var lprice   "Log of price"
label var weightkg "Weight (kg)"
disp "Variables created: lprice, weightkg"
statacell 1


statacell "### Descriptive Statistics"
statacell "#### Table 1"
statacell 0
/*------------------------------------
Descriptive Statistics
--------------------------------------*/
summarize price mpg weight lprice
tabstat price mpg weight, by(foreign) statistics(mean sd min max n) columns(statistics)

logout3, save("$results/descriptives") replace excel html : tabstat price weight mpg headroom, statistics(n mean sd min max) columns(statistics) 

statacell 1


statacell "### Figures"
statacell "#### Figure 1"
statacell 0
/*--------------------------------
Figures
----------------------------------*/
histogram price, normal title("Price distribution")
graph2md,  replace save( "$figures/price_hist.png")   zoom(30)
statacell "#### Figure 2"
twoway (scatter price mpg) (lfit price mpg), ///
    title("Price vs MPG with linear fit") legend(order(1 "Actual" 2 "Fitted"))
graph2md,  replace save( "$figures/price_mpg.png")   zoom(30)
statacell 1



statacell "### Regression"
statacell 0
/*--------------------------------
Regression
----------------------------------*/

qui regress price mpg weight i.foreign, vce(robust)
estimates store model1
qui regress price mpg , vce(robust)
estimates store model2

qui regress price i.foreign, vce(robust)
estimates store model3

qui regress price mpg weight i.foreign, vce(robust)
estimates store model4

qui regress price mpg weight i.foreign, vce(robust)
estimates store model5

qui regress price mpg weight i.foreign, vce(robust)
estimates store model6

qui regress price mpg weight i.foreign, vce(robust)
estimates store model7

qui regress price mpg weight i.foreign, vce(robust)
estimates store model8

qui regress price mpg weight i.foreign, vce(robust)
estimates store model9

qui regress price mpg weight i.foreign, vce(robust)
estimates store model10

qui regress price mpg weight i.foreign, vce(robust)
estimates store model11

qui regress price mpg weight i.foreign, vce(robust)
estimates store model12

qui regress price mpg weight i.foreign, vce(robust)
estimates store model13

statacell  "#### Table 2"
tabhtml: esttab model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 using "$results/model.html", replace

statacell  "#### Table 3"
outreg3 [model*] using "$results/model2.tex", replace html

// statacell 1

// di `"<iframe src='$results/model.html' width='100%' height='500px' frameBorder='0'></iframe>"'

// statacell 0
// Optional: predicted values
predict price_hat, xb
statacell  "#### Figure 3"
twoway (scatter price price_hat), ///
    title("Actual vs Predicted (xb)") ///
    xtitle("Actual") ytitle("Predicted")
graph2md,  replace save( "$figures/actual_vs_pred.png") zoom(30)
statacell 1


capture log close
// statacell 0

/*--------------------------------
Report Generation
----------------------------------*/


markdown2  "$logs/auto-mini.md", saving("$results/auto-mini.md") replace html($results/auto-mini.html) clean rpath($results) 
disp "HTML report generated: $results/auto-mini.html"

// Open HTML in default browser (Windows)
sopen "" "$results/auto-mini.html"
// statacell 1