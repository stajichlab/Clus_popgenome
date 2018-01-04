#!/usr/bin/env python
# This is Python 2 code
import sys
import vcf.parser


if len(sys.argv) < 2:
	print"Usage removedfixed.py infile.SNPSONLY.vcf"


newfilename = sys.argv[1].strip('vcf')
newfilelungSNP = newfilename + "SNPONLY.lungonly.3per.vcf"
newfilefixedSNP = newfilename + "SNPONLY.fixed.3per.vcf"

newfilelungINDEL = newfilename + "INDELONLY.lungonly.3per.vcf"
newfilefixedINDEL = newfilename + "INDELONLY.fixed.3per.vcf"

vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
vcf_writer_snp_lung = vcf.Writer(open(newfilelungSNP,'w'),vcf_reader)
vcf_writer_snp_fixed = vcf.Writer(open(newfilefixedSNP,'w'),vcf_reader)

vcf_writer_indel_lung = vcf.Writer(open(newfilelungINDEL,'w'),vcf_reader)
vcf_writer_indel_fixed = vcf.Writer(open(newfilefixedINDEL,'w'),vcf_reader)

names = ["A22", "A23", "A24"]
for record in vcf_reader:
#        print record.FILTER
#        print record
        if record.FILTER == None or len(record.FILTER) == 0:
                ref_allele_count = 0
                alt_allele_count = 0
                for name in names:                
                        call = record.genotype(name)
                        data = call.data
                        if data.MLAC > 30:
                        	if float(data.ADf[0])/(data.ADf[1]+data.ADf[0]+1) > .03 or float(data.ADr[0])/(data.ADr[1]+data.ADf[0]+1) > .03: # and ((data.ADf[0]+data.ADf[1]) > 100 or (data.ADr[0] + data.ADr[1]) > 100) and  ((data.ADf[0]+data.ADf[1]) < 400 and (data.ADr[0] + data.ADr[1]) <400):
					ref_allele_count += data.ADf[0]
                        		ref_allele_count += data.ADr[0]
                                #print data.ADf
                        	for altct in data.ADf[1:]:
                        		alt_allele_count += altct
                        	for altct in data.ADr[1:]:
					alt_allele_count += altct
             
                if ref_allele_count >0:#>len(names):
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

 #               print "ref_allele > %d" % len(names)
 #               for name in names:
 #                       print record.genotype(name)
 #               print "==="
