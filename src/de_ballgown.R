#!/usr/bin/env Rscript

# R script with sections from Pertea et al. 2016


library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(dplyr)
library(devtools)

# Read phenotype data
pheno_data <- read.csv("results/de/pheno_data.tsv") %>% arrange(ids)

# Read expression data
bg_chrX <- ballgown(
    dataDir="results/quant/",
    samplePattern="ERR",
    pData=pheno_data
)

# Filter to remove low abundance genes
bg_chrX_filt <- subset(
    bg_chrX,
    "rowVars(texpr(bg_chrX)) > 1",
    genomesubset=TRUE
)

# Identify transcripts that show statistically significant differences between groups
results_transcripts <- stattest(
    bg_chrX_filt,
    feature="transcript",
    covariate="sex",
    adjustvars=c("population"),
    getFC=TRUE,
    meas="FPKM"
)

# Identify genes that show statistically significant differences between groups
results_genes = stattest(
    bg_chrX_filt,
    feature="gene",
    covariate="sex",
    adjustvars=c("population"),
    getFC=TRUE,
    meas="FPKM"
)

# Add gene names and gene ids to results_transcripts
results_transcripts <- data.frame(
    geneNames=ballgown::geneNames(bg_chrX_filt),
    geneIDs=ballgown::geneIDs(bg_chrX_filt),
    results_transcripts
)

# Sort from low p-value to higher
results_transcripts = arrange(results_transcripts, pval)
results_genes = arrange(results_genes, pval)

# Write results to csv
write.csv(results_transcripts, "results/de/chrX_transcript_results.csv", row.names=FALSE)
write.csv(results_genes, "results/de/chrX_gene_results.csv", row.names=FALSE)

# Identify transcripts and genes with q value < 0.05
subset(results_transcripts, results_transcripts$qval < 0.05)
subset(results_genes, results_genes$qval < 0.05)



save(bg_chrX, bg_chrX_filt, file="results/de/ballgown.RData")
