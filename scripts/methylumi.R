if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("methylumi")

library(methylumi)