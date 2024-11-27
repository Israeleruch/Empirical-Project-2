# Identifying and calculating unconditional LATE

## Calculating the unconditional LATE
uncon_late <- mean(con_late_table$ratio)

## Calculating the true unconditional LATE
uncon_late_true <- mean(con_late_table$true_ratio)

## Comparing the estimator and the true value
uncon_table <- data.table(
  "Unconditional LATE" = uncon_late,
  "True Unconditional LATE" = uncon_late_true
)

## Generating a LaTeX table to present the results
latex_table_2e <- datasummary_df(
  uncon_table, 
  output = "latex",
  title = "Comparing Estimated and True Unconditional LATE"
)