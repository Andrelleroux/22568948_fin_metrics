library(tidyverse)
library(RiskPortfolios)
library(quadprog)

Optimise_Portfolio <- function(data = Combined_df){

    return_mat_Nodate <- data.matrix(Combined_df[, -1])

    Sigma_LW <- covEstimation(return_mat_Nodate, control = list(type = "lw"))
    Mu <- Combined_df %>% summarise(across(-date, ~exp(mean(log(1+.))) - 1 )) %>%
        purrr::as_vector()

    #Now need to set up the constraints for individual, bonds, equities, etc.

    N_Assets <- ncol(return_mat_Nodate)
    LBs <- rep(0, N_Assets)
    UBs <- rep(0.4, N_Assets)
    meq <- 1

    Equity_UB <- c(rep(0,9), 1, 1, 1, 1)
    Bond_UB <- c(0,1,1,1,1,1,1, rep(0,6))
    Other_LB <- c(1,rep(0,6), 1, 1, rep(0,4))

    #Construct A matrix with constraints
    Amat <- rbind(
        rep(1, N_Assets),
        diag(1, N_Assets),
        -diag(1, N_Assets),
        Bond_UB,
        Equity_UB,
        Other_LB
    )

    #RHS of inequalities
    bvec <- c(
        1,
        LBs,
        -UBs,
        0.25,
        0.6,
        -0.15
    )

    #Transpose Amat to correct orientation
    Amat <- t(Amat)

    Opt_Port <- solve.QP(Dmat = Sigma_LW,
                         dvec = Mu,
                         Amat = Amat,
                         bvec = bvec,
                         meq = meq)$solution

    result_QP <- tibble(Name = colnames(Sigma), Weight = round(Opt_Port, 3))

    return(result_QP)


}