#!/usr/bin/perl
use strict;
use warnings;

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
	    for my $t (@tags) { 
		if ($t =~ /RG:Z:(\S+)/ ) {
		    $strain = $1;
		} 
	    }
	    next if $pair_Chr eq '='; # looking for alt chr hits
	    push @{$d{$cnvregion}->{$strain}}, [ $chr,$pos, $pair_Chr, 
						 $pair_pos];
	}
    }

}

for my $n ( keys %d ) {
    open(my $ofh => ">$n.txt") || die $!;
    for my $s ( keys %{$d{$n}} ) {
	for my $r ( @{$d{$n}->{$s}} ) {
	    print $ofh join("\t",$s,@$r), "\n";
	}
    }
}
