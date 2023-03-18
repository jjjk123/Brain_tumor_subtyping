library(MethPed)

rm(df)

# loading TCGA data
df <- read.table('/Users/jedrzejkubica/calc/Brain_tumor_subtyping/case1_gdc_download_20230318_114630.778372/24a29403-c6fd-4624-859e-c624f3ec6b67/bf937840-3ea1-4274-9f65-5447df17a125.methylation_array.sesame.level3betas.txt',sep='\t')
df <- read.table('/Users/jedrzejkubica/calc/Brain_tumor_subtyping/case2_gdc_download_20230318_114719.593227/5fb96f09-28cf-4ee8-931a-82728d82b942/e83757d1-e52a-4919-813e-a38cccde2980.methylation_array.sesame.level3betas.txt',sep='\t')

# loading GEO data
df <- read.table('/Users/jedrzejkubica/Downloads/case1_GSM7068256-77631.txt', header=FALSE, sep='\t')

df <- df[-1,]

# Check for missing value 
df <- na.omit(df)

colnames(df)[colnames(df) == "V1"] ="TargetID"
colnames(df)[colnames(df) == "V2"] ="BetaValues"
head(df)

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

