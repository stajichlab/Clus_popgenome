library(ggplot2)

for ( i in c(1:8) ) {
    filename=sprintf("plot/Supercontig_1.%d.gene_cov_norm.gg.tab", i)
    pdffile = sprintf("plot/SC_%d_all_strains.pdf",i)
    Title=sprintf("SC %d - all strains",i)
    cov = read.table(filename,header=T,sep="\t")
    groups = cov$GROUP
    
    cov$GENENUM =as.numeric(gsub("CLUG_","",cov$GENE))
    maxGene= max(cov$GENENUM)
    print(maxGene)
    g = ggplot(cov,aes(GENENUM,COVERAGE,color=STRAIN,shape=GROUP,
                        group=LOCALE)) +
    labs(title=Title,xlab="CLUG Locus") + 
    geom_point(alpha=1,size=1) +
    scale_shape(solid = F) +
    scale_fill_identity(guide = "legend") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
    ggsave(pdffile,g,width=12,height=8)

    for ( j in c("L", "M","S","U") ) {
        covLoc = subset(cov,cov$LOCALE == j)
        ctgTitle <- sprintf("SC%d %s - %s strains",i,Title,j)
        p <- ggplot(covLoc,
                    aes(x=GENENUM,y=COVERAGE,color=STRAIN,shape=GROUP)) +
            labs(title=ctgTitle, xlab="CLUG Locus") + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
            scale_shape(solid=T) + geom_point(alpha=0.9,size=1.5)
                                        #+ scale_colour_brewer(palette = "Paired") 
   
        pdffile = sprintf("plot/SC_%d_all_strains_%s.pdf",i,j)
        ggsave(pdffile,plot=p,width=10)
   }
}



