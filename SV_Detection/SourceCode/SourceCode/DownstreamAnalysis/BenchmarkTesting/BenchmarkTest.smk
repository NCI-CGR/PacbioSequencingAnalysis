import sys
sys.path.insert(0, '/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/Scripts')
from RunPacbioSV import *
configfile: "../../Configs/benchmarkTest.yaml"

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
os.system("cuteSV --version")

# Run rules one by one -> Now Let's go mapping!! Go!! Tomorrow!

print("Load Rules ...")
# Run Aligner
print("Load Aligner Rules ...")
include: "../../Rules/Aligner/ngmlr.rule"
include: "../../Rules/Aligner/pbmm2.rule"

# Run SV Caller
#print("Load SV Caller Rules ...")
include: "../../Rules/SV_Caller/cutesv.rule"
include: "../../Rules/SV_Caller/pbsv.rule"
include: "../../Rules/SV_Caller/sniffles.rule"

strBAMDir = config["GeneralInfo"]["bamDir"]
strSVRootDir = config["GeneralInfo"]["svDir"]

rule all:
    input:
        # For Alinger
        expand(strBAMDir + "/{wcAligner}/v37/{wcReadsType}/{wcReadsType}.HG002.MD.sorted.bam.bai", 
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcAligner=["ngmlr","pbmm2"]),
         # For sniffles                      
         expand(strSVRootDir + "/{wcRefVersion}/sniffles/{wcAligner}/{wcReadsType}/minSupport_{wcMinSupportSniffle}/Output_Benchmark_Cmp/summary.txt", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr","pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinSupportSniffle = config["sniffles"]["minSupport"].split(',')),
        # For cuteSV
        expand(strSVRootDir + "/{wcRefVersion}/cuteSV/{wcAligner}/{wcReadsType}/minSupport_{wcMinSupportCuteSV}/Output_Benchmark_Cmp/summary.txt", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinSupportCuteSV = config["cuteSV"]["minSupport"].split(',')),
        # For pbsv
        expand(strSVRootDir + "/{wcRefVersion}/pbsv/{wcAligner}/{wcReadsType}/minReads_{wcMinReads}/Output_Benchmark_Cmp/summary.txt", 
                wcRefVersion = ["v37"],
                wcAligner = ["ngmlr", "pbmm2"],
                wcReadsType = ["StdReads", "UltraLowReads"],
                wcMinReads = config["pbsv"]["minReads"].split(',')),
        # For Summary Report
        strSVRootDir + "BenchmarkSummary.csv"

rule GenerateSummaryCSV:
    input:
        svDir = strSVRootDir
    output:
        strSVRootDir + "BenchmarkSummary.csv"
    shell:
        """
        cd ../../Scripts && python3 ./BenchmarkSummaryTruvari.py
        """
        