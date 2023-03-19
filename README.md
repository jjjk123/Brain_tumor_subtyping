# *Project 1: Brain tumor subtyping*

<img width="700" alt="brainhack2023_logo" src="https://user-images.githubusercontent.com/82537630/226144785-7b7856c4-9431-404c-b38e-1bbb06694c89.png">



## Contributors

- Jędrzej Kubica (jj.kubica@student.uw.edu.pl)
- Urszula Baranowska (umbaranowska@gmail.com)
- Julia Barczuk  (julia.barczuk@stud.umed.lodz.pl)
- Paulina Domek (p.domek68@gmail.com)
- Katarzyna Grad (k.grad@student.uw.edu.pl)
- Milena Królikowska (mm.krolikows@uw.edu.pl)
- Weronika Plichta (plichta.weronika@gmail.com)
- Justyna Wiśniewska (j.wisniewska@nencki.edu.pl)


## Introduction

Classifying pediatric brain tumors into molecular subtypes profoundly determines appropriate treatment options selection as well as patients’ survival prediction.

Therefore, it is of great importance to efficiently classify patients into specific subgroups depending on their epigenome’s molecular characteristics- one of which, playing a pivotal role, is their methylation profile. 
To achieve that, we validated the efficiency of Methped. Methped is an already-developed, open-access tool for brain tumor diagnosis and subgroup identification. Via analyzing genome-wide DNA methylation array data, Methped is able to accurately classify a brain tumor to one of the 9 most prevalent pediatric brain tumor clinical groups.
These 9 groups consist of: pilocytic astrocytoma, high-grade glioma/glioblastoma (GBM), diffuse intrinsic pontine glioma (DIPG), ependymoma, and primitive neuroectodermal tumor of the CNS (CNS-PNET), medulloblastoma (cerebellar PNET) or supratentorial PNET (sPNET). 

The goal of the project is to develop a data analysis workflow to analyze publicly-available epigenetic data of brain tumor patients from various databases, such as The Cancer Genome Atlas and Gene Expression Omnibus.

Future work will include subtype-specific drug recommendations. Further research can also be extended from pediatric brain tumors into adult tumors of the nervous system.


## Methods

Methylation data for 4 pediatric (< 18 y/o) patients with brain tumors was used in the project (TCGA IDs: TCGA-12-1091, TCGA-HT-7483, TCGA-DB-5278; GEO Accession: GSM7068256). Additionally, we modified the TCGA data search, so that it finds more samples for a given patient, thus improving the validity of the result. Data for case 5 (TCGA ID: TCGA-19-5959) contained 3 samples.


MethPed is an open-source tool for classification of pediatric brain tumours into clinically-relevant groups based on genome-wide methylation data. The algorithm was trained on a dataset of 400+ publicly available methylation data deposited at GEO, which included classification of the cancer into groups and subgroups. The data was merged into one dataset which included methylation degree result for probes present in all samples. It uses a Random Forest algorithm to group the data based on methylation of 100 probes which were selected with the use of regression analysis to fit classifier subgroups in an optimal way. For input data, MethPed calculates the probability of the sample belonging to each classifier group. The model was validated with methylation data acquired from frozen tissue samples, for which expert classification was already performed. 

The tool classifies pediatric brain tumours with great accuracy, allowing for greater understanding of their biology and facilitating diagnosis (for example when working with cancer cells present in the cerebrospinal fluid or in the case of presence of cells with mixed morphology) and research into their treatment. 


We have decided to use MethPed to examine how such tools work with different datasets - if they correctly classify pediatric brain tumours when using methylation data from datasets not used to train the model, and if data originating from completely different cancers is not forcefully classified into pre-set categories. Having verified that our pipeline for data collection and package usage works as intended, we would like to try to develop a similar tool for analysis of gene expression in cancers of selected origin during future hackatons.

## Workflow

![obraz](https://user-images.githubusercontent.com/61021185/226114491-bda9ca3f-a16f-4033-acf3-cfaf41d543e1.png)



## Results

### Case 1 (ID: TCGA-12-1091)

Primary diagnosis: glioblastoma

MethPed diagnosis: glioma/glioblastoma

The result confirms the primary diagnosis given by the clinician.

![plot_case1](https://user-images.githubusercontent.com/82537630/226108606-b0a8f2ed-dee2-4655-9fa8-95d932c27b68.png)

OOB error rate = 7.460036

### Case 2 (ID: TCGA-HT-7483)

Primary diagnosis: Brain Lower Grade Glioma

MethPed diagnosis: glioma/glioblastoma

The result also confirms the primary diagnosis given by the clinician.

<img width="443" alt="plot_case2" src="https://user-images.githubusercontent.com/82537630/226108613-2b06d866-0ab0-4fbc-a8be-15d77875abf4.png">

OOB error rate = 1.776199 

### Case 3 (ID: TCGA-DB-5278)

Primary diagnosis: Brain Lower Grade Glioma

MethPed diagnosis: diffuse intrinsic pontine glioma

The result suggests that additional test might be useful to confirm the diagnosis.

![plot_case3](https://user-images.githubusercontent.com/82537630/226108621-1018492f-63bd-4b3f-be87-aa8fa88e874c.png)

OOB error rate = 2.131439

### Case 4 (GEO Accession: GSM7068256)

Primary diagnosis: pediatric brain tumor

MethPed diagnosis: Medulloblastoma

The result narrows down the diagnosis from 'pediatric brain tumor' to 'medulloblastoma', however it does not specify any subtype of medulloblastoma.

![geo_case1](https://user-images.githubusercontent.com/82537630/226114400-8c69f5d3-ca78-40ce-9053-576426e969e4.png)

OOB error rate: 1.953819

### Case 5 (ID: TCGA-19-5959)

Primary diagnosis: Glioblastoma Multiforme

MethPed diagnosis: glioma/glioblastoma

![tumor](https://user-images.githubusercontent.com/103688816/226181437-01459903-2ca8-4f6e-9852-3e71dddad97c.png)

The result shows the same diagnosis for 3 different samples from the same patient. It can be assumed that more samples indicating the same diagnosis might serve as a confirmation of the final diagnosis.

## Discussion

In the project, we validated an open-source software MethPed as a potentially useful tool for clinical application. Although some results might require additional confirmation, however MethPed could serve as a confirmation test for the primary diagnosis.


## Script for automation

We've create script for downloading TCGA datasets using GenomicDataCommons and forwarding example data sample to MethPed

Customatization: (you can change all the desired values)
```
# Constants (values to customise):
AGE <- 18
NR_OF_TOTAL_SAMPLES_TO_DOWNLOAD<- 3
PROJECT_ID <- 'TCGA-GBM'
PLATFORM <- "illumina human methylation 450"
```
Steps:

1. Downloading filtered samples from specific dataset.
```
ge_manifest <- files() |>
  filter( cases.project.project_id == 'PROJECT_ID') |>
  filter( type == 'methylation_beta_value' ) |>
  filter(cases.demographic.days_to_birth < -AGE*365) |>
  filter(platform == PLATFORM) |>
```
2. It prepares it to run MethPed classification. For now there is an example with one sample(file).
3. It runs MethPed classification with proccesed sample
```
if (is.null(probeMis(data))){
  methped_predictions = MethPed(tidyr::drop_na(as.data.frame(data)), prob = TRUE)
}
```
## Future ideas

- adults
- other brain tumor subtypes
- treatment recommendation


## References

1. Ahamed M, Danielsson A, Nemes S, Carén H (2022). MethPed: A DNA methylation classifier tool for the identification of pediatric brain tumor subtypes. R package version 1.26.0.

2. Davis S, Du P, Bilke S, Triche, Jr. T, Bootwalla M (2022). methylumi: Handle Illumina methylation data. R package version 2.44.0.

The results shown here are in whole or part based upon data generated by the TCGA Research Network: https://www.cancer.gov/tcga.
