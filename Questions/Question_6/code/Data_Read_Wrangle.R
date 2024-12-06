library(tidyverse)

Data_Read_Wrangle <- function(dataloc = ""){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_6")

    MAA <- read_rds("data/MAA.rds")
    msci <- read_rds("data/msci.rds") %>%
        filter(Name %in% c("MSCI_ACWI", "MSCI_USA", "MSCI_RE", "MSCI_Jap"))

    #Combine the df's and add the constraint on the dates
    Combined_df <- rbind(MAA %>% select(-Ticker), msci) %>%
        filter(date >= ymd(20110101)) %>%
        group_by(Name) %>%
        filter(n_distinct(year(date)) >= 3) %>%
        group_by(Name) %>%
    #Calculate log returns
        mutate(Returns = log(Price) - log(lag(Price))) %>%
        filter(!is.na(Returns)) %>%
        select(date, Name, Returns) %>%
        spread(Name, Returns)

    #Was used to check for NA values throughout
    #Check = sum(is.na(Combined_df$Returns))

    return(Combined_df)
}