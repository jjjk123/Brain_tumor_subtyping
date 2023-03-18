if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("MethPed")

# Loading package
library(MethPed)

# Loading data set
data(MethPed_sample)
head(MethPed_sample)
class(MethPed_sample)

## Check for missing value 
missingIndex <- checkNA(MethPed_sample)
missingIndex

set.seed(1000)

sample <- MethPed_sample

myClassification <- MethPed(MethPed_sample)

myClassification

# First part
myClassification$target_id
# Second part
myClassification$probes
# Third part
myClassification$sample
# Fourth part
myClassification$probes_missing
# Fifth part
myClassification$oob_err.rate
# Sixth part
myClassification$predictions

summary(myClassification)

plot(myClassification)