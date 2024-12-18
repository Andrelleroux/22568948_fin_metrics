library(tidyverse)
library(rmsfuns)
library(tbl2xts)

Cum_Returns_Comp <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_3")

    ALSI <- read_rds("data/ALSI.rds")
    RebDays <- read_rds("data/Rebalance_days.rds")
    Month_ZAR <- read_rds("data/Monthly_zar.rds")

    SWIX_wts <- ALSI %>%
        select(date, Tickers, J403) %>%
        spread(Tickers, J403) %>%
        tbl_xts()
    SWIX_wts[is.na(SWIX_wts)] <- 0

    ALSI_wts <- ALSI %>%
        select(date, Tickers, J203) %>%
        spread(Tickers, J203) %>%
        tbl_xts()
    ALSI_wts[is.na(ALSI_wts)] <- 0


    df_Returns <- ALSI %>%
        select(date, Tickers, Return) %>%
        spread(Tickers, Return)
    df_Returns[is.na(df_Returns)] <- 0
    df_Returns_xts <- df_Returns %>%
        tbl_xts()

    SWIX_RetPort <-
        rmsfuns::Safe_Return.portfolio(df_Returns_xts,
                                       weights = SWIX_wts, lag_weights = TRUE,
                                       verbose = TRUE, contribution = TRUE,
                                       value = 1000, geometric = TRUE)

    ALSI_RetPort <-
        rmsfuns::Safe_Return.portfolio(df_Returns_xts,
                                       weights = ALSI_wts, lag_weights = TRUE,
                                       verbose = TRUE, contribution = TRUE,
                                       value = 1000, geometric = TRUE)

    SWIX_Contribution <-
        SWIX_RetPort$"contribution" %>% xts_tbl()

    SWIX_BPWeight <-

        SWIX_RetPort$"BOP.Weight" %>% xts_tbl()

    SWIX_BPValue <-

        SWIX_RetPort$"BOP.Value" %>% xts_tbl()

    ALSI_Contribution <-
        ALSI_RetPort$"contribution" %>% xts_tbl()

    ALSI_BPWeight <-
        ALSI_RetPort$"BOP.Weight" %>% xts_tbl()

    ALSI_BPValue <-
        ALSI_RetPort$"BOP.Value" %>% xts_tbl()

    df_port_return_SWIX <-
        left_join(ALSI %>% select(date, Tickers, Return) ,
                  SWIX_BPWeight %>% gather(Tickers, weight, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  SWIX_BPValue %>% gather(Tickers, value_held, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  SWIX_Contribution %>% gather(Tickers, Contribution, -date),
                  by = c("date", "Tickers"))

    df_port_return_ALSI <-
        left_join(ALSI %>% select(date, Tickers, Return),
                  ALSI_BPWeight %>% gather(Tickers, weight, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  ALSI_BPValue %>% gather(Tickers, value_held, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  ALSI_Contribution %>% gather(Tickers, Contribution, -date),
                  by = c("date", "Tickers"))

    df_Portf_SWIX <-
        df_port_return_SWIX %>% group_by(date) %>%
        summarise(PortfolioReturn = sum(Return*weight, na.rm =TRUE)) %>%
        filter(PortfolioReturn != 0)

    df_Portf_ALSI <-
        df_port_return_ALSI %>% group_by(date) %>%
        summarise(PortfolioReturn = sum(Return*weight, na.rm =TRUE)) %>%
        filter(PortfolioReturn != 0)

    Joined_rets<-
        left_join(df_Portf_ALSI %>% rename("ALSI"= "PortfolioReturn"), df_Portf_SWIX %>%
                      rename("SWIX"= "PortfolioReturn"), by = "date") %>%
        gather(Index, Returns, -date)

    Comparing_Index <- Joined_rets %>%
        arrange(date) %>%
        group_by(Index) %>%
        mutate(cum_rts = cumprod(1+Returns)) %>%
        select(-Returns) %>%
        ungroup() %>%
        ggplot()+
        geom_line(aes(date, cum_rts, color = Index))+
        fmxdat::theme_fmx()+
        labs(title = "Cumulative Returns of ALSI vs SWIX",  x = "", y = "Total Cumulative Returns")

    return(Comparing_Index)

}