#!/usr/bin/perl
use strict;
use warnings;

# print out if
# read pairs are on different chroms or 
# they are > 1kb away

my $dir = 'region_extracts';
opendir(DIR,$dir) || die "cannot open $dir: $!";
my %d;
for my $file ( readdir(DIR) ) {
    open( my $fh => "$dir/$file" ) || die "cannot open $dir/$file: $!";
    if($file =~ /(\S+)_(CNV\S+)\.sam/ ) {
	my $cnvregion = $2;
	while(<$fh>) {
	    next if /^\@/;
	    chomp;
	    my ($read,$flag,$chr,$pos,$mapq,$cigar,
		$pair_Chr,$pair_pos,$tlen,$seq,$qual,@tags, 
		@row) = split(/\t/,$_);
	    my $strain;
	    my $sa;
	    for my $t (@tags) { 
		if ($t =~ /RG:Z:(\S+)/ ) {
		    $strain = $1;
		} elsif( $t =~ /SA:Z/ ) {
		    $sa = 1;
		}
	    }
	    my $dist = abs($pair_pos - $pos);
	    next unless $sa && ( $pair_Chr ne '=' ||
				 $dist > 1000);

	    #$pair_Chr eq '='; # looking for alt chr hits
	    if( $pair_Chr eq '=' ) {
		$pair_Chr = $chr;
	    }
	    push @{$d{$cnvregion}->{$strain}}, [ $read, $chr,$pos, $pair_Chr, 
						 $pair_pos];
	}
    }

}

for my $n ( keys %d ) {
    open(my $ofh => ">$n.csv") || die $!;
    print $ofh join(",",qw(STRAIN READ PAIR1_CHR PAIR1_POSITION 
                           PAIR2_CHR PAIR2_POSITION)),"\n";
    for my $s ( keys %{$d{$n}} ) {
	for my $r ( @{$d{$n}->{$s}} ) {
	    print $ofh join(",",$s,@$r), "\n";
	}
    }
}
