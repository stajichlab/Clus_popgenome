#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 1 --mem 8G --out read_extract_pairExtract.%A.log --time 4:00:00

module load samtools

REGIONS=CNV_regions.bed
OUTDIR=region_extracts

mkdir -p $OUTDIR

for BAM in $(ls bam/*.bam)
do
 STRAIN=$(basename $BAM .realign.bam)
 while read CHR START END TYPE
 do
  samtools view -b -h -o $OUTDIR/$STRAIN.$TYPE.bam $BAM $CHR:$START-$END
 done < $REGIONS
done
