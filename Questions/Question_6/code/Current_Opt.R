library(tidyverse)
library(kableExtra)
library(gt)

Current_Opt <- function(data = Combined_df, Markdown = FALSE){

    row_categories <- c("Other", "Bonds & Credit", "Bonds & Credit",
                        "Bonds & Credit", "Bonds & Credit", "Bonds & Credit",
                        "Bonds & Credit", "Other", "Other", "Equities",
                        "Equities", "Equities", "Equities")

    Opt_Weights_Now <- Optimise_Portfolio_ROI(data) %>%
        mutate(Category = row_categories)

        if(Markdown){
            Tab <- knitr::kable(Opt_Weights_Now, format = "markdown",
                                caption = "Optimal Portfolio Weights in 2021",
                                col.names = c("Assets", "Weights", "Category"))

        }else{
            Tab <- knitr::kable(Opt_Weights_Now, format = "html",
                                caption = "Optimal Portfolio Weights in 2021",
                                col.names = c("Assets", "Weights", "Category")) %>%
                kable_styling("striped", full_width = F, font_size = 12) %>%
                column_spec(1, bold = T) %>%
                footnote(general = "Own Calculations",
                         general_title = "Note: ",
                         footnote_as_chunk = T)
        }

    return(Tab)

}