# Creating binned scatterplots
## Default numbers of bins & a linear polynomial
rdplot(dell$Y, dell$margin_victory, p = 1, x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")

## Default numbers of bins & quadratic and cubic polynomials
rdplot(dell$Y, dell$margin_victory, p = 2, x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")
rdplot(dell$Y, dell$margin_victory, p = 3, x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")

## Varying numbers of bins & and a cubic polynomial
rdplot(dell$Y, dell$margin_victory, p = 3, nbins = 10, x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")
rdplot(dell$Y, dell$margin_victory, p = 3, nbins = 20, x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")

rdplot(dell$Y, dell$margin_victory, p = 3, binselect = "es", x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")
rdplot(dell$Y, dell$margin_victory, p = 3, binselect = "qs", x.label = "PAN Victory Margin", y.label = "Homicide Rates", title = "Scatterplot")