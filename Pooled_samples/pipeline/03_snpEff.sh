#!/usr/bin/bash 

#SBATCH --mem=8G
module load snpEff

snpEffConfig=./snpEff/snpEff.config
GENOME=C_lusitaniae
DIR=filtered
INVCF=$DIR/A_pools.select.SNPONLY.recode.vcf
OUTVCF=$DIR/A_pools.snpEff.vcf

java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
 mv snpEff_summary.html snpEff_summary.strict.html
mv snpEff_genes.txt snpEff_genes.strict.txt

INVCF=$DIR/A_pools.nofilter.SNPONLY.recode.vcf

OUTVCF=$DIR/A_pools.nofilter.snpEff.vcf
java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
mv snpEff_summary.html snpEff_summary.nofilter.html
mv snpEff_genes.txt snpEff_genes.nofilter.txt
