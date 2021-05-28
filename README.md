# Prochlorococcus-MA

Data processing consists of four parts:

## 1. Mutation calling
The scripts used were adapted from https://github.com/luolab-cuhk/Thermococcus-mut-genome-size

## 2. Phylogenomic tree construction
See scripts in `Prochlo-gnm-tree`

## 3. Population delineation for HLII Prochlorococcus
[PopCOGenT](https://github.com/philarevalo/PopCOGenT) was used to identified panmictic populations (main clusters)

## 4. Pies estimation and linear regression
The scripts for ds calculation were adapted from https://github.com/luolab-cuhk/Thermococcus-mut-genome-size/tree/main/Relationship%20analysis/Pies_calculation

Given the ds may be affected by [novel allelic replacements](https://aem.asm.org/content/84/11/e02545-17), genes showing unusually large ds (outlier) should be ignored.
Since most genomes derievd from SAGs of low completeness, the single copy ortholog gene families are very rare if required to be shared by all strains in one population. Therefor, the absence of gene in some genomes is allowed, which gives rise to ds matrix with missing data. 
The script in `K-means-clustering-for-ds` is for The K means clustering to identify outliers in matrix with missing data.
