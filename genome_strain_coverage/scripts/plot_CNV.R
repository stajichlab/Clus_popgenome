library(ggplot2)

covtable <- read.table("plot_CNV/coverage_by_gene_aggregate.norm.ggplot.tab",sep="\t",header=T)
#covtable <- subset(covtable,covtable$GENE_COUNT > 20)
summary(covtable)
Title="Genome wide normalized coverage plot"

pdffile="plot_CNV/genomewide_CNV.pdf"
pdf(pdffile,width=12,height=4)

ggplot(covtable,
       aes(x=WINDOW,y=MEDIAN_COVERAGE,color=CHROM,shape=STRAIN_GROUP)) +
    labs(title=Title,xlab="50 Gene window") +
    geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Dark2") +
    scale_shape(solid = FALSE)

for ( i in c(1:8) ) {
    ctgname = sprintf("Supercontig_1.%d",i)
    covtable_ctg <- subset(covtable, covtable$CHROM == ctgname)
    ctgTable <- sprintf("SC%d %s",i,Title)
    ggplot(covtable_ctg,
           aes(x=WINDOW,y=MEDIAN_COVERAGE,color=CHROM)) +
        labs(title=ctgTitle,xlab="50 Gene window") +
        geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Dark2") +
        scale_shape(solid = FALSE)
    }

#ggsave(pdffile,g,width=12,height=4)


