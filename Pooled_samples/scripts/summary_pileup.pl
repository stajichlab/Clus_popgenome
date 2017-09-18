#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);

my $dir = shift || ".";
opendir(DIR,$dir) || die "cannot open $dir: $!";
my %groups;
my %strains;
for my $file ( readdir(DIR) ) {
    next unless $file =~ /(\S+)\.Rpileup\.tab/;
    my $stem = $1;
    my (@name) = split(/\./,$stem);
    my ($strain) = $name[0]."_".$name[1]; # in my scheme its A1.STRAIN1...
    my $group = $name[-1];
    $strains{$group}->{$strain}++;
    open(my $fh => "$dir/$file") || die $!;
    my $header = <$fh>;
    while(<$fh>) {
	my ($chr,$pos,$a,$c,$g,$t,$n,@rest) = split;
	$groups{$group}->{"$chr:$pos"}->{$strain} = [$a,$c,$g,$t,$n];
    }
}

for my $grp ( keys %groups ) {    
    my @strains = ( map { $_->[0] } 
		    sort { $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] } 
		    map { my $all = $_;
			  my ($n) = split(/_/,$all);
			  my ($char,$num) = ($n =~ /^([A-Z]+)(\d+)/);
			  [$all,$char,$num]; }
		    keys %{$strains{$grp}});
    open(my $fh1 => ">$grp.pileup_counts.tab") || die $!;
    open(my $fh2 => ">$grp.pileup_freq.tab") || die $!;
    print $fh1 join("\t", qw(CHROM POS), @strains),"\n";
    print $fh2 join("\t", qw(CHROM POS), @strains),"\n";
    for my $pos ( sort { $a->[1] cmp $b->[1] || 
			     $a->[2] <=> $b->[2] } 
		  map { [$_,split(/:/,$_)] } keys %{$groups{$grp}} ) {
	my $dat = $groups{$grp}->{$pos->[0]};	
	print $fh1 join("\t", $pos->[1],$pos->[2],
	      	map { join(":",@{$dat->{$_} || [0,0,0,0,0]})} @strains),"\n";

	print $fh2 join("\t", $pos->[1],$pos->[2],
			map { my @vals = @{$dat->{$_} || [0,0,0,0,0]}; 
			      my $sum = sum(@vals);
			      my $str;
			      if( $sum > 0 ) {
				  $str = join(":",
			    map { sprintf("%.1f",100 * ($_/$sum)) } @vals);
			      } else { $str = join(":", @vals); }
			      $str;
			} @strains),"\n";
    }
}
