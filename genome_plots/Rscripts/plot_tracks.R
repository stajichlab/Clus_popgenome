library(ggplot2)
library(RColorBrewer)
library(colorRamps)

infile = 'tracks/alltracks.bin10000.tab'
df <- read.table(infile,header=T,sep="\t")

pdffile= 'plots/Clus_density_10kb_all.pdf'
pdf(pdffile,width=12,height=6)
Title = "Feature density"
df$Chromosome <- df$Chr
df$Track.order = factor(df$Track,levels = c("Genes",
                                            "PopA.SNP.lungonly",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), labels=c("Genes",
                                                                 "SNPs","SNPs_curated",
                                                                 "INDELs",
                                                                 "INDELs_curated",
                                                                 "Repeats"))

ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y")+
    labs(title=Title,xlab="Chrom position (10kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap( ~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (10kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

pdffile= 'plots/Clus_density_10kb.pdf'
pdf(pdffile,width=12,height=5)
Title = "Feature density"
df$Chromosome <- df$Chr
df$Track.order = factor(df$Track,levels = c("Genes",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), 
			labels=c("Genes",
                        "SNPs",
                        "INDELs",
                        "Repeats"))
df <- df[complete.cases(df),]
ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y")+
    labs(title=Title,xlab="Chrom position (10kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap( ~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (10kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()


infile = 'tracks/alltracks.bin50000.tab'
df <- read.table(infile,header=T,sep="\t")
df$Chromosome <- df$Chr

pdffile= 'plots/Clus_density_50kb_all.pdf'
pdf(pdffile,width=12,height=6)
Title = "Feature density"

df$Track.order = factor(df$Track,levels = c("Genes","PopA.SNP.lungonly",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), labels=c("Genes",
                                                                 "SNPs","SNPs_curated",
                                                                 "INDELs",
                                                                 "INDELs_curated",
                                                                 "Repeats"))

ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (50kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (50kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

pdffile= 'plots/Clus_density_50kb.pdf'
pdf(pdffile,width=12,height=5)
Title = "Feature density"
df$Chromosome <- df$Chr
df$Track.order = factor(df$Track,levels = c("Genes",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), labels=c("Genes",
                                                                 "SNPs",
                                                                 "INDELs",
                                                                 "Repeats"))
df <- df[complete.cases(df),]
ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (50kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (50kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()


infile = 'tracks/alltracks.bin20000.tab'
df <- read.table(infile,header=T,sep="\t")
df$Chromosome <- df$Chr

pdffile= 'plots/Clus_density_20kb_all.pdf'
pdf(pdffile,width=12,height=5)
Title = "Feature density"

df$Track.order = factor(df$Track,levels = c("Genes","PopA.SNP.lungonly",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), labels=c("Genes",
                                                                 "SNPs","SNPs_curated",
                                                                 "INDELs",
                                                                 "INDELs_curated",
                                                                 "Repeats"))

ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (20kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (20kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()


pdffile= 'plots/Clus_density_20kb.pdf'
pdf(pdffile,width=12,height=5)
Title = "Feature density"
df$Chromosome <- df$Chr

df$Track.order = factor(df$Track,levels = c("Genes",
                                            "PopA.SNP.lungonly_curated",
                                            "PopA.INDEL.lungonly_curated",
                                            "repeats"), labels=c("Genes",
                                                                 "SNPs",
                                                                 "INDELs",
                                                                 "Repeats"))
df <- df[complete.cases(df),]
head(df)
ggplot(df, aes(Window, Density)) + geom_line(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (20kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chromosome),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track.order, ncol=1,scales="free_y") +
    labs(title=Title,xlab="Chrom position (20kb window)") +
    scale_colour_brewer(palette = "Dark2") + theme_minimal()


