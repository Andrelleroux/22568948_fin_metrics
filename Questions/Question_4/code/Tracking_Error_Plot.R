library(tidyverse)
library(PerformanceAnalytics)
library(tbl2xts)
library(gt)

Read_Join_Data <- function(data = "Question_4/data/"){

    Port_Rets <- read_rds("data/Fund_Rets.rds")
    BM_Rets <- read_rds("data/BM_Rets.rds")

    Tracking_Error_df <- left_join(BM_Rets, Port_Rets %>% select(-Portolio), by = "date") %>%
        mutate(Diff = Returns - BM)
    Track_Error <- round(sd(Tracking_Error_df$Diff),6)

    tabDownside <- table.DownsideRisk(Port_Rets %>% tbl_xts(.), ci = 0.95, Rf=0, MAR=0)

    tabDownside <- tabDownside[c(1,3,5,7:9),]

    Measures <- c("Semi Deviation", "Loss Deviation", "Downside Deviation (Rf = 0%)",
                   "Maximum Drawdown", "Historical VaR (95%)", "Historical ES (95%)",
                   "Tracking Error to Benchmark")

    tabDownside %>% data.frame() %>% rbind(Track_Error) %>% cbind(Measures) %>%
        tibble::rownames_to_column() %>%
        gt() %>%
        cols_move_to_start(Measures) %>%
        tab_header(title = glue::glue("Downside Risk Estimates")) %>%
        fmt_percent(
            columns = 2,
            decimals = 2
        )


    return(tabDownside)

}