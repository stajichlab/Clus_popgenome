#!/usr/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=8:00:00
#SBATCH --job-name=RpileupClus

#Rscript scripts/pileup_freq_MRR.R bam/*.bam
Rscript scripts/pileup_freq.R bam/*.bam
