# Notice: All BAM file has been prepared, we just need to call SV -> Go next

import sys
sys.path.insert(0, '/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/Scripts')
from RunPacbioSV import *
configfile: "../../Configs/MilaTesting.yaml"


# Check version number in snakemake
print("Check version number in smakemake (Python3, GCC and PBSV) -> ")
os.system("python3 --version")
os.system("gcc --version")
os.system("pbsv --version")
os.system("cuteSV --version")


# Run Aligner (post processing)
print("Load Aligner Rules -- Post Processing ...")
include: "../../Rules/Aligner_Mila/ngmlr.rule"
include: "../../Rules/Aligner_Mila/pbmm2.rule"

# Run SV Caller
print("Load SV Caller Rules ...")
include: "../../Rules/SV_Caller_Mila/cutesv.rule"
include: "../../Rules/SV_Caller_Mila/pbsv.rule"
include: "../../Rules/SV_Caller_Mila/sniffles.rule"

strBAMDir = config["GeneralInfo"]["bamDir"]
strSVRootDir = config["GeneralInfo"]["svDir"]

rule all:
    input:
        # For Alinger
        expand(strBAMDir + "/{wcAligner}/{wcRefVersion}/{wcSampleID}/{wcSampleID}.MD.sorted.bam.bai", 
                wcAligner=["ngmlr", "pbmm2"], 
                wcRefVersion = ["v38"], 
                wcSampleID = ["HT1376", "RT4", "SCaBER", "T24"]),
        # For sniffles                      
        expand(strSVRootDir + "/{wcRefVersion}/sniffles/{wcAligner}/{wcSampleID}/minSupport_{wcMinSupportSniffle}/{wcSampleID}.MD.sorted.{wcMinSupportSniffle}.sniffles.vcf", 
                wcRefVersion = ["v38"],
                wcAligner = ["ngmlr","pbmm2"],
                wcSampleID = ["HT1376", "RT4", "SCaBER", "T24"],
                wcMinSupportSniffle = config["sniffles"]["minSupport"].split(',')),
        # For cuteSV
        expand(strSVRootDir + "/{wcRefVersion}/cuteSV/{wcAligner}/{wcSampleID}/minSupport_{wcMinSupportCuteSV}/{wcSampleID}.MD.sorted.{wcMinSupportCuteSV}.cuteSV.vcf", 
                wcRefVersion = ["v38"], 
                wcAligner = ["ngmlr", "pbmm2"], 
                wcSampleID = ["HT1376", "RT4", "SCaBER", "T24"], 
                wcMinSupportCuteSV = config["cuteSV"]["minSupport"].split(',')),
        # For pbsv
        expand(strSVRootDir + "/{wcRefVersion}/pbsv/{wcAligner}/{wcSampleID}/minReads_{wcMinReads}/{wcSampleID}.MD.sorted.{wcMinReads}.pbsv.vcf", 
                wcRefVersion = ["v38"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcSampleID = ["HT1376", "RT4", "SCaBER", "T24"],
                wcMinReads = config["pbsv"]["minReads"].split(','))

                
                