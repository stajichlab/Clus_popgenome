#!/usr/bin/env python
# This is Python 2 code
import sys
import vcf.parser


if len(sys.argv) < 2:
	print"Usage removedfixed.py infile.SNPSONLY.vcf"


newfilename = sys.argv[1].strip('vcf')
newfilelungSNP = newfilename + "SNPONLY.nofilter.lungonly.vcf"
newfilefixedSNP = newfilename + "SNPONLY.nofilter.fixed.vcf"

newfilelungINDEL = newfilename + "INDELONLY.nofilter.lungonly.vcf"
newfilefixedINDEL = newfilename + "INDELONLY.nofilter.fixed.vcf"

vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
vcf_writer_snp_lung = vcf.Writer(open(newfilelungSNP,'w'),vcf_reader)
vcf_writer_snp_fixed = vcf.Writer(open(newfilefixedSNP,'w'),vcf_reader)

vcf_writer_indel_lung = vcf.Writer(open(newfilelungINDEL,'w'),vcf_reader)
vcf_writer_indel_fixed = vcf.Writer(open(newfilefixedINDEL,'w'),vcf_reader)

names = ["A22", "A23", "A24"]
for record in vcf_reader:
#        print record.FILTER
#        print record
         ref_allele_count = 0
         alt_allele_count = 0
         for name in names:                
                 call = record.genotype(name)
                 data = call.data
                if data.MLAC > 30:
                        ref_allele_count += data.ADf[0]
                        ref_allele_count += data.ADr[0]
                        #print data.ADf
                        for altct in data.ADf[1:]:
                                alt_allele_count += altct
                                for altct in data.ADr[1:]:
                                        alt_allele_count += altct
                                        
                if ref_allele_count > len(names):
                        if record.is_snp:
                                vcf_writer_snp_lung.write_record(record) 
                        else:
                                vcf_writer_indel_lung.write_record(record) 
                else:
                        if record.is_snp:
                                vcf_writer_snp_fixed.write_record(record) 
                        else:
                                vcf_writer_indel_fixed.write_record(record) 

vcf_writer_snp_lung.close()
vcf_writer_snp_fixed.close()

vcf_writer_indel_lung.close()
vcf_writer_indel_fixed.close()
