#!/bin/bash
#SBATCH --ntasks 2 --nodes 1 --out iqtree.%A.outlog --mem 2G --time 8:00:00
module load IQ-TREE

#iqtree-omp -nt 2 -s Table_S2_indel_matrix.fasaln -m JC2+ASC  -b 100 
iqtree-omp -nt 2 -s Table_S2_indel_matrix.fasaln -st MORPH -b 100 
iqtree-omp -nt 2 -s Table_S2_indel_matrix_binaryonly.fasaln -st JSC2+ASC -b 100 
