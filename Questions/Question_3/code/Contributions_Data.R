library(tidyverse)
library(rmsfuns)
library(tbl2xts)

Contributions_Data <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_3")

    ALSI <- read_rds("data/ALSI.rds")

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

    Info_df <- ALSI %>% select(date, Tickers, Sector, Index_Name)

    df_port_return_SWIX <-
        left_join(ALSI %>% select(date, Tickers, Return) ,
                  SWIX_BPWeight %>% gather(Tickers, weight, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  SWIX_BPValue %>% gather(Tickers, value_held, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  SWIX_Contribution %>% gather(Tickers, Contribution, -date),
                  by = c("date", "Tickers")) %>%
        left_join(.,
                  Info_df, by = c("date", "Tickers")) %>%
        mutate(Fund = "SWIX")

    df_port_return_ALSI <-
        left_join(ALSI %>% select(date, Tickers, Return),
                  ALSI_BPWeight %>% gather(Tickers, weight, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  ALSI_BPValue %>% gather(Tickers, value_held, -date),
                  by = c("date", "Tickers") ) %>%

        left_join(.,
                  ALSI_Contribution %>% gather(Tickers, Contribution, -date),
                  by = c("date", "Tickers")) %>%
        left_join(.,
                  Info_df, by = c("date", "Tickers")) %>%
        mutate(Fund = "ALSI")

    Joined_df <- rbind(df_port_return_ALSI, df_port_return_SWIX)

    return(Joined_df)
}