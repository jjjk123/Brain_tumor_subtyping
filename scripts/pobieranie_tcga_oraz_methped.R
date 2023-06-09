# skrypt do pobierania danych z tcga pakietem GenomicDataCommons i przekazywania do MethPed 
# na razie bez filtrowania czy pediatryczne czy nie, tylko sprawdzenie czy działa

# Constants (values to customise):
AGE <- 18
NR_OF_TOTAL_SAMPLES_TO_DOWNLOAD<- 3
PROJECT_ID <- 'TCGA-GBM'
PLATFORM <- "illumina human methylation 450"

library(GenomicDataCommons)
library(MethPed)
# połączenie API - powinno zwracać status OK
GenomicDataCommons::status()

# szukanie plików z konkretnego projektu tutaj akurat 
# https://www.cancer.gov/ccg/research/genome-sequencing/tcga/studied-cancers/glioblastoma-multiforme-study
# zawierających dane o metylacji
ge_manifest <- files() |>
  filter( cases.project.project_id == PROJECT_ID) |>
  filter( type == 'methylation_beta_value' ) |>
  filter(cases.demographic.days_to_birth < -AGE*365) |> # filtrowanie wieku PAMIĘTAĆ O MINUSIE
  filter(platform == PLATFORM) |>
  manifest()
ge_manifest
# ge_manifest zawiera informacje o plikach ale jeszcze nie dane

# dla każdego id pliku z ge_manifest ściągamy dane funckją gdcdata
# za pierwszym razem może zapytać czy stworzyć folder, odpowiadamy że tak

#To dowload all the file (do not recommend if you don't know the size)
#fnames = lapply(ge_manifest$id, gdcdata) # ogólnie lepiej nie ściągać od razu wszystkiego

#To download desired amount of samples
fnames = lapply(ge_manifest$id[1:NR_OF_TOTAL_SAMPLES_TO_DOWNLOAD], gdcdata)
# bo jest bardzo dużo tutaj można zaindeksować np. ge_manifest$id[1:5]
# albo wyżej przy tworzeniu ge_manifest dać więcej filtrów
# fnames to named list ze ścieżkami pobranych plików .txt
# wczytanie pojedynczego pliku
example = read.delim(fnames[[1]][[1]], header = FALSE)
head(example)
# trzeba zmienić nazwę kolumny V1 na TargetID - tak wymaga MethPed
# nazwa drugiej kolumny jest nieistotna dla MethPed ale może być przydatna do dalszej analizy
example = dplyr::rename(example, c('TargetID' = 'V1'))
MethPed::MethPed(example)

# wczytanie i połączenie wszystkich danych do postaci, którą można wrzucić do MethPed
data = data.frame(TargetID = character(), V2 = numeric(), id = character())
i = 1
for(x in fnames){
  print(i)
  temp_data = read.delim(x[[1]], header = FALSE)
  temp_data = dplyr::rename(temp_data, c('TargetID' = 'V1'))
  temp_data$id = rep(names(fnames[[i]]), nrow(temp_data))
  data = dplyr::bind_rows(data, temp_data)
  i = i+1
}
data = tidyr::pivot_wider(data, names_from = id, values_from = V2)

# sprawdzanie braków danych i użycie MethPed jeśli w datasecie są wszystkie potrzebne probes
# w innym przypadku trzeba uzupełnić braki jak w readme dla MethPed
library(MethPed)
if (is.null(probeMis(data))){
  methped_predictions = MethPed(tidyr::drop_na(as.data.frame(data)), prob = FALSE)
}

print(methped_predictions$predictions)
