library(tidyverse)
library(rugarch)
library(zoo)

Fitting_Garch <- function(data = Currencies_df){

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

    Garch_Check <- Box.test(coredata(Garch_df^2), type = "Ljung-Box", lag = 12)
    Garch_Check$p.value

    garch11 <- ugarchspec(
                variance.model = list(model = c("sGARCH","gjrGARCH","eGARCH","fGARCH","apARCH")[1],
                                        garchOrder = c(1, 1)),
                mean.model = list(armaOrder = c(1, 0), include.mean = TRUE),
            distribution.model = c("norm", "snorm", "std", "sstd", "ged", "sged", "nig", "ghyp", "jsu")[1])

    garchfit1 = ugarchfit(spec = garch11,data = Garch_df)
    sigma <- sigma(garchfit1) %>% xts_tbl()
    garch_tab <- garchfit1@fit$matcoef

    colnames(sigma) <- c("date", "sigma")
    sigma <- sigma %>% mutate(date = as.Date(date))

    gg <- ggplot() +
        geom_line(data = Plotdata %>% filter(ReturnType == "ROC_Sqd") %>% select(date, Returns) %>%
                      unique %>% mutate(Returns = sqrt(Returns)), aes(x = date, y = Returns)) +
        geom_line(data = sigma, aes(x = date, y = sigma), color = "red", size = 1, alpha = 1.2) +
        # scale_y_continuous(limits = c(0, 0.35)) +
        labs(title = "Comparison: Returns Sigma vs Sigma from Garch") +
        fmxdat::theme_fmx()

    return(gg)

}