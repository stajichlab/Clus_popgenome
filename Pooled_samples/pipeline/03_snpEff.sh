#!/usr/bin/bash 
#SBATCH --time 2:00:00 -p short --ntasks 1 --nodes 1
#SBATCH --mem=8G
module load snpEff

snpEffConfig=./snpEff/snpEff.config
GENOME=C_lusitaniae
DIR=filtered_lungonly_3per
mkdir -p $DIR
INVCF=A_pools.SNPONLY.lungonly.3per.vcf
OUTVCF=$DIR/A_pools.SNPONLY.strict.lungonly.3per.snpEff.vcf

java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
mv snpEff_summary.html $DIR/snpEff_summary.SNP_strict.html
mv snpEff_genes.txt $DIR/snpEff_genes.SNP_strict.txt

INVCF=A_pools.INDELONLY.lungonly.3per.vcf
OUTVCF=$DIR/A_pools.INDEL.strict.lungonly.3per.snpEff.vcf

java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
mv snpEff_summary.html $DIR/snpEff_summary.INDEL_strict.html
mv snpEff_genes.txt $DIR/snpEff_genes.INDEL_strict.txt

INVCF=A_pools.SNPONLY.nofilter.lungonly.3per.vcf
OUTVCF=$DIR/A_pools.SNPONLY.nofilter.lungonly.snpEff.3per.vcf
java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
mv snpEff_summary.html $DIR/snpEff_summary.SNP_nofilter.html
mv snpEff_genes.txt $DIR/snpEff_genes.SNP_nofilter.txt


INVCF=A_pools.INDELONLY.nofilter.lungonly.3per.vcf
OUTVCF=$DIR/A_pools.INDELONLY.nofilter.lungonly.snpEff.3per.vcf
java -Xmx16g -jar $SNPEFFJAR eff -v -c $snpEffConfig $GENOME $INVCF > $OUTVCF
mv snpEff_summary.html $DIR/snpEff_summary.INDEL_nofilter.html
mv snpEff_genes.txt $DIR/snpEff_genes.INDEL_nofilter.txt

perl scripts/snpEffTable_Pn_Ps.pl $DIR/snpEff_genes.SNP_strict.txt >  $DIR/snpEff_genes.Pn_Ps.tab
perl scripts/snpEffTable_Pn_Ps.pl $DIR/snpEff_genes.SNP_nofilter.txt >  $DIR/snpEff_genes.nofilter_Pn_Ps.tab

