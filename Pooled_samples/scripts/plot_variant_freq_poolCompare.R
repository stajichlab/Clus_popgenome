library(ggplot2)

sampleMAF <- read.csv("Lower_strains.MAF.csv",header=T);
sampleMAF <- subset(sampleMAF, sampleMAF$CHR != "MT_CBS_6936")

sampleMAF$POOL <- ifelse(sampleMAF$STRAIN == 'LowerP','POOLED','SINGLE') 
head(sampleMAF)
LowermafPlot <- ggplot(sampleMAF,aes(x=POS,y=MINOR_AF)) +
    geom_point(aes(color=POOL)) +
facet_wrap(~ CHR,ncol=1) +
    ggtitle("LowerPool Non-Ref allele freq plotted across chrom excluding fixed position") + xlab("SNP pos") + ylab("MAF")
pdf("MAF_plot.Lower.pdf",5000,2500)
print(LowermafPlot)
dev.off()
png("MAF_plot.Lower.png",5000,2500)
print(LowermafPlot)
dev.off()

sampleMAF <- read.csv("Upper_strains.MAF.csv",header=T);
sampleMAF <- subset(sampleMAF, sampleMAF$CHR != "MT_CBS_6936")

sampleMAF$POOL <- ifelse(sampleMAF$STRAIN == 'UpperP','POOLED','SINGLE') 
head(sampleMAF)
UppermafPlot <- ggplot(sampleMAF,aes(x=POS,y=MINOR_AF)) +
    geom_point(aes(color=POOL)) +
facet_wrap(~ CHR,ncol=1) +
    ggtitle("UpperPool Non-Ref allele freq plotted across chrom excluding fixed position") + xlab("SNP pos") + ylab("MAF")
pdf("MAF_plot.Upper.pdf",5000,2500)
print(UppermafPlot)
dev.off()
png("MAF_plot.Upper.png",5000,2500)
print(UppermafPlot)
dev.off()

sampleMAF <- read.csv("Sputum_strains.MAF.csv",header=T);
sampleMAF <- subset(sampleMAF, sampleMAF$CHR != "MT_CBS_6936")

sampleMAF$POOL <- ifelse(sampleMAF$STRAIN == 'SputuP','POOLED','SINGLE') 
head(sampleMAF)
SputummafPlot <- ggplot(sampleMAF,aes(x=POS,y=MINOR_AF)) +
    geom_point(aes(color=POOL)) +
facet_wrap(~ CHR,ncol=1) +
    ggtitle("SputumPool Non-Ref allele freq plotted across chrom excluding fixed position") + xlab("SNP pos") + ylab("MAF")
pdf("MAF_plot.Sputum.pdf",5000,2500)
print(SputummafPlot)
dev.off()
png("MAF_plot.Sputum.png",5000,2500)
print(SputummafPlot)
dev.off()
