#!/usr/bin/perl
use strict;
use warnings;
my $header = <>;
my ($gn,@header) = split(/\s+/,$header);

print join("\t",qw(GENE COVERAGE STRAIN LOCALE GROUP)), "\n";

while(<>) {
    my ($gene,@row) = split;
    my $i = 0;
    for my $c ( @row ) {
	my $strain = $header[$i++];
	my $group = ($strain =~ /ATCC/) ? $strain : substr($strain,0,1);
	if( $strain =~ /ctl\d+\.(\S+)/ ) {
	    $group = substr($1,0,1);
	}
	my ($subgroup,$id)  = split(/\./,$strain);
        my $locale = 'UNK';
        if ( $subgroup =~ /ATCC/ ) {
	    $locale = 'Blood';
	} elsif ( $subgroup =~ /^A/ ) {
         $locale = substr($id,0,1);
	} elsif( $subgroup =~ /ctl/ && $id =~ /AL1/ ) {
	  $locale = 'L';
	} elsif ( $subgroup =~ /ctl/ && $id =~ /C9L1/ ) {
	    $locale = 'L';
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
	print join("\t", $gene, $c, $strain, $locale,$group),"\n";
    }
}
