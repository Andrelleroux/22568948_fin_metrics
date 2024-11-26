library(tidyverse)
library(PerformanceAnalytics)
library(tbl2xts)

Recreate_Table <- function(data = Joined_df){

    #First we calculate the individual Returns series for hedged,
    #unhedged and internatinal hedged Funds
    #Need to start from front with data

    Indexes <- read_rds("data/Cncy_Hedge_Assets.rds")
    ZAR <- read_rds("data/Monthly_zar.rds")

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

    Joined_df <- left_join(Portfolio_Returns, ZAR_Rate_Of_Change, by = "date")

    Table_1 <- Joined_df %>%
        mutate(Hedged_Fund = 0.7 * Local_Returns + 0.3 * Int_Returns) %>%
        mutate(Unhedged_Fund = 0.7 * Local_Returns + 0.3 * Int_Returns * (1 + ROC)) %>%
        select(date, Int_Returns, Hedged_Fund, Unhedged_Fund) %>%
        gather(Type, Returns, -date) %>%
        tbl_xts(., cols_to_xts = Returns, spread_by = Type)

    annualised_returns <- Return.annualized(Table_1, scale = 12) %>% data.frame()
    annualised_stddev <- StdDev.annualized(Table_1, scale = 12) %>% data.frame()
    average_drawdown <- AverageDrawdown(Table_1, scale = 12) %>% data.frame()
    adjusted_sharpe_ratio <- AdjustedSharpeRatio(Table_1, scale = 12) %>% data.frame()

    # Combine all metrics into one data frame
    Table_Final <- bind_rows(
        annualised_returns,
        annualised_stddev,
        average_drawdown,
        adjusted_sharpe_ratio
    )

    return(Table_Final)

}