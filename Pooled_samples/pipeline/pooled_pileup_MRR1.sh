#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8G
#SBATCH -p batch
module load samtools
N=${SLURM_ARRAY_TASK_ID}
if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then
 N=1
fi
BAM=$(ls bam/*.bam | sed -n ${N}p)
GENOME=../genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
B=$(basename $BAM .bam)
ODIR=acgt_sums
if [ ! -f $ODIR/$B.acgt.txt ]; then
samtools view -u $BAM Supercontig_1.1:1094487-1098476 | samtools rmdup - - | samtools mpileup -BQ0 -d10000000 -m 3 -F 0.0002 -f $GENOME - | python scripts/sequenza-utils.py pileup2acgt - > $ODIR/$B.acgt.txt
fi
