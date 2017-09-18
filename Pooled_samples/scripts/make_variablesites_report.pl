#!/usr/bin/perl
use strict;
use warnings;

# arguments
# 1 pileup report from find_variablesSites_in_pools.pl
# 2 snp2gene comes from
# awk '{print $2}' wholegenome_pileup.w_multiallelic.txt | perl -p -e 's/(\S+):(\S+)/$1\t$2\t$2/' > wholegenome_pileup.w_multiallelic.bed
# followed by
# bedtools intersect -a wholegenome_pileup.w_multiallelic.bed -b all.genes.gff -wb > wholegenome_pileup.w_multiallelic.snps2genes.tab
my ($pileupreport, $snp2gene) = @ARGV;

my %snp2geneTable;

open(my $fh => $snp2gene) || die $!;
while(<$fh>) {
    my ($chr,$pos,$posrepeat,@rest) = split;
    my $ninth = pop @rest;
    my $genename;
    if ( $ninth =~ /Name=(\S+)/ ) {
	$genename = $1;
    }
    $snp2geneTable{"$chr:$pos"}->{$genename}++;
}

open($fh => $pileupreport) || die $!;
open(my $ofh => ">$pileupreport.gene_count") || die $!;
my %geneSNPs;
while(<$fh>) {
    chomp;
    my ($report,$pos,$rest) = split(/\s+/,$_,3);
    if( $snp2geneTable{$pos} ) {
	for my $gn ( keys %{$snp2geneTable{$pos}} ) {
	    $geneSNPs{$gn}->{$pos}++;
	}
    }
    print join("\t", $_, sprintf("gene=%s",
				 join(",",sort keys %{$snp2geneTable{$pos} || {'NONE'=>1}})
	       )),
	"\n";
}

for my $gene ( sort keys %geneSNPs ) {
    print $ofh join("\t", $gene, scalar keys %{$geneSNPs{$gene}}),"\n";
}
