library(tidyverse)
setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_1")

Read_Combine_Data <- function(){

    ASISA <- read_rds("data/ASISA_Rets.rds")
    BM <- read_rds("data/Capped_SWIX.rds")
    AI_Fund <- read_rds("data/AI_Max_Fund.rds")

    #Compare over same timeline, choose from 2004 and still active in 2023
    #(first year start where all represented)

    ASISA_active <- ASISA %>%
        group_by(Fund) %>%
        filter(first(date) < ymd(20050101)) %>%
        filter(last(date) > ymd(20230901)) %>%
        filter(date == last(date)) %>%
        pull(Fund)

    #We only wamt to look at ACTIVE managers
    ASISA_avg_ret <- ASISA %>% filter(Index == "No" & FoF == "No") %>%
        select(-Index, -FoF) %>%
        filter(Fund %in% ASISA_active) %>%
        group_by(Fund) %>%
        summarise(mean_return = mean(Returns))

    #Check for NA values in Returns
    Check = sum(is.na(ASISA$Returns))

    #Collect 5 funds (Worst Quartile 1 Q2 Q3 and best) based on mean Returns
    best_fund <- ASISA_avg_ret %>% filter(mean_return == max(mean_return)) %>% pull(Fund)
    worst_fund <- ASISA_avg_ret %>% filter(mean_return == min(mean_return)) %>% pull(Fund)

    median_fund <- ASISA_avg_ret %>%
        slice_min(abs(mean_return - median(mean_return))) %>%
        pull(Fund)

    Q1_fund <- ASISA_avg_ret %>%
        slice_min(abs(mean_return - quantile(mean_return, 0.25))) %>%
        pull(Fund)

    Q3_fund <- ASISA_avg_ret %>%
        slice_min(abs(mean_return - quantile(mean_return, 0.75))) %>%
        pull(Fund)
    Selected_Funds <- c(best_fund, worst_fund, median_fund[1], Q1_fund, Q3_fund)

    #Adapt the 3 dataframes for compatible joining

    ASISA_join <- ASISA %>% filter(Index == "No" & FoF == "No") %>%
        select(-Index, -FoF) %>%
        filter(date > ymd(20040101)) %>%
        filter(Fund %in% Selected_Funds) %>%
        mutate(
            Fund = case_when(
                Fund == best_fund ~ "Best",
                Fund == worst_fund ~ "Worst",
                Fund == median_fund[1] ~ "Median",
                Fund == Q1_fund ~ "Q1",
                Fund == Q3_fund ~ "Q3",
                TRUE ~ Fund
            )
        )

    BM_join <- BM %>%
        filter(date > ymd(20040101)) %>%
        mutate(Fund = "BM") %>%
        select(date, Returns, Fund)

    AI_join <- AI_Fund %>%
        filter(date > ymd(20040101)) %>%
        mutate(Fund = "AI") %>%
        rename("Returns" = "AI_Fund")

    #Join the Dataframes together

    Combined_df <- bind_rows(ASISA_join, BM_join, AI_join)

   return(Combined_df)
}