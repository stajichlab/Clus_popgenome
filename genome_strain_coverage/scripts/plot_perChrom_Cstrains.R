library(ggplot2)

for ( i in c(1:8) ) {
    filename=sprintf("plot/Supercontig_1.%d.gene_cov_norm.gg.tab", i)
    pdffile = sprintf("plot/SC_%d_Cstrains.pdf",i)
    Title=sprintf("SC %d - all strains",i)
    cov = read.table(filename,header=T,sep="\t")
    groups = cov$GROUP
    covA = subset(cov,cov$GROUP =="C")
    print(summary(covA))
#    print(covA)
    
    covA$GENENUM =as.numeric(gsub("CLUG_","",covA$GENE))
    maxGene= max(covA$GENENUM)
    print(maxGene)
    g = ggplot(covA,aes(GENENUM,COVERAGE,color=STRAIN,shape=LOCALE,
                        group=LOCALE)) +
    labs(title=Title,xlab="CLUG Locus") + 
    geom_point(alpha=1,size=1) +
    scale_shape(solid = F) +
    scale_fill_identity(guide = "legend") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
    ggsave(pdffile,g,width=12,height=5)

   for ( j in c("L", "U") ) {
    covLoc = subset(covA,covA$LOCALE == j)
    ctgTitle <- sprintf("SC%d %s - %s strains",i,Title,j)
    p <- ggplot(covLoc,
   aes(x=GENENUM,y=COVERAGE,color=STRAIN)) +
   labs(title=ctgTitle, xlab="CLUG Locus") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
   scale_shape(solid=T) + geom_point(alpha=0.9,size=1.5) + scale_colour_brewer(palette = "Paired") 
   
   pdffile = sprintf("plot/SC_%d_Cstrains_%s.pdf",i,j)
   ggsave(pdffile,plot=p,width=10)
   }
}



