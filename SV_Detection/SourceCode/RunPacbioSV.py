'''
1: Parse Pacbio SV data
2: Call Pacbio SV
3: Generate Report
'''
######################
import os
import sys
import subprocess
import yaml

class ClsSample:
    def __init__(self):
        self.strRawReads = ""
        self.strRawBAM = ""        
        self.strSortedBAM = ""
        self.strSignatureFile = ""        
        self.strName = ""
        self.strFullName = ""
        
    def Init(self, strBAMfile, strSignatureDir):
        strFilName = os.path.basename(strBAMfile)
        self.strFullName = strFilName.split(".bam")[0]
        self.strName = strFilName.split(".bam")[0].split("_")[-1]
        self.strSignatureFile = strSignatureDir + "/" + self.strFullName + ".svsig.gz" 
        self.strRawBAM = strBAMfile     

class ClsBuild:
    def __init__(self):
        self.vSample = []
        self.strBAMDir = ""
        self.strSVResult = ""
        self.strSignatureDir = ""
    
    def Init(self, strBAMDir, strOutputDir):
        self.strBAMDir = strBAMDir
        self.vSample.clear()
        
        strSignatureDir = strOutputDir + "/Signature"
        if not os.path.exists(strSignatureDir):
            print("Create 'signature' folder!")
            CMD = "mkdir -p " + strSignatureDir
            os.system(CMD)
        self.strSignatureDir = strSignatureDir
         
        strResultDir = strOutputDir + "/Result"
        if not os.path.exists(strResultDir):
            print("Create 'result' folder!")
            CMD = "mkdir -p " + strResultDir
            os.system(CMD)
        self.strSVResult = strResultDir + "/sv.vcf"
                
        # Init samples -> Go
        if os.path.exists(strBAMDir):
            CMD = "find " + strBAMDir + " -type f -iname '*.bam'"
            vBAM = subprocess.getoutput(CMD).split('\n')
            #print(vBAM)
            for strBAMfile in vBAM:
                if not os.path.exists(strBAMfile):
                    continue 
                #print(strBAMfile)
                objSample = ClsSample()
                objSample.Init(strBAMfile, strSignatureDir)
                self.vSample.append(objSample)
        else:
            print("PATH does not exist!: ", strBAMDir)

def GetBuild(strBAMDir, strOutputDir):
    print("Initial Build -> Go!")
    #print(strBAMDir)
    objClsBuild = ClsBuild()
    objClsBuild.Init(strBAMDir, strOutputDir)
    # for sample in objClsBuild.vSample:
    #     print(sample.strRawBAM)        
    return objClsBuild

def GetInfo(vSample):
    vBAM = []
    vSampleFullName = []
    vSignature = []
    for sample in vSample:        
        vBAM.append(sample.strRawBAM)
        vSampleFullName.append(sample.strFullName)
        vSignature.append(sample.strSignatureFile)        
    return vBAM, vSampleFullName, vSignature

def RunSnakemake():
    f = open('cluster_config.yaml')
    data = yaml.load(f, Loader=yaml.FullLoader)
    f.close()
    
    # Get cluster info from cluster_config.yaml
    partition = data["default"]["queue"]
    pe = data["default"]["pe"]
    numCore = data["default"]["numCore"]
    smlogDir = data["default"]["smlogDir"]
    
    # Check if log directory exist ->
    if not os.path.exists(smlogDir):
        CMD = "mkdir -p " + smlogDir        
        os.system(CMD)
    
    # Prepare Cluster Parameters used in snakemake command line  
    strClusterPara = ("qsub -q " + partition +
                      " -pe " + pe + " " + str(numCore) +  
                      " -cwd" + 
                      " -V" + 
                      " -j y" +   
                      " -o " + smlogDir)
    
    CMD = ("bash ./wrapper.sh " + 
           "\"" + strClusterPara + "\"")
    print(">>> Call wrapper")            
    print(CMD)
    print
    os.system(CMD)    

def main():
    strFuncName = sys.argv[1]        
    if strFuncName == "GetSample":
        f = open('cluster_config.yml')
        data = yaml.load(f, Loader=yaml.FullLoader)
        print(data)
        f.close()
        print(data["default"]["queue"])
        
        strBAMDir = sys.argv[2]
        strOutputDir = sys.argv[3]
        objBuild = GetBuild(strBAMDir, strOutputDir)
        print("All Set!")
        return objBuild.vSample
    if strFuncName == "RunSnakemake":
        RunSnakemake()    

if __name__ == "__main__":        
    main()
        
    