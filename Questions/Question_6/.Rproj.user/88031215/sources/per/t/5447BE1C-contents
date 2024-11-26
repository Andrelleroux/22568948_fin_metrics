library(tidyverse)

Data_Read_Wrangle <- function(dataloc = ""){

    MAA <- read_rds("data/MAA.rds")
    msci <- read_rds("data/msci.rds") %>%
        filter(Name %in% c("MSCI_ACWI", "MSCI_USA", "MSCI_RE", "MSCI_Jap"))

    #Combine the df's and add the constraint on the dates
    Combined_df <- rbind(MAA %>% select(-Ticker), msci) %>%
        filter(date >= ymd(20110101)) %>%
        group_by(Name) %>%
        filter(n_distinct(year(date)) >= 3) %>%
        mutate(Year_Month = format(date, "%Y%B")) %>%
    #Get last dy of each month
        arrange(date) %>%
        group_by(Name, Year_Month) %>%
        filter(date == last(date)) %>%
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