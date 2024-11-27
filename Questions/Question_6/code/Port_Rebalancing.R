library(tidyverse)
library(tbl2xts)
library(PerformanceAnalytics)
library(RColorBrewer)

Port_Rebalancing <- function(data = Combined_df){

    Rebalance_Dates <- Combined_df %>%
        select(date) %>%
        unique() %>%
    #Make sure there is available data
        filter(date >= (min(date) + years(3))) %>%
    #Choose Quaterly Rebalancing
        filter(month(date) %in% c(3, 6, 9, 12)) %>%
        pull(date)

    Weights_df <- tibble()

    for (date in Rebalance_Dates) {

    #Only look at three years prior to rebalance
        data_subset <- Combined_df %>% filter(date <= date)

        Weights <- Optimise_Portfolio_ROI(data_subset)
        Weights <- Weights %>%
            mutate(RebalancingDate = as.Date(date))
        Weights_df <- rbind(Weights_df, Weights)

    }

    Weights_df <- Weights_df %>% rename("date" = "RebalancingDate") %>%
        select(date, Name, Weight)

    sink(tempfile())
    Plot_1 <- Weights_df %>% tbl_xts(., cols_to_xts = Weight, spread_by = Name) %>%
        .[endpoints(.,'months')] %>% chart.StackedBar(main = "Optimal Weights of Portfolio",
                                                      ylab = "Weight (%)",
                                                      xlab = "Date",
                                                      col = c(brewer.pal(4, "Set3")))
    sink()

    return(Plot_1)


}