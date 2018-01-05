library(ggplot2)
library(RColorBrewer)
library(colorRamps)
library(tidyr)
library(reshape2)

infile = 'tracks/alltracks.bin10000.tab'
df <- read.table(infile,header=T,sep="\t")

head(df)
pdffile= 'plots/Clus_density.pdf'
pdf(pdffile,width=18,height=12)
Title = "Feature density"

ggplot(df, aes(Window, Density)) + geom_point(aes(color=Chr),
                                              alpha=1/2,size=0.5) +
    facet_wrap(~Track, ncol=1,scales="free") + 
    labs(title=Title,xlab="Chrom position (10kb window)") +
    scale_colour_brewer(palette = "Dark2")

