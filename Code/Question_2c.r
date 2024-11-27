# Verifying the Angrist and Imbens result
## Calculating the means of d conditional on x_1, x_2, and z
d_xz_table <- dataset[, .(
  d_xz = mean(d)
), by = .(x_1, x_2, z)]

## Calculating the variances of the means conditional on x_1 and x_2
v_d_x_table <- d_xz_table[, .(
  v_d_x = var(d_xz)
), by = .(x_1, x_2)]

## Normalizing the variances
v_d_x_table[, e_v_d_x := v_d_x / mean(v_d_x)]

## Obtaining the Angrist and Imbens estimator
ai_estimator <- mean(v_d_x_table$e_v_d_x * con_late_results$Ratio)

## Comparing the two estimators
estimators_comparison_c <- data.table(
  Estimator = c("AI Estimator", "2SLS Estimator"),
  Value = c(ai_estimator, iv_estimator)
)

## Generating a LaTeX table to present the results
latex_table_2c <- datasummary_df(
  estimators_comparison_c, 
  output = "latex",
  title = "Comparing the A-I and 2SLS Estimators"
)

## Generating a LaTeX table to present weights
latex_table_2c_weight <- datasummary_df(
  v_d_x_table, 
  output = "latex",
  title = "Conditional LATE weights"
)