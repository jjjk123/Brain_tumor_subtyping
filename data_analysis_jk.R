library(MethPed)

rm(df)

# loading TCGA data
df <- read.table('/Users/jedrzejkubica/Downloads/gdc_download_20230318_102444.494009/24a29403-c6fd-4624-859e-c624f3ec6b67/bf937840-3ea1-4274-9f65-5447df17a125.methylation_array.sesame.level3betas.txt',sep='\t')
# uknown subtype
df <- read.table('/Users/jedrzejkubica/Downloads/case_2_gdc_download_20230318_110245.344646/5fb96f09-28cf-4ee8-931a-82728d82b942/e83757d1-e52a-4919-813e-a38cccde2980.methylation_array.sesame.level3betas.txt')

# Check for missing value 
df <- na.omit(df)
colnames(df)[colnames(df) == "V1"] ="TargetID"
colnames(df)[colnames(df) == "V2"] ="BetaValues"

df

# run MethPed classification

set.seed(1000)
myClassification <- MethPed(df)

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