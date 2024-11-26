library(tidyverse)

Strat_Perf_Table <- function(data = Joined_df){

    RebDays <- read_rds("data/Rebalance_days.rds")
    Month_ZAR <- read_rds("data/Monthly_zar.rds")

    Zar_SD <- Month_ZAR  %>%
           filter(date > ymd(20130101)) %>%
           select(-Tickers) %>%
        mutate(Returns = log(value)-log(lag(value))) %>%
        filter(!is.na(Returns)) %>%
        mutate(Year = format(date, "%Y")) %>%
        group_by(Year) %>%
        summarise(SD = sd(Returns)) %>%
        ungroup()

    Port_Perf_Vol <- data %>% group_by(date, Fund) %>%
        summarise(PortfolioReturn = sum(Return*weight, na.rm =TRUE)) %>%
        filter(PortfolioReturn != 0) %>%
        mutate(YearMonth = format(date, "%Y%B")) %>%
        group_by(YearMonth, Fund) %>%
        summarise(Port_Vol = sd(PortfolioReturn)*sqrt(250)) %>%
        ungroup()

    Plot_Vol <- ggplot() +
        geom_line(data = Zar_SD, aes(x = Year, y = SD, group = 1)) +
        geom_line(data = Port_Perf_Vol, aes(x = YearMonth, y = Port_Vol, colour = Fund, group = Fund), alpha = 0.6, size = 0.75) +
        labs(
            title = "Monthly Portfolio Volatility Over Time",
            subtitle = "The black line represents the yearly standard deviation in the ZAR/USD exchange rate",
            x = "Date",
            y = "Standard Deviation",
            colour = "Fund"
        ) +
        fmxdat::theme_fmx() +
        theme(
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank()
        )

    Plot_Vol

}