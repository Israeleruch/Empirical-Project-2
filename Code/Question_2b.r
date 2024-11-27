# Calculating the conditional LATE

## Defining a function to calculate LATE
calculate_ratio <- function(data_subset) {
  E_y_z0 <- mean(data_subset[z == 0, y])
  E_y_z1 <- mean(data_subset[z == 1, y])
  
  E_d_z0 <- mean(data_subset[z == 0, d])
  E_d_z1 <- mean(data_subset[z == 1, d])
  
  (E_y_z1 - E_y_z0) / (E_d_z1 - E_d_z0)
}

## Grouping the data by (x_1, x_2) and calculating the conditional LATE
con_late_results <- dataset[, .(
  Ratio = calculate_ratio(.SD)
), by = .(x_1, x_2)]

## Presenting the results and appending the true conditional LATE
con_late_table <- data.table(
  x_1 = con_late_results$x_1,
  x_2 = con_late_results$x_2,
  ratio = con_late_results$Ratio
)

con_late_table[, true_ratio := c(6, 8, 7, 9)]

## Generating a LaTeX table to present the results
latex_table_2b <- datasummary_df(
  con_late_table, 
  output = "latex",
  title = "Comparing Estimated and True Conditional LATE"
)