#!/bin/bash

import sys
import os
import subprocess

sys.path.insert(0, '/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/Scripts')
#sys.path.insert(0, '/home/lixin/Documents/Prototype/PythonProject/PacbioSV/Scripts')

from RunPacbioSV import *
configfile: "../../Configs/pacbioSV.yaml"
shell.executable('bash')

# Reconstruct Folder
buidDir = config["General"]["buildDir"]
readsList = config["Customized"]["readsList"]

# Data preprocess
# 1: Reconstruct Folder
CMD = "python3 ../../Scripts/ReconstructFolder.py " + buidDir + " " + readsList
print(CMD)
os.system(CMD)

# Do pipeline itself
# Get Some wildcard
# a) Get Build Name 
CMD = "find " + buidDir + " -mindepth 1 -maxdepth 1 -type d"
vBuildList = subprocess.getoutput(CMD).split('\n')
print("vBuildList:", vBuildList)


if len(vBuildList) == 0:
     print("No Build Found! Exit!")
     exit
     
# vBuidName = []
# for strBuild in vBuildList:
#     vBuidName.append(os.path.basename(strBuild))
# print("vBuidName:", vBuidName)

# b) Get
print("Load Rules ...")

# Run data preprocess
include: "../../Rules/QC/readsQC.rule"

# Run Aligner
print("Load Aligner Rules ...")
include: "../../Rules/Aligner_General/ngmlr.rule"
include: "../../Rules/Aligner_General/pbmm2.rule"

# Run SV Caller
include: "../../Rules/SV_Caller_General/cutesv.rule"
include: "../../Rules/SV_Caller_General/pbsv.rule"
include: "../../Rules/SV_Caller_General/sniffles.rule"


print("Rule all!")

dicSampleName = {}
vBuildName = []
for strBuildDir in vBuildList:
    CMD = "find " + strBuildDir + "/Sample -maxdepth 2 -type l -iname '*.bam'"
    vTmpList = subprocess.getoutput(CMD).split('\n')
    vSampleName = []
    for strReads in vTmpList:
        strName = strReads.split('/')[-2]
        print(strName)
        vSampleName.append(strName)          
    strBuildName = os.path.basename(strBuildDir)
    vBuildName.append(strBuildName) 
    dicSampleName[strBuildName] = vSampleName

# For expand in rule all
vExpKeyBuildName = [key for key, val in dicSampleName.items() for _ in range(len(val))]
vExpSampleName = sum(dicSampleName.values(), [])
print("vExpKeyBuildName:", vExpKeyBuildName)
print("vExpSampleName  :", vExpSampleName)

vAligner = ["NGMLR", "PBMM2"]
vRef = ["v38"]

rule all:
    input:
        #For raw reads QC evaluation
        expand(buidDir + "/{wcBuildName}/Report/NanoPlot/NanoPlot-report.html",
               wcBuildName = vBuildName),
        #expand(buidDir + "/{wcBuildName}/Report/NanoPlot_HQ/NanoPlot-report.html",
        #       wcBuildName = vBuildName),  
        #expand(buidDir + "/{wcCurBuildName}/Sample/{wcCurSampleName}/Fastq/{wcCurSampleName}_hifi_reads.HQ.fastq.gz",
        #       wcCurBuildName = vExpKeyBuildName,                  
        #       wcCurSampleName = vExpSampleName),
        #expand(buidDir + "/{wcCurBuildName}/BAM/{wcRefVersion}/{wcAligner}/{wcCurSampleName}_hifi.RG.MD.sorted.bam.bai",
        #       wcCurBuildName = vExpKeyBuildName,                  
        #       wcCurSampleName = vExpSampleName,
        #       wcRefVersion = vRef,
        #       wcAligner = vAligner) 
        expand(buidDir + "/{wcCurBuildName}/Report/SV/cuteSV/{wcCurSampleName}/{wcRefVersion}/{wcAligner}/minSupport_{wcMinSupportCuteSV}/{wcCurSampleName}_hifi.RG.MD.sorted.{wcMinSupportCuteSV}.cuteSV.vcf",
               wcCurBuildName = vExpKeyBuildName,                  
               wcCurSampleName = vExpSampleName,
               wcRefVersion = vRef,
               wcAligner = vAligner,
               wcMinSupportCuteSV = config["cuteSV"]["minSupport"].split(',')),
        expand(buidDir + "/{wcCurBuildName}/Report/SV/pbsv/{wcCurSampleName}/{wcRefVersion}/{wcAligner}/minReads_{wcMinReads}/{wcCurSampleName}_hifi.RG.MD.sorted.{wcMinReads}.pbsv.vcf",
               wcCurBuildName = vExpKeyBuildName,                  
               wcCurSampleName = vExpSampleName,
               wcRefVersion = vRef,
               wcAligner = vAligner,
               wcMinReads = config["pbsv"]["minReads"].split(',')),
        expand(buidDir + "/{wcCurBuildName}/Report/SV/sniffles/{wcCurSampleName}/{wcRefVersion}/{wcAligner}/minSupport_{wcMinSupportSniffle}/{wcCurSampleName}_hifi.RG.MD.sorted.{wcMinSupportSniffle}.sniffles.vcf",
               wcCurBuildName = vExpKeyBuildName,                  
               wcCurSampleName = vExpSampleName,
               wcRefVersion = vRef,
               wcAligner = vAligner,
               wcMinSupportSniffle = config["sniffles"]["minSupport"].split(','))
        
                    
print("Run the first rule!")


        