for file in *.gene_cov_norm.tab
do
	b=$(basename $file)
	perl prep_for_ggplot.pl $file > $b.gg.csv
done
