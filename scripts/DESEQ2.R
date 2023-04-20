library('DESeq2')
library('ggplot2')
library('dplyr')


SampleName = snakemake@config[['LIST_SAMPLES']]
SampleCondition = snakemake@config[['LIST_SAMPLES_BIO']]
cutoff_1 <- as.numeric(snakemake@config[['Threshold_Padj']])
cutoff_2 <- as.numeric(snakemake@config[['Threshold_logFC']])
out_table <- snakemake@output[["deseq2output"]]
name_ctl = snakemake@config[['CTL_NAME']]
name_stim = snakemake@config[['STIM_NAME']]
datainput <- read.table(snakemake@input[['ExpTable']], sep="\t",check.names=FALSE)

##########################################
datainput = datainput[,SampleName]
rawcounts = datainput[-c(1:4),]
rawcounts = rawcounts[rowSums(rawcounts[])>0,]

######################################

sampleid = SampleName
condition = SampleCondition

coldata = data.frame(condition)
rownames(coldata)=sampleid

dds <- DESeqDataSetFromMatrix(countData = rawcounts,
                              colData = coldata,
                              design = ~ condition)

dds$condition <- relevel(dds$condition, ref = name_ctl)
dds$sampleid <- sampleid

vsd <- vst(dds)


### PCA plot ###

fig_1 <- plotPCA(vsd, intgroup=c("sampleid",'condition'))+theme_classic()+theme(legend.title = element_blank())
ggsave(snakemake@output[["plotPCA"]], plot = fig_1)

#### DEG Analysis
dds <- DESeq(dds)

res_12 <- results(dds,contrast = c('condition',name_stim,name_ctl))
summary(res_12)

res_12_data = data.frame(res_12)
res_12_data = na.omit(res_12_data)

res_12_data$DEG <- 'No'
res_12_data[(res_12_data$padj < cutoff_1) & (res_12_data$log2FoldChange > cutoff_2),'DEG'] <-'Up-regulated'
res_12_data[(res_12_data$padj < cutoff_1) & (res_12_data$log2FoldChange < -cutoff_2),'DEG'] <-'Down-regulated'

res_12_data$DEG <- factor(res_12_data$DEG, levels = c('Up-regulated','Down-regulated','No'))

write.table(res_12_data, out_table, sep="\t")


### Volcano plot ###

fig_2<- ggplot(res_12_data, aes(x=log2FoldChange, y=-log10(padj), col=DEG)) +
  geom_point(size=1,alpha=0.8) + theme_classic()+
  scale_color_manual(values=c('#FF66FF','#0099CC','#CCCCCC'))+
  theme(axis.title = element_text(size=12),
        legend.text = element_text(size=12),legend.title = element_text(size=12))

ggsave(snakemake@output[["plotVolcano"]],device='png',plot = fig_2)
