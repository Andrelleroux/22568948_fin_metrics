library(tidyverse)
library(tbl2xts)

Return_Persistence <- function(data = Currencies_df){


    Garch_df <- Currencies_df %>%
        ungroup() %>%
        filter(date >= ymd(20110101)) %>%
        filter(Name == "SouthAfrica") %>%
        select(date, ROC) %>%
        tbl_xts()

    Plotdata <- cbind(Garch_df, Garch_df^2, abs(Garch_df))
    colnames(Plotdata) = c("ROC", "ROC_Sqd", "ROC_Abs")

    Plotdata <-
        Plotdata %>% xts_tbl() %>%
        gather(ReturnType, Returns, -date)

    Plot_1 <- ggplot(Plotdata) +
        geom_line(aes(x = date, y = Returns, colour = ReturnType, alpha = 0.5)) +

        ggtitle("Rate of Change Persistence for the Rand") +
        facet_wrap(~ReturnType, nrow = 3, ncol = 1, scales = "free") +

        guides(alpha = "none", colour = "none") +
        fmxdat::theme_fmx() +
        labs(y = "Rate of Change", x = "")

    return(Plot_1)

}