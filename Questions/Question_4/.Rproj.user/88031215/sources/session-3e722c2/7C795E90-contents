library(tidyverse)
library(PerformanceAnalytics)
library(tbl2xts)
library(gt)
library(flextable)

Tracking_Error_Table <- function(Markdown = FALSE){

    Port_Rets <- read_rds("data/Fund_Rets.rds")
    BM_Rets <- read_rds("data/BM_Rets.rds")

    Tracking_Error_df <- left_join(BM_Rets, Port_Rets %>% select(-Portolio), by = "date") %>%
        mutate(Diff = Returns - BM)
    Track_Error <- sd(Tracking_Error_df$Diff)*sqrt(12)

    tabDownside <- table.DownsideRisk(Port_Rets %>% tbl_xts(.), ci = 0.95, Rf=0, MAR=0)

    tabDownside_1 <- tabDownside[c(1,3,5,7:9),]

    Measures <- c("Semi Deviation", "Loss Deviation", "Downside Deviation (Rf = 0%)",
                   "Maximum Drawdown", "Historical VaR (95%)", "Historical ES (95%)",
                   "Tracking Error to Benchmark")

    tabDownside_2 <- tabDownside_1 %>% as.data.frame() %>% rbind(Track_Error) %>% cbind(Measures) %>%
        tibble::rownames_to_column() %>% rename(Result = ".") %>% select(Measures, Result)


    if(Markdown){
        Tab <- knitr::kable(tabDownside_2, format = "markdown",
                            caption = "Relative Risk Measures",
                            col.names = c("SnakeOil Capital"))

    }else{
        Tab <- flextable(tabDownside_2) %>%
            set_caption("Summary Table of Relative Risk") %>%
            autofit()

    }

    return(Tab)
}