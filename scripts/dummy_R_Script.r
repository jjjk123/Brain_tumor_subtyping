#Installing MethPed library
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("MethPed")
library(MethPed)
data(MethPed_sample)
MethPed_sample_v1<- MethPed_sample


#Commands for view dataset MethPed_sample
head(MethPed_sample_v1)
summary(MethPed_sample_v1)
dim(MethPed_sample)
colnames(MethPed_sample)
View(MethPed_sample)

#Executing MethPed model
set.seed(1000)
myClassification <- MethPed(MethPed_sample)
