library(ggplot2)

sampleMAF <- read.csv("all_C_strains.MAF.csv",header=T);
sampleMAF <- subset(sampleMAF, sampleMAF$CHR != "MT_CBS_6936")
head(sampleMAF)

mafPlot <- ggplot(sampleMAF,aes(x=POS,y=MINOR_AF)) +
    geom_jitter(aes(color=STRAIN)) +
facet_wrap(~ CHR,ncol=1) +
    ggtitle("Minor Allele Freq plotted across chrom") + xlab("SNP pos") + ylab("MAF")
pdf("MAF_plot.Cstrains.pdf",5000,2500)
print(mafPlot)
dev.off()


png("MAF_plot.Cstrains.png",5000,2500)
print(mafPlot)
dev.off()
