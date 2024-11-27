# Run the McCary Test
mc_test <- DCdensity(dell$margin_victory, cutpoint = 0, ext.out = TRUE)
abline(v = 0, col = "red", lty = 4, lwd = 2)  # Cutoff line