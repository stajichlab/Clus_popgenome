library(ggplot2)

for ( i in c(1:8) ) {
    filename=sprintf("plot/Supercontig_1.%d.gene_cov_norm.gg.tab", i)
    pdffile = sprintf("plot/SC_%d.gg.pdf",i)
    Title=sprintf("SC %d - all strains",i)
    cov <- read.table(filename,header=T,sep="\t")
    g = ggplot(cov,aes(GENE,COVERAGE,color=GROUP,group=GROUP)) +
    labs(title=Title) + 
      geom_point(alpha=1/2,size=0.5) + scale_colour_brewer(palette = "Set2")

      ggsave(pdffile,g,width=10,height=5)
}
