# Bounding the effect of PAN mayors on homicide rates

## Computing the non-parametric effect
pan_effect_np <- rdrobust(dell$Y, dell$margin_victory, p = 2)
np_effect <- pan_effect_np$Estimate[2]

## Preparing the variables to loop through
variables <- colnames(candidates)[colnames(candidates) != "id_municipio"]

## Initializing storage for coefficients and estimates
coefficients <- numeric()
estimates <- numeric()

## Looping through variables and compute RDD and OLS
for (variable in variables) {
  rdd_model <- rdrobust(dt[[variable]], dell$margin_victory, p = 2)
  estimate <- rdd_model$Estimate[2]
  estimates <- c(estimates, estimate)

  ## Compute OLS coefficient with robust standard errors
  ols_model <- lm_robust(Y ~ dt[[variable]], data = dt, se_type = "HC1")
  coef_value <- coef(ols_model)[2]
  coefficients <- c(coefficients, coef_value)
}

## Multiplying coefficients by estimates and apply scaling factors
coef_by_estimate <- coefficients * estimates

## Creating a grid of scaled values for 0.5x, 1x, and 1.5x
grid <- data.frame(
  `0.5x` = coef_by_estimate * 0.5,
  `1x` = coef_by_estimate * 1,
  `1.5x` = coef_by_estimate * 1.5
)

## Transposing the grid to make it 3xN (3 rows, N variables)
grid <- t(grid)
colnames(grid) <- variables

## Computing row sums and adjusted values
row_sums <- rowSums(grid)
adjusted_values <- np_effect - row_sums

## Creating the final corrected estimator table
corrected_estimator <- data.frame(
  OLS_Factor = c("0.5x", "1x", "1.5x"),
  Adjusted_Value = adjusted_values
)

## Generating the LaTeX table
latex_table_i <- datasummary_df(
  corrected_estimator, 
  output = "latex",
  title = "Corrected PCRD Estimators with Different Factors"
)
