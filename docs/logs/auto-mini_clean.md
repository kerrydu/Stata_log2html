------------------------------------------------------------------------------------------------------------------------
      name:  <unnamed>
       log:  C:/Users/kerry/Desktop/auto-mini/results/logs/auto-mini.md
  log type:  text
 opened on:  15 Jan 2026, 14:30:50

### Data Preparation

``` stata

. /*---------------------------------
> Data: sysuse auto
> -----------------------------------*/
. * "=== Load and Clean ==="
. sysuse auto, clear
(1978 automobile data)

. disp "Loaded auto.dta. Observations: `c(N)', Variables: `c(k)'"
Loaded auto.dta. Observations: 74, Variables: 12

. // Minimal cleaning
. drop if missing(price, mpg, weight, foreign)
(0 observations deleted)

. disp "Dropped missing. Remaining observations: `c(N)'"
Dropped missing. Remaining observations: 74

. // Generate analysis variables
. gen lprice   = ln(price)

. gen weightkg = weight*0.453592

. label var lprice   "Log of price"

. label var weightkg "Weight (kg)"

. disp "Variables created: lprice, weightkg"
Variables created: lprice, weightkg

```

### Descriptive Statistics

#### Table 1

``` stata

. /*------------------------------------
> Descriptive Statistics
> --------------------------------------*/
. summarize price mpg weight lprice

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
       price |         74    6165.257    2949.496       3291      15906
         mpg |         74     21.2973    5.785503         12         41
      weight |         74    3019.459    777.1936       1760       4840
      lprice |         74    8.640633    .3921059   8.098947   9.674452

. tabstat price mpg weight, by(foreign) statistics(mean sd min max n) columns(statistics)

Summary for variables: price mpg weight
Group variable: foreign (Car origin)

 foreign |      Mean        SD       Min       Max         N
---------+--------------------------------------------------
Domestic |  6072.423  3097.104      3291     15906        52
         |  19.82692  4.743297        12        34        52
         |  3317.115  695.3637      1800      4840        52
---------+--------------------------------------------------
 Foreign |  6384.682  2621.915      3748     12990        22
         |  24.77273  6.611187        14        41        22
         |  2315.909  433.0035      1760      3420        22
---------+--------------------------------------------------
   Total |  6165.257  2949.496      3291     15906        74
         |   21.2973  5.785503        12        41        74
         |  3019.459  777.1936      1760      4840        74
------------------------------------------------------------

. outreg3  using "$results/summary.tex", replace html sum(log)

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
       price |         74    6165.257    2949.496       3291      15906
         mpg |         74     21.2973    5.785503         12         41
       rep78 |         69    3.405797    .9899323          1          5
    headroom |         74    2.993243    .8459948        1.5          5
       trunk |         74    13.75676    4.277404          5         23
-------------+---------------------------------------------------------
      weight |         74    3019.459    777.1936       1760       4840
      length |         74    187.9324    22.26634        142        233
        turn |         74    39.64865    4.399354         31         51
displacement |         74    197.2973    91.83722         79        425
  gear_ratio |         74    3.014865    .4562871       2.19       3.89
-------------+---------------------------------------------------------
     foreign |         74    .2972973    .4601885          0          1
      lprice |         74    8.640633    .3921059   8.098947   9.674452
    weightkg |         74    1369.603    352.5288   798.3219   2195.385

Following variable is string, not included:  
make  
C:/Users/kerry/Desktop/auto-mini/results/summary.tex
C:/Users/kerry/Desktop/auto-mini/results/summary.html
dir : seeout
```
<iframe src='./summary.html' width='100%' height='600px' frameBorder='0'></iframe>
```

. logout3, save("$results/descriptives") replace excel html : tabstat price weight mpg headroom, statistics(n mean sd mi
> n max) columns(statistics) 

{browse `"C:/Users/kerry/Desktop/auto-mini/results/descriptives.xml"'}
{browse `"E:\SynologyDrive\data"':dir}
Output saved to C:/Users/kerry/Desktop/auto-mini/results/descriptives.html
```
<iframe src='./descriptives.html' width='100%' height='350px' frameBorder='0'></iframe>
### Figures

#### Figure 1

``` stata

. /*--------------------------------
> Figures
> ----------------------------------*/
. histogram price, normal title("Price distribution")
(bin={res}8{txt}, start={res}3291{txt}, width={res}1576.875{txt})

. graph2md,  replace save( "$figures/price_hist.png")   zoom(30)
% exported graph to C:/Users/kerry/Desktop/auto-mini/results/figures/price_hist.png
```
<img src="./figures/price_hist.png" style="zoom:30%;" />
#### Figure 2

```

. twoway (scatter price mpg) (lfit price mpg), ///
>     title("Price vs MPG with linear fit") legend(order(1 "Actual" 2 "Fitted"))

. graph2md,  replace save( "$figures/price_mpg.png")   zoom(30)
% exported graph to C:/Users/kerry/Desktop/auto-mini/results/figures/price_mpg.png
```
<img src="./figures/price_mpg.png" style="zoom:30%;" />
### Regression

``` stata

. /*--------------------------------
> Regression
> ----------------------------------*/
. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model1

. qui regress price mpg , vce(robust)

. estimates store model2

. qui regress price i.foreign, vce(robust)

. estimates store model3

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model4

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model5

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model6

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model7

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model8

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model9

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model10

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model11

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model12

. qui regress price mpg weight i.foreign, vce(robust)

. estimates store model13

```
#### Table 2

```

. tabhtml: esttab model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 using "$results/model.html", replace
(output written to {browse  `"C:/Users/kerry/Desktop/auto-mini/results/model.html"'})
```
<iframe src='./model.html' width='100%' height='500px' frameBorder='0'></iframe>
#### Table 3

```

. outreg3 [model*] using "$results/model2.tex", replace html
{stata `"shellout using `"C:/Users/kerry/Desktop/auto-mini/results/model2.tex"'"':C:/Users/kerry/Desktop/auto-mini/results/model2.tex}
{stata `"shellout using `"C:/Users/kerry/Desktop/auto-mini/results/model2.html"'"':C:/Users/kerry/Desktop/auto-mini/results/model2.html}
{browse `"E:\SynologyDrive\data"' :dir}{com} : {txt}{stata `"seeout using "C:/Users/kerry/Desktop/auto-mini/results/model2.txt""':seeout}
```
<iframe src='./model2.html' width='100%' height='600px' frameBorder='0'></iframe>
```


. // cmdcell 1
. // di `"<iframe src='$results/model.html' width='100%' height='500px' frameBorder='0'></iframe>"'
. // cmdcell 0
. // Optional: predicted values
```
#### Figure 3

```

. predict price_hat, xb

. twoway (scatter price price_hat), ///
>     title("Actual vs Predicted (xb)") ///
>     xtitle("Actual") ytitle("Predicted")

. graph2md,  replace save( "$figures/actual_vs_pred.png") zoom(30)
% exported graph to C:/Users/kerry/Desktop/auto-mini/results/figures/actual_vs_pred.png
```
<img src="./figures/actual_vs_pred.png" style="zoom:30%;" />
```


