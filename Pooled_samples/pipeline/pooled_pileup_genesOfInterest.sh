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

ODIR=reports
GENELOCALES=all.genes.gff
GENESOFINTEREST=report_20170119_genes.tab
GENE=$(sed -n ${N}p $GENESOFINTEREST)
GENOME=../genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
SAMPLEPREF=A

if [ ! -d $ODIR/$GENE ]; then
     mkdir -p $ODIR/$GENE
fi
 
# this uses grep to find the GFF location of the gene
# then uses the 'while read' bash directive to parse the columns 

grep $GENE $GENELOCALES |  while read chr src type start end score strand frame group;
do
 echo "$GENE $chr:$start-$end"
 
 for bam in $(ls bam/${SAMPLEPREF}*.bam)
 do
    echo $bam
    B=$(basename $bam .bam)
    if [ ! -f $ODIR/$GENE/$B.$GENE.acgt.txt ]; then
	samtools view -u $bam "$chr:$start-$end" | samtools rmdup - - | samtools mpileup -BQ0 -d10000000 -m 3 -F 0.0002 -f $GENOME - | python scripts/sequenza-utils.py pileup2acgt - > $ODIR/$GENE/$B.$GENE.acgt.txt
    fi
 done
done
