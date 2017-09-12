library(ggplot2)

covtable <- read.table("plot_CNV/coverage_by_gene_aggregate.norm.ggplot.tab",sep="\t",header=T)
#covtable <- subset(covtable,covtable$GENE_COUNT > 20)
covtable = subset(covtable,covtable$STRAIN_GROUP == "A")
summary(covtable)
Title="Genome wide normalized coverage plot"

pdffile="plot_CNV/genomewide_CNV_Astrains_all.pdf"

p<- ggplot(covtable,
       aes(x=WINDOW,y=MEDIAN_COVERAGE,color=CHROM)) +
    labs(title=Title,xlab="50 Gene window") +
    geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Dark2") +
    scale_shape(solid = FALSE)
ggsave(pdffile,plot=p,width=12,height=4)

for ( i in c(1:8) ) {
    ctgname = sprintf("Supercontig_1.%d",i)
    covtable_ctg <- subset(covtable, covtable$CHROM == ctgname)
    print(summary(covtable_ctg))
    ctgTitle <- sprintf("SC%d %s",i,Title)
    p <- ggplot(covtable_ctg,
           aes(x=CHROM_WINDOW,y=MEDIAN_COVERAGE,shape=LOCALE,color=STRAIN)) +
        labs(title=ctgTitle,xlab="50 Gene window") +
        scale_shape(solid=F) + geom_point(alpha=1,size=3) 
#+ scale_colour_brewer(palette = "Paired") 
   pdffile = sprintf("plot_CNV/genomewide_CNV_Astrains_SC%d.pdf",i) 
   ggsave(pdffile,plot=p,width=10)        

    p <- ggplot(covtable_ctg,
           aes(x=CHROM_WINDOW,y=MEDIAN_COVERAGE,color=STRAIN)) +
        labs(title=ctgTitle,xlab="50 Gene window") +
        scale_shape(solid=T) + geom_point(alpha=1,size=3)
#+ scale_colour_brewer(palette = "Paired")
   pdffile = sprintf("plot_CNV/genomewide_CNV_Astrains_SC%d_facet.pdf",i)
   ggsave(pdffile,plot=p,width=10)
   for ( j in c("L", "S", "U") ) {
    covLoc = subset(covtable_ctg,covtable_ctg$LOCALE == j)
    ctgTitle <- sprintf("SC%d %s - %s strains",i,Title,j)
    p <- ggplot(covLoc,
   aes(x=CHROM_WINDOW,y=MEDIAN_COVERAGE,shape=LOCALE,color=STRAIN)) +
   labs(title=ctgTitle,xlab="50 Gene window") +
   scale_shape(solid=T) + geom_point(alpha=1,size=3) + scale_colour_brewer(palette = "Paired")
   pdffile = sprintf("plot_CNV/genomewide_CNV_Astrains_SC%d_%s.pdf",i,j)
   ggsave(pdffile,plot=p,width=10)
   }
}


#ggsave(pdffile,g,width=12,height=4)


