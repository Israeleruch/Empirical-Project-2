# Setting the random seed
set.seed(1234)

# Importing Packages
library(foreign)
library(haven)
library(data.table)
library(ggplot2)
library(estimatr)
library(modelsummary)
library(rdrobust)
library(rddensity)
library(rdrobust)
library(rdd)
library(AER)

# Reading in the data files and converting into data.table objects
setwd("C:/Users/eruch/Dropbox/Academic/Brown University/Second Year/Fall Semester/Applied Econometrics/Empirical Project 2/Code")

dell <- read_dta("../Data/Dell.dta")
candidates <- read_dta("../Data/Candidates.dta")

dell <- as.data.table(dell)
candidates <- as.data.table(candidates)

# Merging the two data sets
dt <- merge(dell, candidates, by = "id_municipio")

# Sourcing all question files in order
source("Question_1a.r")
source("Question_1c.r")
source("Question_1d.r")
source("Question_1e.r")
source("Question_1f.r")
source("Question_1h.r")
source("Question_1i.r")

source("Question_2a.r")
source("Question_2b.r")
source("Question_2c.r")
source("Question_2e.r")