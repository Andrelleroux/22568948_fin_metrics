library(tidyverse)
library(RcppRoll)

Plot_Rolling_Vol <- function(){

    Indexes <- read_rds("data/Cncy_Hedge_Assets.rds")
    ZAR <- read_rds("data/Monthly_zar.rds")

    #Add function from prac for converting from annual to monthly fees
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

    Joined_df <- left_join(Portfolio_Returns, ZAR_Rate_Of_Change, by = "date")

    Plot_2 <- Joined_df %>%
        mutate(Hedged_Fund = 0.7 * Local_Returns + 0.3 * Int_Returns) %>%
        mutate(Unhedged_Fund = 0.7 * Local_Returns + 0.3 * Int_Returns * (1 + ROC)) %>%
        select(date, Hedged_Fund, Unhedged_Fund) %>%
        gather(Type, Returns, -date) %>%
        group_by(Type) %>%
        mutate(Roll_Vol = roll_sd(1 + Returns, 24, fill = NA, align = "right")*sqrt(12)) %>%
        filter(any(!is.na(Roll_Vol))) %>%
        ggplot() + geom_line(aes(date, Roll_Vol, color = Type), alpha = 0.7) +
        labs(title = "2 Year Rolling Standard Deviation", x = "", y = "Mean Standard Deviation")+
        fmxdat::theme_fmx()

    Plot_2

}