#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Statistics::Descriptive;

my $bedfile = "Candida_lusitaniae.genes.bed";
my $covdir = "coverage";
my $strain_depth = 'depth/strain.depths.tab';
my $odir = 'plot_CNV';
my $ext = ".bamcoverage.tab";
my $skip_strains = 'skip.tab'; # not used now
my $min_depth = 2;
my $gene_window_size = 20;

GetOptions('b|bed:s'        => \$bedfile,
	   'c|cov|dir:s'    => \$covdir,
	   'o|odir:s'       => \$odir,
	   'd|depth:s'      => \$strain_depth,
	   'min|mindepth:s' => \$min_depth,
	   's|skip:s'       => \$skip_strains,
	   'w|window:s'     => \$gene_window_size,
    );
mkdir($odir) unless -d $odir;
my %depths;
open(my $fh => $strain_depth) || die "$strain_depth: $!";

while(<$fh>) {
    next if /^\#/;
    my ($strain,$asm_len,$total_reads, $avg_coverage) = split;
    #warn("strain=$strain\n");
    if ( $avg_coverage < $min_depth ) {
	warn("skipping $strain, coverage $avg_coverage is too low\n");
        next;
    }
    $depths{$strain} = $avg_coverage;

}

open($fh => $bedfile) || die "cannot open $bedfile: $!";

my %chroms;
while(<$fh>) {
    my ($chrom,$start,$end,$gene) = split;
    push @{$chroms{$chrom}}, [$start,$end, $gene];
}

my %genecov;
my %strains_list;
opendir(DIR, $covdir) || die "cannot open $covdir dir: $!";
for my $file ( readdir(DIR) ) {
    next unless $file =~ /\Q$ext\E$/;
    open(my $fh => "$covdir/$file") || die $!;
    my @strains;
    while(<$fh>) {
	if( /^\#/ ) {
	    (undef,undef,@strains) = split;
	    for my $m ( @strains ) { 
		$strains_list{$m}++;
	    }
	} else {
	    my ($gene,$len,@covinfo) = split;
	    $genecov{$gene} = { map { $_ => shift @covinfo } @strains };
	}
    }
}

my @strains_final = sort keys %depths;
open(my $ofh => ">$odir/coverage_by_gene_aggregate.norm.ggplot.tab") || die $!;

print $ofh join("\t", qw(WINDOW CHROM CHROM_WINDOW STRAIN STRAIN_GROUP
LOCALE MEAN_COVERAGE MEDIAN_COVERAGE GENE_COUNT)),"\n";

my $windows = 1;
for my $chrom (sort keys %chroms ) {   
    my @ordered_genes = sort { $a->[0] <=> $b->[0] } @{$chroms{$chrom}};
    my $len = scalar @ordered_genes;
    my $i = 0;
    while(@ordered_genes) {
	my @genes = splice(@ordered_genes,0,$gene_window_size);
	my @genenames = map { $_->[2] } @genes;
	for my $strain ( @strains_final ) {
	    my $strain_group;
	    my ($subgroup,$id) = split(/\./,$strain);
	    if( $strain =~ /^([ABC])\d+\./ ) {
		$strain_group = $1;
	    } elsif( $strain =~ /ATCC/) {
		$strain_group = 'REF';
	    } 
#	    next if $strain =~ /P$/ || $strain =~ /^ctl/;
	    my $locale = 'UNK';
	    if ( $subgroup =~ /ATCC/ ) {
		$locale = 'Blood';
	    } elsif ( $subgroup =~ /^A/ ) {
		$locale = substr($id,0,1);
	    } elsif( $subgroup =~ /ctl/ && $id =~ /AL1/ ) {
		$locale = 'L';
		$strain_group = 'A';
	    } elsif ( $subgroup =~ /ctl/ && $id =~ /C9L1/ ) {
		$locale = 'L';
		$strain_group = 'C';
	    } elsif ( $subgroup =~ /^C(\d+)/ ) {
		my $n = $1;
		if( $n >= 4 && $n <= 7 ) {
		    $locale = 'L';
		} elsif ( $n >= 8 && $n <= 11 ) {
		    $locale = 'M';
		} elsif ( $n >= 12 && $n <= 15 ) {
		    $locale = 'U';
		} elsif ( $n == 30 ) {
		    $locale = 'L';
		} elsif ( $n == 31 ) {
		    $locale = 'Stock';
		} else {
		    warn("unknown group $subgroup\n");
		}
	    } elsif ( $subgroup =~ /^B(\d+)/ ) {
		my $n = $1;
		if ($n >= 16 && $n <= 21 ) {
		    $locale = 'L';
		} elsif( $n >= 22 && $n <= 27 ) {
		    $locale = 'U';
		} elsif( $n == 28 ) {
		    $locale = 'U';
		} elsif ( $n == 29 ) {
		    $locale = 'M';
		} else {
		    warn("unknown group $subgroup\n");
		}
	    }
	    my @covs = map { #warn("cov of $_ for $strain is ",
			#	  $genecov{$_}->{$strain},"\n");
			     $genecov{$_}->{$strain} / $depths{$strain} 
	    } @genenames;
	    my $stats = Statistics::Descriptive::Full->new();
	    $stats->add_data(\@covs);
	    print $ofh join("\t", $windows, $chrom, $i, $strain, $strain_group, $locale,
			    sprintf("%.2f",$stats->mean),
			    sprintf("%.2f",$stats->median),
			    scalar @genenames),"\n";
	}
	$i++;
	$windows++;
    }
}
