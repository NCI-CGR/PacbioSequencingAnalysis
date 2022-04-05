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

print("Rule all!")

rule all:
    input:
        # For raw reads QC evaluation
        expand("{wcBuildList}/Report/NanoPlot/NanoPlot-report.html",
                wcBuildList = vBuildList)

print("Run the first rule!")

#2: Pre-quality check
rule CheckRawReadsQC:
    input:
        curBuild = "{wcBuildList}"
    output:
        "{wcBuildList}/Report/NanoPlot/NanoPlot-report.html"
    params:
        outputDir = "{wcBuildList}/Report/NanoPlot"        
    threads: 8
    log:
        "{wcBuildList}/Log/NanoPlot/NanoPlot.log"
    benchmark:
        "{wcBuildList}/Benchmark/NanoPlot/NanoPlot.benchmark.txt"
    run:        
        CMD = "find " + input.curBuild + "/Sample -maxdepth 2 -type l -iname '*.bam'"
        vReadsList = subprocess.getoutput(CMD).split('\n')
        print("Reads List:", vReadsList)
        strReadsList = " ".join(vReadsList)
        
#        shell('echo "\n"')
#        shell('echo "NanoPlot -t {threads} --ubam ${strReadsList} --maxlength 40000 --plots dot --legacy hex"')
#        shell('echo "\n"')
#        shell('NanoPlot -t 8 --ubam ${strReadsList} --maxlength 40000 --plots dot --legacy hex')
        
        CMD = "NanoPlot -t " + str(threads) + " --ubam " + strReadsList + " --maxlength 40000 --plots dot --legacy hex --outdir " + params.outputDir
        print("CMD:", CMD)
        os.system(CMD)
        
        
        
        