#!/usr/bin/bash

#SBATCH --ntasks 2 --nodes 1 --mem 24G --time 2-0:00:00 --out CRISP.%A.out -J CRISP.PoolA

module load CRISP

CRISP --bams A_pools.txt --ref genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta -p 68 --VCF A_pools.vcf > CRISP.log
