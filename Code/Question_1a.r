# Estimating the regression equation by OLS
model <- lm_robust(Y ~ PANwin, data = dell, se_type = "HC1")
modelsummary(model, output = "latex", stars = TRUE)