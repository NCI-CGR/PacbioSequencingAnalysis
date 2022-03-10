import sys
sys.path.insert(0, '/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/Scripts')
from RunPacbioSV import *
configfile: "../Configs/pacbioSV.yaml"



objBuild = GetBuild(config["Customized"]["rootDir"], config["Customized"]["outputDir"])
vBAM, vSampleFullName, vSignature = GetInfo(objBuild.vSample)

#Check version number in snakemake
print("Check version number in smakemake (Python3, GCC and PBSV) -> ")
os.system("python3 --version")
os.system("gcc --version")
os.system("pbsv --version")

# Run rules one by one
rule all:
     input:        
         vSignature,
         objBuild.strSVResult

rule discover_signatures:
    input:
        bam = objBuild.strBAMDir + "/{sample}.bam"        
    output:
        svSigGz = objBuild.strSignatureDir + "/{sample}.svsig.gz"
    run:
        shell('pbsv discover {input} {output}')
        
rule call_sv:
    input:
        ref = config["General"]["ref"],
        vSignatureFiles = vSignature        
    output:        
        svResult = objBuild.strSVResult
    threads: config["RuleCallSV"]["core"]
    run:
        shell("pbsv call -j {threads} {input} {output}")
        
    