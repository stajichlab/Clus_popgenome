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
        if ( $subgroup !~ /ATCC/ && $subgroup =~ /^A/ ) {
         $locale = substr($id,0,1);
	} elsif( $subgroup =~ /ctl/ && $id =~ /AL1/ ) {
	  $locale = 'L';
	}	
	print join("\t", $gene, $c, $strain, $locale,$group),"\n";
    }
}
