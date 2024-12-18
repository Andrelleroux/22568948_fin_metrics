# 22568948 Financial Econometrics Practical Exam

In this markdown folder I will explain my thinking and working for the
coding aspect of the Financial Econometrics final exam in November 2024.
I will work through the questions one by one and talk through the code
that I wrote to complete it.

``` r
rm(list = ls()) # Clean your environment:
gc()
setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics")

library(tidyverse)
```

## Packages

What follows is the list of packages that have been used throughout the
functions of this project:

-   tidyverse (includes ggplot2, dplyr)
-   Texevier
-   fmxdat
-   RcppRoll
-   PerformanceAnalytics
-   tbl2xts
-   rmgarch
-   rugarch
-   ROI
-   ROI.plugin.quadprog
-   gt
-   kableExtra
-   zoo
-   RColorBrewer
-   flextable
-   ggExtra

## Question 1

It is firstly important that the working directory of the project is
properly allocated as the directory is used to create folders and
projects. All Texevier lines of code was commented as the projects have
already been created.

``` r
#Firstly I create the Texevier project for writing the report and coding in Question 1
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_1")

#Secondly I fetch the functions that I wrote from the code folder in Question 1
list.files(paste0(getwd(), "/Questions/Question_1/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

The first command that is run is to create a Texevier HTML project under
the title Question_1 wherein I complete the question. The second is to
fetch the functions that I create while creating the PowerPoint for
question 1.

``` r
Combined_df <- Read_Combine_Data()
```

This function aims to impose some of the constraints from the question
and combine the data together in a meaningful way. Specifically look for
ACTIVE managers, then pull 5 active funds to compare to (Worst, Q1,
Median, Q3, Best). Finally combine these with the AI and BenchMark
datasets to create a combined dataset.

``` r
Plot_1 <- Rolling_ret_plot(dataset = Combined_df)
Plot_1
```

![](README_files/figure-markdown_github/unnamed-chunk-4-1.png)

This function takes our previously created data frame as an argument and
plots the rolling returns of different funds. Firstly a fee is placed on
the actively managed funds, using the feeconverter function from the
practicals to convert to monthly fees. I can then use the roll_prod
function on my returns to get a rolling average return for the funds,
this is set at 3 years and annualised. Missing values are removed and
the funds of interest are made bolder in the geom_line plot for clarity.

``` r
Plot_2 <- Rolling_Vol_plot(Combined_df)
Plot_2
```

![](README_files/figure-markdown_github/unnamed-chunk-5-1.png)

This function does a very similar thing to the previous function.
However this time the rolling function is changed to roll_sd to get the
3 year rolling standard deviation as a measure of volatility to compare
between funds. Graphed in the same manner as previous function.

``` r
Plot_3 <- Return_Distributions(Combined_df)
Plot_3
```

![](README_files/figure-markdown_github/unnamed-chunk-6-1.png)

This function graphs the density of the three year rolling annualised
returns for three specific funds, namely the AI, benchmark and median
funds, this is due to the density plot for 7 funds being much too
clattered. Fees are also taken into consideration for the median fund.
The means for the return series is also calculated and added to provide
more information.

``` r
Plot_4 <- Tot_Dist()
Plot_4
```

![](README_files/figure-markdown_github/unnamed-chunk-7-1.png)

This function changes from the previous by having the density of the
returns being for all active funds, rather than just the one median
fund, fees are applied to it and is represented by the different fills
to show visually the impact of fees. Our AI fund is added for
comparison. These remain 3 year rolling average return densities.

## Question 2

This section explains the coding behind question 2 of the exam. The
following code was used to create the project and to fetch the functions
to be used in Question 2 from the code folder.

``` r
#Firstly Create the Texevier project
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_2")

#Secondly I fetch the functions that I wrote from the code folder in Question 2
list.files(paste0(getwd(), "/Questions/Question_2/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

``` r
Joined_df <- Data_Read_Manipulate()

Joined_Indiv <- Joined_Ind_df()
```

The Data_Read_Manipulate function focused specifically on replicating
the graphic and calculated the returns for the hedged portfolio and
combined it with the USD/ZAR exchange rate. The portfolio was created by
the weights given, such that local equities are 42%, local bonds are
28%, global equities are 18% and global bonds are 12%.

The Joined_ind_df function however focuses on a more loose final data
structure that includes a hedged portfolio, an unhedged portfolio and a
fully hedged international portfolio. These are the required funds for
recreating the table. Fees are deducted for hedging as is stated in the
graph, we deduct at 200bp converted to monthly.

``` r
Plot_Recreate <- Recreate_Plot(Joined_df)
Plot_Recreate
```

![](README_files/figure-markdown_github/unnamed-chunk-10-1.png)

This plot recreates the graphic from the given article with slight
differences in numbers and semantics. The density plots along the side
is added with ggMarginal and the numbers and labels with gglabel. The
number of dots in each quadrants was counted before being divided by the
total to get percentages.

``` r
Table_Recreate <- Recreate_Table(Joined_Indiv, Markdown = TRUE)
Table_Recreate
```

|                                       | Internation Hedged | Hedged Portfolio | Unhedged Portfolio |
|:----------------------------|--------------:|-------------:|--------------:|
| Annualized Return                     |             0.0383 |           0.0794 |             0.1101 |
| Annualized Standard Deviation         |             0.1058 |           0.0983 |             0.0841 |
| Average Drawdown                      |             0.0694 |           0.0444 |             0.0281 |
| Adjusted Sharpe ratio (Risk free = 0) |             0.3444 |           0.7038 |             1.1281 |

USD-ZAR Fund Performance

In this function I use the tbl2xts and PerformanceAnalytics package to
calculate interesting metrics about the portfolios in order to compare
them to one another and determine the “better” portfolio between hedging
and unhedged. I then convert back to a tibble for a table and input an
if statement as the format for a markdown_github table is not the same
as for a knit to html markdown.

``` r
Plot_Vol <- Roll_Vol(Joined_Indiv)
Plot_Vol
```

![](README_files/figure-markdown_github/unnamed-chunk-12-1.png)

Given that we are discussing the concept of long-term strategies I
estimate a 5 year annualised rolling standard deviation for the hedged
and unhedged portfolios and compare them over time.

## Question 3

This section explains the coding behind question 3 of the exam. The
following code was used to create the project and to fetch the functions
to be used in Question 3 from the code folder.

``` r
#Firstly Create the Texevier project
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_3")

#Secondly I fetch the functions that I wrote from the code folder in Question 3
list.files(paste0(getwd(), "/Questions/Question_3/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

``` r
Joined_df <- Contributions_Data()
```

This function takes the ALSI dataset and uses the Safe_Return.portfolio
command to get the value, weight and contribution of the different
stocks in the portfolios on all days. In order to this I first get
weight and returns xts dataset to feed into the command. Once this is
done I create seperate data frames for the weights, contributions and
value before adding them together again using left join depending on
whether it is the ALSI or SWIX portfolio. I can then rbind the two
portfolios to get a combined dataframe that contains the weights, value,
returns and contribution for each stock at each point in time.

``` r
plot_Comp <- Cum_Returns_Comp()
plot_Comp
```

![](README_files/figure-markdown_github/unnamed-chunk-15-1.png)

This function calculates the cumulative returns for the SWIX and ALSI
and plots them on the same graph in order to compare them.

``` r
plot_Sector <- Sector_Contributions_Plot(Joined_df)
plot_Sector
```

![](README_files/figure-markdown_github/unnamed-chunk-16-1.png)

This function uses the contributions calculated by the
Contributions_Data function and groups them by date, index and sector to
produce the total contribution by a sector to returns at a specific
date. This value is then taken to a rolling average of 2 years after
transforming to monthly data. This is then plotted with colour being
determined by sector and being facet wrapped by Index.

``` r
Size_plot <- Size_Contributions_Plot(Joined_df)
Size_plot
```

![](README_files/figure-markdown_github/unnamed-chunk-17-1.png)

This function is very similar to the previous one, but instead groups by
whether a stock is large, small or mid cap. There were isolated
instances of NA values. Due to the lack of following large time spans of
NA values the NA values were filtered out.

``` r
Vol_plot <- Strat_Perf_Table(Joined_df)
Vol_plot
```

![](README_files/figure-markdown_github/unnamed-chunk-18-1.png)

This function adds the monthly USD/ZAR exchange rate, but due to being
monthly values I estimated a yearly standard deviation for the exchange
rate and plot that next to the monthly standard deviation (base on daily
data) of the standard deviation of the ALSI and SWIX. The lack of a
smaller time frame for monthly USD/ZAR is not ideal, but still provides
some insight.

``` r
Cap_plot <- Capping_Effect()
Cap_plot
```

![](README_files/figure-markdown_github/unnamed-chunk-19-1.png)

For the above function the rebalance dates of the function is taken and
filtered for in the ALSI dataset. On these dates the
Proportional_Cap_Foo function from the practicals is used to limit the
maximum weight that a stock can be. This data frame is then turned into
an xts file to run Safe_Return.portfolio and calculate the cumulative
returns for the specific current case. This is done 6 times, once each
for unweighted, 5% capped and 10% capped. This is one for both Indexes
seperately. Once this is done all seperate data frames are converted
back to tibbles and combined to graph the above plot of the cumulative
returns at different caps.

## Question 4

This section explains the coding behind question 4 of the exam. The
following code was used to create the project and to fetch the functions
to be used in Question 4 from the code folder.

``` r
#Firstly Create the Texevier project
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_4")

#Secondly I fetch the functions that I wrote from the code folder in Question 4
list.files(paste0(getwd(), "/Questions/Question_4/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

``` r
Risk_table <- Tracking_Error_Table(Markdown = TRUE)
Risk_table
```

| Measures                     |     Result |
|:-----------------------------|-----------:|
| Semi Deviation               |  0.0330000 |
| Loss Deviation               |  0.0298000 |
| Downside Deviation (Rf = 0%) |  0.0281000 |
| Maximum Drawdown             |  0.2129000 |
| Historical VaR (95%)         | -0.0682000 |
| Historical ES (95%)          | -0.0905000 |
| Tracking Error to Benchmark  |  0.0498373 |

Relative Risk Measures

The above function takes the returns from the portfolio and benchmark
and calculates the tracking error (annualised) and uses
PerformanceAnalytics for more relative risk measures. Which is added to
a table in order to be presented. If statement required due to
incompatibility in tables between markdown and html.

``` r
Plot_Perf <- Relative_Performance()
Plot_Perf
```

![](README_files/figure-markdown_github/unnamed-chunk-22-1.png)

Having the returns of the portfolio as well as it’s benchmark allows me
to calcualte the information ratio of the portfolio, thus looking at the
risk adjusted returns compared to a benchmark. In order to get a more
accurate estimation we take a rolling mean and rolling standard
deviation to compute the information ratio.

``` r
Plot_Sector <- Sector_Pie()
Plot_Sector
```

![](README_files/figure-markdown_github/unnamed-chunk-23-1.png)

This takes the sector weights divided by the total weight to get a
percentage of the portfolio that is invested in the sector at a specific
point in time. This is then graphed over time to show how these weights
and dependency on certain sectors change.

``` r
Plot_Weights <- Weights_StackBar()
```

![](README_files/figure-markdown_github/unnamed-chunk-24-1.png)

``` r
Plot_Weights
```

In this function I first spread by Tickers to get zeroes where there are
no weights. I then slice the top n stocks to include and sum the rest to
create an “Other” stock with the remainder of the stocks. I then
summarise the weight by tickers and dte to get the breakdown of weights
over the timeline. This allows us to look at changes in stock weights
over time.

## Question 5

This section explains the coding behind question 5 of the exam. The
following code was used to create the project and to fetch the functions
to be used in Question 5 from the code folder.

``` r
#Firstly Create the Texevier project
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_5")

list.files(paste0(getwd(), "/Questions/Question_5/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

``` r
Currencies_df <- Data_Workings()
Currencies_df
```

The aim of the above function is simply to wrangle the cncy rds file by
cleaning up observation names and calculating the log rate of change for
the currencies.

``` r
plot_Hist <- Plot_sdRank(Currencies_df)
plot_Hist
```

![](README_files/figure-markdown_github/unnamed-chunk-27-1.png)

This function calculates the annualised standard deviation for each
currency over the last 5 years to compare volatility in recent years.
South Africa is filled a different colour so as to easily be able to see
where we rank in terms of recent standard deviation.

``` r
plot_Persist <- Return_Persistence(Currencies_df)
plot_Persist
```

![](README_files/figure-markdown_github/unnamed-chunk-28-1.png)

This function uses a very similar structure to the practicals to get the
rate of change persistence for the south african rand, this is done to
qualitatively look for the need to implement a GARCH model. I added the
time frame and filter.

``` r
Garch_plot <- Fitting_Garch(Currencies_df)
Garch_plot
```

![](README_files/figure-markdown_github/unnamed-chunk-29-1.png)

This function is again similar to practicals as it uses the estimated
sigmas from a sGARCH(1,1) with an ARMA(1,0) mean process and compares it
to the sigmas of the actual data of the South African Rand.

``` r
GoGarch_plot <- Imp_Go_Garch(Currencies_df)
GoGarch_plot
```

![](README_files/figure-markdown_github/unnamed-chunk-30-1.png) There
are actually two separate function at play here. The first is a function
called Above_avg_Perf() which looks at the bbdxy and Rand and calculates
monthly rolling 2 year returns. I then calculate the mean of the returns
series and filter by dates where the Dollar is above it’s mean (Dollar
is appreciating). I then calculate the stretches of dates for which the
rolling returns remain above the average. Giving us the dates for the
green blocks.

The second function was used to create the plot. This is where I choose
my 5 currencies and implement a GO-GARCH model with gjrGarch of order
(1,1) and an ARMA(1,0) mean process. I can then fit and calculate the
GO-GARCH model and use it to get estimates for the time varying
correlation between stocks.

## Question 6

This section explains the coding behind question 6 of the exam. The
following code was used to create the project and to fetch the functions
to be used in Question 6 from the code folder.

``` r
#Firstly Create the Texevier project
#Texevier::create_template_html(directory = glue::glue("{getwd()}/"), template_name = "Question_6")

list.files(paste0(getwd(), "/Questions/Question_6/code/"), full.names = T, recursive = T) %>% .[grepl('.R', .)] %>% as.list() %>% walk(~source(.))
```

``` r
Combined_df <- Data_Read_Wrangle()
Combined_df
```

This function combines the MAA and msci databases while making sure that
stocks have at least 3 years of returns to be eligible and calculating
the log return on the price.

``` r
plot_Table <- Current_Opt(Combined_df, Markdown = TRUE)
plot_Table
```

| Assets                      | Weights | Category       |
|:----------------------------|--------:|:---------------|
| Asia_dollar_Idx             |    0.00 | Other          |
| Bbg_EUCorpCred_Unhedged_USD |    0.00 | Bonds & Credit |
| Bbg_EuroBonds_UnhedgedEUR   |    0.00 | Bonds & Credit |
| Bbg_GlBonds_HedgedUSD       |    0.00 | Bonds & Credit |
| Bbg_GlCorpCred_Hedged_USD   |    0.00 | Bonds & Credit |
| Bbg_USBonds_UnhedgedUSD     |    0.00 | Bonds & Credit |
| Bbg_USCorpCred_Unhedged_USD |    0.25 | Bonds & Credit |
| Commod_Idx                  |    0.15 | Other          |
| Dollar_Idx                  |    0.00 | Other          |
| MSCI_ACWI                   |    0.20 | Equities       |
| MSCI_Jap                    |    0.00 | Equities       |
| MSCI_RE                     |    0.00 | Equities       |
| MSCI_USA                    |    0.40 | Equities       |

Optimal Portfolio Weights in 2021

This function makes use of another function called
Optimise_Portfolio_ROI. In this function I calculate the estimates for
Mu and Sigma (forr Sigma I used the Ledoit-Wolfe method). I then create
the total, individual and group constraints to produce a corresponding
Amat and bvec matrix and vector. I then solve the problem based on
mean-variance tradeoff solution and get the corresponding weights.

The Current_Opt function is then used to produce the optimal weights for
the latest date, which is then displayed in a table.

![](README_files/figure-markdown_github/unnamed-chunk-34-1.png)

In this function I get the rebalancing dates as quarters and run a for
loop where I run the Optimise_Portfolio_ROI each time with data looking
back three years. These dates are then added to a growing weights
dataframe. It is this weights dataframe that produces the figure using
the PerformanceAnalytics package.
