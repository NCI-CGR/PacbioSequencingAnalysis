import sys
sys.path.insert(0, '/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/Scripts')
from RunPacbioSV import *

# vStdRawReads, vUltraLowRawReads, strSTDBAMDir, strUltraLowBAMDir = GetBenchmarkTestRawData()
# print(vStdRawReads)
# print()
# print(vUltraLowRawReads)
# print(strSTDBAMDir)
# print(strUltraLowBAMDir)

# Check version number in snakemake
print("Check version number in smakemake (Python3, GCC and PBSV) -> ")
os.system("python3 --version")
os.system("gcc --version")
os.system("pbsv --version")


# Output


# Run rules one by one -> Now Let's go mapping!! Go!! Tomorrow!

# Run Aligner
#include: "../../Rules/Aligner/ngmlr.rule"
#include: "../../Rules/Aligner/pbmm2.rule"

# Run SV Caller
include: "../../Rules/SV_Caller/cutesv.rule"
include: "../../Rules/SV_Caller/pbsv.rule"
include: "../../Rules/SV_Caller/sniffles.rule"

# expand('{wcRefVersion}', wcRefVersion = ["v37"])
# expand('{wcAligner}', wcAligner = ["ngmlr", "pbmm2"])
# expand('{wcReadsType}', wcReadsType = ["StdReads", "UltraLowReads"])
# expand('{}')

rule all:    
    input:        
        expand(svRootDir + "/{wcRefVersion}/sniffles/{wcAligner}/{wcReadsType}/minSupport_{wcMinSupportSniffle}/{wcReadsType}.HG002.MD.sorted.{wcMinSupportSniffle}.sniffles.vcf", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinSupportSniffle = config["sniffles"]["minSupport"].split(',')),
        expand(svRootDir + "/{wcRefVersion}/cuteSV/{wcAligner}/{wcReadsType}/minSupport_{wcMinSupportCuteSV}/{wcReadsType}.HG002.MD.sorted.{wcMinSupportCuteSV}.cuteSV.vcf", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinSupportCuteSV = config["cuteSV"]["minSupport"].split(',')),
        expand(svRootDir + "/{wcRefVersion}/pbsv/{wcAligner}/{wcReadsType}/minReads_{wcMinReads}/{wcReadsType}.HG002.MD.sorted.{wcMinReads}.pbsv.vcf", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinReads = config["pbsv"]["minReads"].split(','))
         

        
        
    