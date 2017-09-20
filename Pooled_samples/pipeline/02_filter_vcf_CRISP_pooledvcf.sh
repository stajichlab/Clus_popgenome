#!/usr/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem 4G
#SBATCH --job-name=vcftools.filter
#SBATCH --output=vcftools.filter.log

module load vcftools
OUTDIR=filtered
mkdir -p $OUTDIR
base=$(basename $INFILE .vcf)
INSNP=$OUTDIR/$base.SNPS.vcf
ININDEL=$OUTDIR/$base.INDEL.vcf
#FILTEREDSNP=$OUTDIR/$base.filtered.SNPONLY.vcf
#FILTEREDINDEL=$OUTDIR/$base.filtered.INDELONLY.vcf
GENOME=/bigdata/stajichlab/shared/projects/Candida/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
SNPONLY=$OUTDIR/$base.selected.SNPONLY.vcf
INDELONLY=$OUTDIR/$base.selected.INDELONLY.vcf


vcftools --vcf A_pools.vcf --out filtered/A_pools.select.SNPONLY --remove-indels --remove-filtered-all  --recode --recode-INFO-all
vcftools --vcf A_pools.vcf --out filtered/A_pools.select.INDELONLY --keep-only-indels  --remove-filtered-all  --recode --recode-INFO-all
vcftools --vcf A_pools.vcf --out filtered/A_pools.select.SNPONLY_BIALLELIC  --remove-indels --remove-filtered-all --min-alleles 2 --max-alleles 2  --recode --recode-INFO-all

