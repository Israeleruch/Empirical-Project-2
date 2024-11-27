# Testing discontinuities in candidate characteristics

## Excluding the "id_municipio" column from the variables of interest
variables <- colnames(candidates)[colnames(candidates) != "id_municipio"]

## Specifying folder for saving plots
graphs_folder <- "../Graphs"

## Looping through each variable to generate RDD plots at the cutoff
for (variable in variables) {
  y_label <- variable 
  file_name <- paste0(graphs_folder, "/rdplot_", variable, ".png") 

  # Saving the RDD plot as a PNG
  png(file_name, width = 800, height = 600)
  rdplot(
    y = dt[[variable]],               
    x = dt$margin_victory,            
    p = 2,                            
    nbins = 20,                       
    x.label = "PAN Victory Margin",   
    y.label = y_label                 
  )
  dev.off()  
}
