#/usr/bin/Rscript

library(ballgown)
library(dplyr)
load("results/de/ballgown.RData")

pheno_data <- read.csv("results/de/pheno_data.tsv") %>% arrange(ids)

# Prepare color palette
tropical <- c("darkorange", "dodgerblue", "hotpink", "limegreen", "yellow")
palette(tropical)

# Show FPKM distribution
fpkm = texpr(bg_chrX, meas="FPKM")
fpkm = log2(fpkm + 1)
pdf("results/de/fpkm_boxplot.pdf", width=6, height=4, paper='special')
boxplot(
    fpkm,
    col=as.numeric(pheno_data$sex),
    las=2,
    ylab='log2(FPKM+1)'
)
dev.off()

## Plot transcript across different samples
ballgown::transcriptNames(bg_chrX)[12]
ballgown::geneNames(bg_chrX)[12]
pdf("results/de/NM_012227.pdf", width=6, height=4, paper='special')
plot(
    fpkm[12,] ~ pheno_data$sex,
    border=c(1,2),
    main=paste(ballgown::geneNames(bg_chrX)[12], ' : ', ballgown::transcriptNames(bg_chrX)[12]),
    pch=19,
    xlab="Sex",
    ylab="log2(FPKM+1)"
)
points(
    fpkm[12,] ~ jitter(as.numeric(pheno_data$sex)),
    col=as.numeric(pheno_data$sex)
)
dev.off()

# Plot the structure and expression levels of all transcripts that share the same gene locus
pdf("results/de/xist.pdf", width=6, height=4, paper='special')
plotTranscripts(
    ballgown::geneIDs(bg_chrX)[1729],
    bg_chrX,
    main=c("Gene XIST in sample ERR188234"),
    sample=c("ERR188234")
)
dev.off()

# Plot average transcription levels for all transcripts of a gene....
pdf("results/de/plotMeans.pdf", width=6, height=4, paper='special')
plotMeans(
    'MSTRG.56',
    bg_chrX_filt,
    groupvar="sex",
    legend=FALSE
)
dev.off()
