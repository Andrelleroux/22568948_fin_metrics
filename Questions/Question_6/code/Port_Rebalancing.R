library(tidyverse)
library(tbl2xts)
library(PerformanceAnalytics)
library(RColorBrewer)

Port_Rebalancing <- function(data = Combined_df){

    Rebalance_Dates <- data %>%
        select(date) %>%
        unique() %>%
    #Make sure there is available data
        filter(date >= (min(date) + years(3))) %>%
    #Choose Quaterly Rebalancing
        group_by(year_month = floor_date(date, "month")) %>%
        filter(date == max(date)) %>%
        ungroup() %>%
        select(-year_month) %>%
        filter(month(date) %in% c(3, 6, 9, 12)) %>%
        pull(date)

    Weights_df <- tibble()

    for (reb_date in Rebalance_Dates) {

    #Only look at three years prior to rebalance
        data_subset <- data %>% filter(date <= reb_date)

        Weights <- Optimise_Portfolio_ROI(data_subset)
        Weights <- Weights %>%
            mutate(RebalancingDate = as.Date(reb_date))
        Weights_df <- rbind(Weights_df, Weights)

    }

    Weights_df <- Weights_df %>% rename("date" = "RebalancingDate") %>%
        select(date, Name, Weight)

    sink(tempfile())
    Plot_1 <- Weights_df %>% tbl_xts(., cols_to_xts = Weight, spread_by = Name) %>%
        .[endpoints(.,'months')] %>% chart.StackedBar(main = "Optimal Weights of Portfolio",
                                                      ylab = "Weight (%)",
                                                      xlab = "Date",
                                                      col = c(brewer.pal(13, "Set3")),
                                                      cex.legend = 0.5)
    sink()

    return(Plot_1)


}