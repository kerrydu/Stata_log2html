### Data Preparation
```
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
```
### Descriptive Statistics
#### Table 1
```
summarize price mpg weight lprice

tabstat price mpg weight, by(foreign) statistics(mean sd min max n) columns(statistics)

outreg3  using "$results/summary.tex", replace html sum(log)
```
<iframe src='./summary.html' width='100%' height='600px' frameBorder='0'></iframe>
### Figures
#### Figure 1
```
/*--------------------------------
Figures
----------------------------------*/
histogram price, normal title("Price distribution")
graph2md,  replace save( "$figures/price_hist.png")   zoom(30)
```
<img src="./figures/price_hist.png" style="zoom:30%;" />
#### Figure 2
```
twoway (scatter price mpg) (lfit price mpg), ///
    title("Price vs MPG with linear fit") legend(order(1 "Actual" 2 "Fitted"))
graph2md,  replace save( "$figures/price_mpg.png")   zoom(30)
```
<img src="./figures/price_mpg.png" style="zoom:30%;" />
### Regression
```
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
```
#### Table 2
```
tabhtml: esttab model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 using "$results/model.html", replace
```
<iframe src='./model.html' width='100%' height='500px' frameBorder='0'></iframe>
#### Table 3
```
outreg3 [model*] using "$results/model2.tex", replace html
```
<iframe src='./model2.html' width='100%' height='600px' frameBorder='0'></iframe>
#### Figure 3
```
predict price_hat, xb
twoway (scatter price price_hat), ///
    title("Actual vs Predicted (xb)") ///
    xtitle("Actual") ytitle("Predicted")
graph2md,  replace save( "$figures/actual_vs_pred.png") zoom(30)
```
<img src="./figures/actual_vs_pred.png" style="zoom:30%;" />
### Report Generation
```


markdown2  "$logs/auto-mini.md",  replace html("$results/auto-mini.html") rpath("$results") cleancode(C:\Users\kerry\Desktop\auto-mini\Stata_log2html\minido.do) css(C:/Users/kerry/Desktop/auto-mini/results/github.css) sav("$results/auto-mini2.md")
disp "HTML report generated: $results/auto-mini.html"

// Open HTML in default browser (Windows)
sopen  "$results/auto-mini.html"
```
