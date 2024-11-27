# Generating the dataset
n <- 5000  ## Setting the number of observations for each combination of x_1 and x_2

## Creating a dataset with all combinations of x_1 and x_2, equally distributed
dataset <- data.table(
  x_1 = rep(c(0, 1, 0, 1), each = n),
  x_2 = rep(c(0, 0, 1, 1), each = n)
)

## Assigning values to z based on the probabilities determined by x_1 and x_2
dataset[, z := fifelse(
  x_1 == 0 & x_2 == 0, rbinom(.N, 1, 2/5),
  fifelse(
    x_1 == 1 & x_2 == 0, rbinom(.N, 1, 1/5),
    fifelse(
      x_1 == 0 & x_2 == 1, rbinom(.N, 1, 3/5),
      rbinom(.N, 1, 4/5)
    )
  )
)]

## Determining the type g (NT, CP, or AT) for each observation based on given probabilities
dataset[, g := {
  p_NT <- 1/3
  p_CP <- 1/6 + x_1 / 6
  p_AT <- 1 - p_NT - p_CP
  
  ## Sampling g based on the computed probabilities
  mapply(function(p_nt, p_cp, p_at) {
    sample(c("NT", "CP", "AT"), size = 1, prob = c(p_nt, p_cp, p_at))
  }, p_NT, p_CP, p_AT)
}]

## Assigning treatment status d based on the type g and the value of z
dataset[, d := fifelse(
  g == "NT", 0, 
  fifelse(
    g == "AT", 1, 
    fifelse(
      g == "CP" & z == 0, 0,  
      1  
    )
  )
)]

## Adding random noise variables epsilon and nu
dataset[, `:=`(
  epsilon = rnorm(.N),  
  nu = rnorm(.N)  
)]

## Generating the outcome variable y based on d and the corresponding equations for y(0) and y(1)
dataset[, y := fifelse(
  d == 0, 
  epsilon,  
  fifelse(
    g == "NT", 2 + 0.5 * x_1 + 1.5 * x_2 + nu,  
    fifelse(
      g == "CP", 6 + 2 * x_1 + x_2 + nu, 
      10 + x_1 + nu  
    )
  )
)]

# Obtaining the 2SLS and Wald estimators
## Running 2SLS regression to estimate the effect of d on y, with x_1 * x_2 as covariates
iv_model <- ivreg(
  y ~ d + x_1 * x_2 | z + x_1 * x_2, 
  data = dataset
)

## Extracting the coefficient for d from the 2SLS model
iv_estimator <- coef(iv_model)[2]

## Running a linear regression of z on x_1 and x_2 (including their interaction)
z_regression <- lm(z ~ x_1 * x_2, data = dataset)

## Extracting the residuals of z from the regression
z_resid <- resid(z_regression)

## Calculating the Wald estimator as the ratio of covariances
wald_estimator <- cov(dataset$y, z_resid) / cov(dataset$d, z_resid)

## Comparing the Wald and 2SLS estimators in a data table
estimators_comparison <- data.table(
  Estimator = c("Wald Estimator", "2SLS Estimator"),
  Value = c(wald_estimator, iv_estimator)
)

## Generating a LaTeX table to present the results
latex_table_2a <- datasummary_df(
  estimators_comparison, 
  output = "latex",
  title = "Comparing the 2SLS and Wald Estimators"
)