## Load packages
####################
library('magrittr')
library('DESeq2')
library('tibble')
library('ggplot2')
# set workdir
######################
setwd('~/R/count_deseq2')

# align the data
#####################
count_data <- read.table('biotype_counts_genome_processed.txt', header = TRUE)
head(count_data)
rownames(count_data) <- count_data$Geneid
count_data <- count_data[,-1]
colnames(count_data) <- gsub('\\.[sb]am$', '', colnames(count_data))
head(count_data)

count_matrix <- as.matrix(count_data)
head(count_matrix)


# set colData and dds
##########################
condition <- factor(c('Somata', 'Somata', 'Somata', 'Neuropil', 'Neuropil', 'Neuropil'))
coldata <- data.frame(row.names = colnames(count_matrix), 
                      condition = condition)

dds <- DESeqDataSetFromMatrix(countData = count_matrix, 
                              colData = coldata, 
                              design = ~ condition)
dds <- dds[rowSums(counts(dds)) > 10, ]
dds
dds <- DESeq(dds)

# normalize dds
norm <- estimateSizeFactors(dds)
write.table(counts(norm, normalized = T), "Normalized.csv", col.names = T, sep = ",")

# Regularize log transformation 
rld <- rlog(dds)
print(rld)

# Principal components analysis
plotPCA(rld)

# res
resultsNames(ddsnorm)
res <- results(dds, name = 'condition_Somata_vs_Neuropil')
res
resOrdered <- res[order(res$pvalue),]
resSig <- subset(resOrdered, padj < 0.05)
write.csv(as.data.frame(resSig),
          file="condition_treated_results_sig.csv")

resGA <- results (dds, lfcThreshold = 0.50, altHypothesis="greaterAbs", alpha = 0.05) 
resGA
plotMA(resGA)

data <- plotPCA(rld, returnData = T)
data
