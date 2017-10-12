#!/usr/bin/bash
#SBATCH --mem 6G --time 1:00:00 -p short -J plotCNV --out plotCNV.log

Rscript scripts/plot_CNV_Astrains.R
Rscript scripts/plot_CNV_Bstrains.R
Rscript scripts/plot_CNV_Cstrains.R

Rscript scripts/plot_perChrom_Astrains.R
Rscript scripts/plot_perChrom_Bstrains.R
Rscript scripts/plot_perChrom_Cstrains.R
Rscript scripts/plot_perChrom_allStrains.R
