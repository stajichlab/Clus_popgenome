#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);
use Getopt::Long;
use Data::Range::Compare;
my $debug = 0;
my $zcat = 'gzip -dc';
my %pool_prefixes = map { $_ => 1 } qw (A22 A23 A24);
my $indir = 'wholegenome_pileup';
my $outdir = 'pooled_vcf';
my @base_order = qw( A C G T);
my $min_freq = 0.10;
my $max_freq = 1 - $min_freq;
my $min_depth = 20;
my $only_biallelic = 1;
my $genes;
my $reportfile = 'pooled_strains.vcf';
GetOptions(
    'r|report:s'        => \$reportfile,
    'g|gff:s'           => \$genes,
    'ob|onlybiallelic!' => \$only_biallelic,
    'v|debug!'          => \$debug);

open(my $report => ">$reportfile" ) || die "cannot open $reportfile: $!";
opendir(DIR,$indir) || die $!;
my %bypos;
my @strains;
for my $file ( readdir(DIR) ) {
    next unless $file =~ /([^\.]+)\.([^\.]+)(\.realign)?\.acgt\.txt(\.gz)?/;
    my ($strnum,$strainname,$suffix) = ($1,$2,$4);
    my $strain = "$strnum.$strainname";
   # warn("$strnum.$strainname = $file from $strnum\n");
    next unless ( $pool_prefixes{$strnum} );
    warn("pool $strain\n");
    push @strains, $strain;
    my $fh;
    if( $suffix ) {
	open($fh => "$zcat $indir/$file |") || die $!;
    } else {
	open($fh => "$indir/$file" ) || die $!;
    }
    my $linect =0;
    while(<$fh>) {
	next if /^chr\s+/; # header
	my ($chr,$pos,$ref,$depth,@bases) = split;
	my $strand = pop (@bases);
	my $total  = sum (@bases);
	my $num_with_bases = 0;
	my $index = 0;
	# this is counts observed at this site for each NT observed
	my $n = 0 ;
	if( $total < $min_depth ) {
	#    warn("too few reads for report $file: $chr,$pos,$ref,$depth,@bases,$strand\n");
	    next;
	}
	$bypos{$chr}->{$pos}->{REF} = $ref;
		
	for my $b ( @bases ) {
	    if( $b > 2 ) { 
		$num_with_bases++;
		$bypos{$chr}->{$pos}->{ALT}->{$base_order[$index]}++;
		$bypos{$chr}->{$pos}->{strain}->{$strain}->{AD}->{$base_order[$index]} += $b;
#		$bypos{$chr}->{$pos}->{strain}->{$strain}->{GT}->{$base_order{$index}};
	    }
	    $index++;
	}
#	if ( $only_biallelic && $num_with_bases > 2 ) {
#	    warn("skipping site $chr:$pos ($strain) as it has $num_with_bases alleles\n");
#	    next;
#	}
#	for my $basect ( @bases ) {
#	    my $freq = ($basect / $total);
#	    if( $freq > $min_freq && $freq < $max_freq ) {
#		$bypos{$chr}->{$pos}->{strains}->{$strain} =  [];
		    # needs to be strain reads seen for REF and ALT?		
#		    sprintf "%s\t%s:%d\tref=%s\tread_%s=%d\tfreq=%.2f\ttotaldepth=%d\tall are %s, strand=%s\n", $report, $chr,$pos,$ref,
#		    $base_order[$n],$basect,$freq,$total,join(",",@bases),$strand;
#		last;
#	    }
#	    $n++;
#	}
	last if ($linect++ > 1000) && $debug;
    }
}
print $report "##fileformat=VCFv4.1\n";
print $report <<EOL
##INFO=<ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes, for each ALT allele, in the same order as listed">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency, for each ALT allele, in the same order as listed">
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
##FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##contig=<ID=Supercontig_1.1,length=2423571>
##contig=<ID=Supercontig_1.2,length=2215196>
##contig=<ID=Supercontig_1.3,length=1874050>
##contig=<ID=Supercontig_1.4,length=1787903>
##contig=<ID=Supercontig_1.5,length=1456586>
##contig=<ID=Supercontig_1.6,length=814710>
##contig=<ID=Supercontig_1.7,length=779898>
##contig=<ID=Supercontig_1.8,length=744036>
##contig=<ID=MT_CBS_6936,length=24896>
EOL
    ;
print $report "##source=Pileup2VCF\n";
print $report join("\t",'#CHROM',qw(POS ID REF ALT QUAL FILTER INFO FORMAT), @strains), "\n";
for my $chr ( sort keys %bypos ) {
    for my $pos ( sort { $a <=> $b } keys %{$bypos{$chr}} ) {
	my %alt = %{$bypos{$chr}->{$pos}->{ALT}};
	my $total_depth = sum ( values %alt );
	my @alt_alleles = sort keys %alt;
	#delete $alt{$bypos{$chr}->{$pos}->{REF}}; # remove the ref allele from list of alts
	next if @alt_alleles == 1;
	my @total_depth_alt = map { $alt{$_} } @alt_alleles; # allele depth, in order
	my @alt_allele_freq = map { sprintf("%.3f",$_ / $total_depth) } @total_depth_alt;
	
	my $ref =  $bypos{$chr}->{$pos}->{REF};
	print $report join("\t", $chr, $pos, '.',
			   $ref,
			   join(",",@alt_alleles),
			   '.', #QUAL
			   '.', #FILTER
			   sprintf('AC=%s;AF=%s;AN=%s', 
				   join(",",@total_depth_alt),
				   join(",", @alt_allele_freq),
				   scalar @alt_alleles),#INFO
			   'GT:AD',
			   (map { 
			       my $strain = $_;
			       my %gts = ($ref => 0);
			       if( exists $bypos{$chr}->{$pos}->{strain}->{$strain} ) {
				   for my $al ( keys %{$bypos{$chr}->{$pos}->{strain}->{$strain}->{AD}} ) {
				       $gts{$al} = $bypos{$chr}->{$pos}->{strain}->{$strain}->{AD}->{$al};
				   }
			       }
			       
			       my @alleles = sort { $a eq $ref ? -1 : $a cmp $b } keys %gts;
			       
			       # warn "$chr $pos $strain ",join(",",@alleles)," ",
			       #join(",", map { $gts{$_} } @alleles), "\n";
			       
			       my @gts = map { $gts{$_} } @alleles;
			       # GT:AD (ref,alt read counts), followed by sum of total depth
			       sprintf("%s:%s", join(",",@gts), sum(@gts))
			    } @strains)
	    ),"\n";
    }
}
    
