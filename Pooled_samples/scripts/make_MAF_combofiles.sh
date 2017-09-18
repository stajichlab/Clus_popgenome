#!/usr/bin/bash

for group in $(echo A B C)
do
cp header  all_${group}_strains.MAF.csv
cat wholegenome_pileup/$group*.csv | grep -v STRAIN >> all_${group}_strains.MAF.csv
done

cp header Lower_strains.MAF.csv
cat wholegenome_pileup/A*.L*.csv | grep -v STRAIN >> Lower_strains.MAF.csv
cp header Upper_strains.MAF.csv
cat wholegenome_pileup/A*.U*.csv | grep -v STRAIN >> Upper_strains.MAF.csv
cp header Sputum_strains.MAF.csv
cat wholegenome_pileup/A*.S*.csv | grep -v STRAIN >> Sputum_strains.MAF.csv
