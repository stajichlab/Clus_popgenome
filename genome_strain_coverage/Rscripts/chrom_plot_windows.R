library(ggplot2)
library(RColorBrewer)
library(colorRamps)

infile = "plot_CNV/coverage_by_gene_aggregate.norm.ggplot.tab"
ggenes <- read.table(infile,header=T,sep="\t")
Title="Genome wide normalized coverage plot w GC-Bias correction"

ggenes <- subset(ggenes, ggenes$MEDIAN_COVERAGE < 5)
pdffile="plots/Genomewide_coverage_by_genewindow.pdf"
pdf(pdffile,width=18,height=6)
ggplot(ggenes,
       aes(x=WINDOW,y=MEAN_COVERAGE,color=factor(CHROM),size=factor(GROUP))) +
    labs(title=Title,xlab="20 gene window") +
    geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Dark2") +
    scale_shape(solid = FALSE)


infile = "plot_CNV_noGCbias/coverage_by_gene_aggregate.norm.ggplot.tab"
ggenes <- read.table(infile,header=T,sep="\t")
Title="Genome wide normalized coverage plot NO GC-Bias correction"

ggenes <- subset(ggenes, ggenes$MEDIAN_COVERAGE < 5)
pdffile="plots/Genomewide_coverage_by_genewindow_noGCcor.pdf"
pdf(pdffile,width=18,height=6)
ggplot(ggenes,
       aes(x=WINDOW,y=MEAN_COVERAGE,color=factor(CHROM),size=factor(GROUP))) +
    labs(title=Title,xlab="20 gene window") +
    geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Dark2") +
    scale_shape(solid = FALSE)

