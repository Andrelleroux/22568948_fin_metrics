library(tidyverse)
library(rugarch)
library(rmgarch)
library(tbl2xts)
library(zoo)

Imp_Go_Garch <- function(data = Currencies_df){

    source("code/Above_Avg_Perf.R")

    US_perf <- Above_Avg_Perf(data)

    bbdxy <- read_rds("data/bbdxy.rds") %>%
        #Use bbdxy as proxy for Dollar Strength
        mutate(ROC = log(Price)-log(lag(Price))) %>%
        filter(!is.na(ROC)) %>%
        mutate(Name = "US_prox") %>%
        select(date, Name, ROC)

    cncy_Carry <- read_rds("data/cncy_Carry.rds") %>%
        mutate(ROC = log(Price)-log(lag(Price))) %>%
        filter(!is.na(ROC)) %>%
        mutate(Name = "G10_Carry") %>%
        select(date, Name, ROC)

    Garch_df <- Currencies_df %>%
        rbind(bbdxy) %>%
        rbind(cncy_Carry) %>%
        ungroup() %>%
        filter(date >= ymd(20110101) & date <= ymd(20200320)) %>%
        filter(Name %in% c("SouthAfrica",
                           "US_prox", "G10_Carry", "EU", "Japan")) %>%
        select(date, ROC, Name) %>%
        tbl_xts(., cols_to_xts = ROC, spread_by = Name)

    # Specify GO-GARCH Model
    uspec <- ugarchspec(variance.model = list(model = "gjrGARCH",
             garchOrder = c(1, 1)), mean.model = list(armaOrder = c(1,
             0), include.mean = TRUE), distribution.model = "sstd")

    multi_univ_garch_spec <- multispec(replicate(ncol(Garch_df), uspec))

    spec.go <- gogarchspec(multi_univ_garch_spec,
                           distribution.model = 'mvnorm', # or manig.
                           ica = 'fastica')

    cl <- makePSOCKcluster(10)
    multf <- multifit(multi_univ_garch_spec, Garch_df, cluster = cl)

    fit.gogarch <- gogarchfit(spec.go,
                              data = Garch_df,
                              solver = 'hybrid',
                              cluster = cl,
                              gfun = 'tanh',
                              maxiter1 = 40000,
                              epsilon = 1e-08,
                              rseed = 100)

    gog.time.var.cor <- rcor(fit.gogarch)
    gog.time.var.cor <- aperm(gog.time.var.cor,c(3,2,1))
    dim(gog.time.var.cor) <- c(nrow(gog.time.var.cor), ncol(gog.time.var.cor)^2)

    gog.time.var.cor <-
        renamingdcc(ReturnSeries = Garch_df, DCC.TV.Cor = gog.time.var.cor)

    Plot_GoGarch <- ggplot(gog.time.var.cor %>% filter(grepl("SouthAfrica_", Pairs),
          !grepl("_SouthAfrica", Pairs))) +
        geom_line(aes(x = date, y = Rho,
          colour = Pairs)) +
        geom_rect(data = Above_avg_periods, inherit.aes = F,
              aes(xmin = Start, xmax = End,
                  ymin = -Inf, ymax = Inf),
              alpha = 0.2, fill = "green") +
        fmxdat::theme_fmx() +
        ggtitle("Go-GARCH: ZAR")

    return(Plot_GoGarch)
}