## Estimating the effect of a PAN mayor on the homicide rate non-parametrically
pan_effect_np_1 <- rdrobust(dell$Y, dell$margin_victory, p = 1)
pan_effect_np_2 <- rdrobust(dell$Y, dell$margin_victory, p = 2)
band <- pan_effect_np_2$bws[1,1]

## Estimating the effect of a PAN mayor on the homicide rate parametrically (using OLS)
truncated_data <- subset(dell, margin_victory >= -band & margin_victory <= band)
truncated_data$D <- ifelse(truncated_data$margin_victory >= 0, 1, 0)  

ols_model_1 <- lm_robust(Y ~ margin_victory + D, data = truncated_data, se_type = "HC1")
ols_model_2 <- lm_robust(Y ~ margin_victory + I(margin_victory^2) + D, data = truncated_data, se_type = "HC1")  

## Extracting and presenting the estimators
np_effect_1 <- pan_effect_np_1$Estimate[2]
np_se_1 <- pan_effect_np_1$Estimate[4]

np_effect_2 <- pan_effect_np_2$Estimate[2]
np_se_2 <- pan_effect_np_2$Estimate[4]

ols_effect_1 <- coef(ols_model_1)["D"]
ols_se_1 <- summary(ols_model_1)$coefficients["D", "Std. Error"]

ols_effect_2 <- coef(ols_model_2)["D"]
ols_se_2 <- summary(ols_model_2)$coefficients["D", "Std. Error"]

## Creating a results table for presentation
results_table <- data.frame(
  Method = c("Non-parametric (Linear)",        
             "Non-parametric (Quadratic)",     
             "OLS (Linear)",                   
             "OLS (Quadratic)"),               
  Estimate = c(np_effect_1, np_effect_2, ols_effect_1, ols_effect_2),  
  `Standard Error` = c(np_se_1, np_se_2, ols_se_1, ols_se_2)            
)

## Generating a LaTeX table for the results
latex_table_e <- datasummary_df(
  results_table, 
  output = "latex", 
  title = "Causal Effect Estimates for Different Specifications"
)