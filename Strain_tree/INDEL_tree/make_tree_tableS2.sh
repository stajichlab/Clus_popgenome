#!/bin/bash
#SBATCH --ntasks 2 --nodes 1 --out iqtree.%A.outlog --mem 2G

module load IQ-TREE
iqtree-omp -nt 2 -s Table_S2_indel_matrix.fasaln -m JC2+ASC  -b 100 
