library(tidyverse)
library(kableExtra)
library(gt)

Current_Opt <- function(data = Combined_df){

    source("code/Optimise_Portfolio_ROI")

    row_categories <- c("Other", "Bonds & Credit", "Bonds & Credit",
                        "Bonds & Credit", "Bonds & Credit", "Bonds & Credit",
                        "Bonds & Credit", "Other", "Other", "Equities",
                        "Equities", "Equities", "Equities")

    Opt_Weights_Now <- Optimise_Portfolio_ROI(Combined_df) %>%
        mutate(Category = row_categories) %>% gt() %>%
        tab_header(title = "Optimal Portfolio Weights in 2021",
                   subtitle = "Different Row Colours by Category") %>%

    Opt_Weights_Now

}