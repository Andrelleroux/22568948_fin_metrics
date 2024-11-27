
library(ROI)
library(ROI.plugin.quadprog)
#Quadprog was not taking into consideration group level constraints

Optimise_Portfolio_ROI <- function(data = Combined_df) {

    cutoff_date <- Combined_df %>% select(date) %>%
         mutate(Cutoff = max(date) - years(3)) %>%
        slice_head(n = 1) %>% pull(Cutoff)

    return_mat_Nodate <- Combined_df %>% filter(date >= cutoff_date) %>%
        select(-date) %>%
        data.matrix(.)
    Sigma_LW <- covEstimation(return_mat_Nodate, control = list(type = "lw"))
    Mu <- Combined_df %>% filter(date >= cutoff_date) %>%
        summarise(across(-date, ~exp(mean(log(1 + .))) - 1)) %>%
        purrr::as_vector()

    N_Assets <- ncol(return_mat_Nodate)

    # Define constraints
    constraints <- rbind(
        rep(1, N_Assets),  # Sum of weights = 1
        diag(1, N_Assets), # Individual lower bounds
        diag(-1, N_Assets), # Individual upper bounds
        c(rep(0, 9), 1, 1, 1, 1),  # Equity weight ≤ 0.6
        c(0, 1, 1, 1, 1, 1, 1, rep(0, 6)),  # Bond weight ≤ 0.25
        c(1, rep(0, 6), 1, 1, rep(0, 4))    # Other weight ≥ 0.15
    )

    # Constraints directions
    dir <- c(
        "==",                         # Total weight = 1
        rep(">=", N_Assets),          # Individual weights ≥ 0
        rep(">=", N_Assets),          # Individual weights ≤ 0.4
        "<=",                         # Equity group ≤ 0.6
        "<=",                         # Bond group ≤ 0.25
        ">="                          # Other group ≥ 0.15
    )

    # RHS of constraints
    rhs <- c(
        1,                            # Total weight = 1
        rep(0, N_Assets),             # Individual weights ≥ 0
        rep(-0.4, N_Assets),           # Individual weights ≤ 0.4
        0.6,                          # Equity group ≤ 0.6
        0.25,                         # Bond group ≤ 0.25
        0.15                          # Other group ≥ 0.15
    )

    # Build ROI Model
    opt_model <- OP(
        Q_objective(Sigma_LW, -Mu),
        L_constraint(L = constraints, dir = dir, rhs = rhs)
    )

    # Solve optimization
    solution <- ROI_solve(opt_model)
    weights <- solution$solution

    # Format and return results
    Optim_Port <- tibble(Name = colnames(return_mat_Nodate), Weight = round(weights, 5))

    return(Optim_Port)

}