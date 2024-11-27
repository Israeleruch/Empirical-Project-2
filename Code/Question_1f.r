# Donut Hole Approach

## Computing the initial bandwidth using a non-parametric RDD
pan_effect_np <- rdrobust(dell$Y, dell$margin_victory, p = 1)
band <- pan_effect_np$bws[1, 1]

# Defining a function to estimate effects excluding a fraction of observations around the cutoff
donut_rdd <- function(exclusion_fraction) {
  exclude_lower <- 0 - exclusion_fraction * band
  exclude_upper <- 0 + exclusion_fraction * band
  
  ## Filtering data to exclude observations near the cutoff
  filtered_data <- subset(dell, !(margin_victory >= exclude_lower & margin_victory <= exclude_upper))
  
  ## Running the RDD on the filtered data
  rdrobust(filtered_data$Y, filtered_data$margin_victory, p = 1)
}

## Applying the function for different exclusion fractions
donut_05 <- donut_rdd(0.05)
donut_10 <- donut_rdd(0.1)
donut_20 <- donut_rdd(0.2)

# Extracting results and present them in a table
donut_results <- data.frame(
  Exclusion_Fraction = c(0.05, 0.1, 0.2),
  Estimate = c(donut_05$Estimate[2], donut_10$Estimate[2], donut_20$Estimate[2]),
  Std_Error = c(donut_05$Estimate[4], donut_10$Estimate[4], donut_20$Estimate[4])
)

latex_table_f <- datasummary_df(
  donut_results,
  output = "latex",
  title = "Donut-hole Method"
)

# Robustness to Bandwidth Specification

## Creating a sequence of bandwidths from 0.5x to 1.5x the baseline bandwidth
bandwidths <- seq(0.5 * band, 1.5 * band, by = 0.01 * band)

## Initializing a data frame to store the results
results <- data.frame(
  Bandwidth = numeric(),
  Estimate = numeric(),
  CI_Lower = numeric(),
  CI_Upper = numeric()
)

## Looping through the bandwidths and compute estimates and confidence intervals
for (bw in bandwidths) {
  result <- rdrobust(dell$Y, dell$margin_victory, p = 1, h = bw)
  
  results <- rbind(results, data.frame(
    Bandwidth = bw,
    Estimate = result$Estimate[2],
    CI_Lower = result$ci[3, 1],
    CI_Upper = result$ci[3, 2]
  ))
}

## Plotting the relationship between bandwidth and the estimates
bandwidths_plot <- ggplot(results, aes(x = Bandwidth)) +
  geom_line(aes(y = Estimate), color = "#1d489e", linewidth = 1.2) +
  geom_ribbon(aes(ymin = CI_Lower, ymax = CI_Upper), fill = "#a6bddb", alpha = 0.3) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.8) +
  labs(
    subtitle = "Estimates with Robust Confidence Intervals",
    x = "Bandwidth",
    y = "Estimated Effect (Cases per 100,000)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    panel.grid.major = element_line(color = "gray80", size = 0.5),
    panel.grid.minor = element_blank()
  )
