# routine to make table from pileup
pileupFreq <- function(pileupres) {
    nucleotides <- levels(pileupres$nucleotide)
    res <- split(pileupres, pileupres$seqnames)
    res <- lapply(res, function (x) {split(x, x$pos)})
    res <- lapply(res, function (positionsplit) {
        nuctab <- lapply(positionsplit, function(each) {
                        chr = as.character(unique(each$seqnames))
                        pos = as.character(unique(each$pos))
                        tablecounts <- sapply(nucleotides, function (n) {sum(each$count[each$nucleotide == n])})
                        c(chr,pos, tablecounts)
                    })
        nuctab <- data.frame(do.call("rbind", nuctab),stringsAsFactors=F)
        rownames(nuctab) <- NULL
        nuctab
    })
    
    res <- data.frame(do.call("rbind", res),stringsAsFactors=F)
    rownames(res) <- NULL
    colnames(res) <- c("seqnames","start",levels(pileupres$nucleotide))
    res[3:ncol(res)] <- apply(res[3:ncol(res)], 2, as.numeric)
    res
}

library(Rsamtools)
library(rtracklayer)
library(tools)

mrr1snpsfile = "MRR1.snps.bed3" # This is vcf from previous non-pooled samples
mrr1snps <- import(mrr1snpsfile,format="bed")

#param <- ScanBamParam(which=vcf.ranges)
#vcf <- readVcf(vcffile,"ATCC42720_w_CBS_6936_MT")
#vcf.ranges <- rowData(vcf)
#summary(vcf.ranges)

# run as Rscript  pileup_freq.R bam/A22.UpperP.realign.bam 
args = commandArgs(trailingOnly=TRUE)

for(n in 1:length(args) ) {
    bam = args[n]
    ext = file_ext(bam)
    if( ext != "bam") {
        stop("expecting bam files.n",call.=FALSE)
    }
    longname = file_path_sans_ext(file_path_as_absolute(bam))
    splitstem = strsplit(longname,"/")
    stem = splitstem[[1]][[length(splitstem[[1]])]]
    outfile = paste(stem,".MRR1.Rpileup.tab",sep="")
    print(paste("Writing report to:",outfile))
    bf <- BamFile(bam)

    # previous thhis was just the MRR1 range
    #param <- ScanBamParam(which=GRanges("Supercontig_1.1",
    #IRanges(start=1094487, end=1098476)))
    param <- ScanBamParam(which=mrr1snps)

    p_param <- PileupParam(max_depth=1000,distinguish_strand=FALSE)
    res2 <- pileup(bf, scanBamParam=param, pileupParam=p_param)

    pileupsum <- pileupFreq(res2)
    write.table(pileupsum,file=outfile,sep="\t",quote=FALSE,row.names=FALSE)
}
