#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 1 --mem 4G
N=${SLURM_ARRAY_TASK_ID}
if [ ! $N ]; then
 N=$1
 if [ ! $N ]; then
  echo "need an input ID"
  exit
 fi
fi

OUTDIR=insert_size

mkdir -p $OUTDIR
BAM=$(ls aln_ATCC42720_w_CBS_6936_MT/*.realign.bam | sed -n ${N}p)
BASE=$(basename $BAM realigm.bam)
if [ ! -f  $OUTDIR/$BASE.csv ]; then
 perl scripts/compute_insertsize_chromdist.pl $BAM > $OUTDIR/$BASE.csv
else 
 echo "Skippig $BAM, $OUTDIR/$BASE.csv already exists"
fi
