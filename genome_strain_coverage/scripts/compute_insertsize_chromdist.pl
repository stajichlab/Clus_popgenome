#!/usr/bin/perl

=head1 NAME 

compute_insertsize_chromdist.pl  - check for insert size calculated along bins of a chromosome

=head1 USAGE

compute_insertsize_chromdist.pl bamfile > chroms_dist.dat

=head1 DESCRIPTION

Find insertsize for all reads along a bamfile ordered by chrom position

=cut

use strict;
use warnings;

use Getopt::Long;
use List::Util qw(sum);
use Statistics::Descriptive;

my $samtools = 'samtools';
my $bamfile;
my $binsize = 1000;
my $samtools_args = '-f67';
GetOptions('samtools:s' => \$samtools,
	   'b|binsize:s' => \$binsize,
	   'bam|bamfile:s' => \$bamfile,
	   'args|samargs:s' => \$samtools_args,
    );


$bamfile ||= shift @ARGV || die "no bamfile input";
open(my $fh => "$samtools view $samtools_args $bamfile |") || die $!;
my $i = 0;
my $max_readlen = 1;
my %dat;
my %gc;
while(<$fh>) {
    my ($qname,$flag,$rname,$pos,$mapq,$cigar,$rnext,$pnext,$tlen,$seq) = split(/\t/,$_);
    my $read_len = length $seq;
    $max_readlen = $read_len if $read_len > $max_readlen;
    my $bin = int($pos / $binsize);
#    warn join("\t", $rname,$pos,$bin,abs($tlen)),"\n";
    push @{$dat{$rname}->[$bin]}, abs($tlen);
    push @{$gc{$rname}->[$bin]}, gc($seq);
}
print join(",", qw(CHROM BIN MEDIAN_INSERT_SIZE GC OBSERVATIONS)),"\n";


for my $chr ( keys %dat ) {
    my $bin_n = 0;
    for my $bin ( @{$dat{$chr}} ) {
	my $stats = Statistics::Descriptive::Full->new();
	$stats->add_data(@$bin);
	print join(",", $chr, $bin_n, 
		   $stats->median,
		   mean($gc{$chr}->[$bin_n]),
		   scalar @{$bin || []} ),"\n";
	$bin_n++;
    }
}

sub mean { 
    my $dat = shift;
    return 0 unless $dat;
    my $sum = sum(@$dat);
    return $sum / scalar @$dat;
}

sub gc {
    my $str = shift;
    my $gc = ( $str =~ tr/gcGC/gcGC/);
    sprintf("%.4f",$gc / length $str);
}
