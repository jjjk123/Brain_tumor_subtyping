# Script for downloading TCGA datasets using GenomicDataCommons and forwarding example data sample to MethPed

# Constants (values to customise):
AGE <- 18
NR_OF_TOTAL_SAMPLES_TO_DOWNLOAD<- 3
PROJECT_ID <- 'TCGA-GBM'
PLATFORM <- "illumina human methylation 450"

library(GenomicDataCommons)
library(MethPed)


# connection with API - should return OK status
GenomicDataCommons::status()

# searching files from specific project "TCGA-GBM" 
# https://www.cancer.gov/ccg/research/genome-sequencing/tcga/studied-cancers/glioblastoma-multiforme-study

ge_manifest <- files() |>
  filter( cases.project.project_id == PROJECT_ID) |>
  filter( type == 'methylation_beta_value' ) |>
  filter(cases.demographic.days_to_birth < -AGE*365) |> # filtrowanie wieku PAMIĘTAĆ O MINUSIE
  filter(platform == PLATFORM) |>
  manifest()


# ge_menifest has information about files (this is not actual data!)
ge_manifest

# First we pop a question to create a directory, for all the files
# For every id file from ge_manifest, we download it for gdcdata

#To dowload all the files (do not recommend if you don't know the size)
#fnames = lapply(ge_manifest$id, gdcdata)

#To download desired amount of samples
fnames = lapply(ge_manifest$id[1:NR_OF_TOTAL_SAMPLES_TO_DOWNLOAD], gdcdata)

# fnames is a named list with directories of downloaded files .txt

#Loading sample file
example = read.delim(fnames[[1]][[1]], header = FALSE)
head(example)

# Customizing downloaded data for MethPed
data = data.frame(TargetID = character(), BetaValues = numeric(), id = character())
i = 1
for(x in fnames){
  print(i)
  temp_data = read.delim(x[[1]], header = FALSE)
  temp_data = dplyr::rename(temp_data, c('TargetID' = 'V1', 'BetaValues' = 'V2'))
  temp_data$id = rep(names(fnames[[i]]), nrow(temp_data))
  data = dplyr::bind_rows(data, temp_data)
  i = i+1
}
data = tidyr::pivot_wider(data, names_from = id, values_from = V2)

# Warning: If sample consists of a lot of NA, this is not a good way. (to do)
# Dropping NA 
if (is.null(probeMis(data))){
  methped_predictions = MethPed(tidyr::drop_na(as.data.frame(data)), prob = FALSE)
}

# Predictions
print(methped_predictions$predictions)

# Plot
plot(methped_predictions)
