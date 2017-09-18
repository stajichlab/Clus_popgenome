#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);
use Getopt::Long;
use Data::Range::Compare;

my %pool_prefixes = map { $_ => 1 } qw (A22 A23 A24);
my $reportdir = 'reports';
my @base_order = qw( A C G T);
my $min_freq = 0.10;
my $max_freq = 1 - $min_freq;
my $min_depth = 50;
my $only_biallelic = 1;
my $genes;
GetOptions('r|report:s'        => \$reportdir,
	   'g|gff:s'           => \$genes,
	   'ob|onlybiallelic!' => \$only_biallelic,);


opendir(DIR,$reportdir) || die $!;
my %bypos;
for my $locus ( readdir(DIR) ) {
    next if $locus =~ /^\./;
    next if ( ! -d "$reportdir/$locus" );
    opendir(LOCUS, "$reportdir/$locus") || die $!;
    for my $report ( readdir(LOCUS) ) {
	next unless $report =~ /(A\d+)\.(\S+)\.(\S+)/;
	my ($num,$strain,$info) = ($1,$2,$3);
	next unless $pool_prefixes{$num};
	open(my $fh => "$reportdir/$locus/$report" ) || die $!;
	
	while(<$fh>) {
	    next if /^chr\s+/; # header
	    my ($chr,$pos,$ref,$depth,@bases) = split;
	    my $strand = pop @bases;
	    my $total = sum(@bases);
	    my $num_with_bases = 0;
	    for my $b ( @bases ) {
		if( $b > 0 ) { $num_with_bases++ }
	    }
	    if ( $only_biallelic && $num_with_bases > 2 ) {
		warn("skipping site $chr:$pos ($strain) as it has $num_with_bases alleles\n");
		next;
	    }
	    my $n = 0 ;
	    if( $total < $min_depth ) {
		warn("too few reads for $report: $chr,$pos,$ref,$depth,@bases,$strand\n");
		next;
	    }
	    for my $basect ( @bases ) {
		my $freq = ($basect / $total);
		if( $freq > $min_freq && $freq < $max_freq ) {
		    $bypos{$chr}->{$pos}->{$num} = 
			sprintf "%s\t%s:%d\tref=%s\tread_%s=%d\tfreq=%.2f\ttotaldepth=%d\tall are %s, strand=%s\n", $report, $chr,$pos,$ref,
			$base_order[$n],$basect,$freq,$total,join(",",@bases),$strand;
		    last;
		}
		$n++;
	    }
	}
    }
}

for my $chr ( sort keys %bypos ) {
    for my $pos ( sort { $a <=> $b } keys %{$bypos{$chr}} ) {
	for my $strain ( keys %{$bypos{$chr}->{$pos}} ) {
	    print $bypos{$chr}->{$pos}->{$strain};
	}
    }
}
    
