#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);
use Getopt::Long;
use File::Spec;
my @base_order = qw( A C G T);
my @allele_count_code = qw(NONE FIXED POLYMORPHIC TRIALLELIC QUADALLELIC);

my ($only_biallelic) = 0;
my $min_depth = 20;
my $min_freq = 0.20;
my $report;
GetOptions(
    'biallelic!' => \$only_biallelic,
    'r|report:s' => \$report);
$report ||= shift @ARGV;

if ( ! $report ) { 
    die"need a report file";
}
# expects folder with whole genome pileup calculated
#my $folder = shift || 'wholegenome_pileup';

my ($vol,$folder,$filename) = File::Spec->splitpath($report);

unless( $filename =~ /(\S+)\.acgt.txt.gz$/) {
    die("expecting a report to end in acgt.txt.gz - it was $report\n");
}

my $stem = $1;
my ($num,$strain) = split(/\./,$stem);
$stem =~ s/\.realign//;
open(my $fh => "zcat $report |") || die $!;
my %bypos;

open(my $ofh => ">$folder/$stem.MAF.csv") || die $!;
print $ofh join(",",qw(STRAIN CHR POS REF ALT MINOR_AF CLASSIFICATION)), "\n";

while(<$fh>) {
    next if /^chr\s+/; # header
    my ($chr,$pos,$ref,$depth,@bases) = split;
    my $strand = pop @bases;
    my $total = sum(@bases);
    my $num_with_bases = 0;
    for my $b ( @bases ) {
	if( $b > 1 ) { $num_with_bases++ }
    }
    if ( $only_biallelic && $num_with_bases > 2 ) {
	warn("skipping site $chr:$pos ($strain) as it has $num_with_bases alleles\n");
	next;
    }
    if( $total < $min_depth ) {
	#warn("too few reads for $report: $chr,$pos,$ref,$depth,@bases,$strand\n");
	next;
    }
    
    my ($n,@af) = (0);
    for my $basect ( @bases ) {
	my $freq = $basect / $total;
	if( $freq > $min_freq ) { 
	    push @af, { 'af' => sprintf("%.3f",$freq), 
			'allele' => $base_order[$n]};
	}
	$n++;
    }
    my $code= $allele_count_code[scalar @af];	
    @af = sort { $b->{af} <=> $a->{af} } grep { $_->{allele} ne $ref } @af;
    my ($maf,$alt) = (0,'');
    
    if( @af ) {
	$maf = $af[0]->{af};
	$alt = $af[0]->{allele};
	$code .= "_ALT" if $code eq 'FIXED';
    }

# this would be where we would add options to print this data indeed
    if( $code !~ /FIXED/ ) {
	print $ofh join(",",$strain,$chr,$pos,$ref,$alt, $maf,
			$code),"\n";
    }
}    
