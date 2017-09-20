#!/usr/bin/bash 

#SBATCH --mem=8G
module load snpEff
snpEffConfig=./snpEff/snpEff.config
GENOME=C_lusitaniae
java -jar $SNPEFFJAR build -c $snpEffConfig $GENOME
