library(tidyverse)

Data_Read_Manipulate <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_2")

    Indexes <- read_rds("data/Cncy_Hedge_Assets.rds")
    ZAR <- read_rds("data/Monthly_zar.rds")

    #Scale the returns by portfolio weights
    Portfolio_Returns <- Indexes %>%
        mutate(J433 = 0.42*J433) %>%
        mutate(ALBI = 0.28*ALBI) %>%
        mutate(MSCI_ACWI = 0.18*MSCI_ACWI) %>%
        mutate(Bbg_Agg = 0.12*Bbg_Agg) %>%
        mutate(Returns = rowSums(select(., J433, ALBI, MSCI_ACWI, Bbg_Agg))) %>%
    #ZAR/USD measured at the end of each month
        mutate(date = ceiling_date(date, "month") - days(1)) %>%
        select(date, Returns)

    #Calculate the rate of change of the ZAR/USD exchange rate
    ZAR_Rate_Of_Change <- ZAR %>%
        mutate(ROC = log(value) - log(lag(value))) %>%
    #NA's from if there is no month on month change (set to 0)
        mutate(ROC = replace_na(ROC, 0)) %>%
        filter(date > ymd(20020201)) %>%
        select(date, ROC)

    #Combine the dataframes
    Joined_df <- left_join(Portfolio_Returns, ZAR_Rate_Of_Change, by = "date")

    return(Joined_df)
}