library(tidyverse)
library(tbl2xts)
library(PerformanceAnalytics)
library(RColorBrewer)

Weights_StackBar <- function(){

    Port_Holds <- read_rds("data/Fund_Holds.rds")

    Weight_xts <- Port_Holds %>% tbl_xts(., cols_to_xts = Weight, spread_by = Tickers)
    #Make all NA values 0 as no weights at that point
    Weight_xts[is.na(Weight_xts)] <- 0
    #Gather again and get Top 8 most prevalent stocks
    Top_Weights <- Weight_xts %>% xts_tbl() %>%
        gather(Tickers, Weight, -date) %>%
        group_by(Tickers) %>%
        summarise(Avg_Weight = mean(Weight, na.rm = T)) %>%
        arrange(desc(Avg_Weight)) %>%
        slice_head(n = 10) %>%
        pull(Tickers)

    #Create Other stock consisting of stocks not in Top
    Plot_2 <- Weight_xts %>% xts_tbl() %>%
        gather(Tickers, Weight, -date) %>%
        mutate(Tickers = if_else(Tickers %in% Top_Weights, Tickers, "Other")) %>%
        group_by(date, Tickers) %>%
        summarise(Weight = sum(Weight, na.rm = T)) %>%
        tbl_xts(., cols_to_xts = Weight, spread_by = Tickers) %>%
        .[endpoints(.,'months')] %>% chart.StackedBar(main = "Stacked Bar Chart of Stock Weights",
                                                                       ylab = "Weight (%)",
                                                                       xlab = "Date",
                                                      col = c(brewer.pal(11, "Set3")))

    return(Plot_2)
}