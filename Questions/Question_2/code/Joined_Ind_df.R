library(tidyverse)

Joined_Ind_df <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_2")

    #First we calculate the individual Returns series for hedged,
    #unhedged and internatinal hedged Funds
    #Need to start from front with data

    Indexes <- read_rds("data/Cncy_Hedge_Assets.rds")
    ZAR <- read_rds("data/Monthly_zar.rds")

    feeconverter <- function(x, Ann_Level) (1+x)^(1/Ann_Level)-1

    #Scale the returns by portfolio weights
    Portfolio_Returns <- Indexes %>%
        mutate(Int_Returns = 0.6 * MSCI_ACWI + 0.4 * Bbg_Agg) %>%
        mutate(Local_Returns = 0.6 * J433 + 0.4 * ALBI) %>%
        #ZAR/USD measured at the end of each month
        mutate(date = ceiling_date(date, "month") - days(1)) %>%
        select(date, Local_Returns, Int_Returns)

    #Calculate the rate of change of the ZAR/USD exchange rate
    ZAR_Rate_Of_Change <- ZAR %>%
        mutate(ROC = log(value) - log(lag(value))) %>%
        #NA's from if there is no month on month change (set to 0)
        mutate(ROC = replace_na(ROC, 0)) %>%
        filter(date > ymd(20020201)) %>%
        select(date, ROC)

    Joined_Ind_df <- left_join(Portfolio_Returns, ZAR_Rate_Of_Change, by = "date") %>%
        mutate(Hedged_Fund = (0.7 * Local_Returns + 0.3 * Int_Returns)-feeconverter(200*1e-4, 12)) %>%
        mutate(Unhedged_Fund = 0.7 * Local_Returns + 0.3 * (Int_Returns + ROC)) %>%
        select(date, Hedged_Fund, Unhedged_Fund, Int_Returns)

    return(Joined_Ind_df)

}