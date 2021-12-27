import sys
import subprocess
import os

runSnifflesScript = "./call_sniffles.sh"
resultDir = "/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_location_ngmlr/SV/Sniffles"

class ClsSample:
    def __init__(self):
        self.strName = ""
        self.strPath = ""
        self.strBAM = ""
    
    def Init(self, strFullPathBAM):
        self.strName = os.path.basename(strFullPathBAM).split(".")[0]
        self.strPath = os.path.dirname(strFullPathBAM)
        self.strBAM = strFullPathBAM
    
    def Print(self):
        print("*************")
        print("strName:", self.strName)
        print("strPath:", self.strPath)
        print("strBAM :", self.strBAM)
        print("*************")
        print()      
        
    def SubmitJob(self):
        strCurSampleDir = resultDir + "/" + self.strName
        if not os.path.exists(strCurSampleDir):
            CMD = "mkdir -p " + strCurSampleDir            
            os.system(CMD)
        
        strCurSampleLogDir = strCurSampleDir + "/Log"
        if not os.path.exists(strCurSampleLogDir):
            CMD = "mkdir -p " + strCurSampleLogDir            
            os.system(CMD)
        
        # --> Submit sge job -> Go!
        # CMD = ("bash " + runSnifflesScript + " " + "\"" + self.strName + "\" " +
        #                                      "\"" + self.strBAM + "\" " + 
        #                                      "\"" + resultDir + "\"")  
        # os.system(CMD)
        # # <--     
        QUEUE = "all.q"
        CORES = "12"
        
        strLogStdOut = strCurSampleLogDir + "/_call_sv_" + self.strName + ".stdout"
        strLogStdErr = strCurSampleLogDir + "/_call_sv_" + self.strName + ".stderr"
        
        if os.path.exists(strLogStdOut):
            CMD = "rm " + strLogStdOut
            os.system(CMD)
        if os.path.exists(strLogStdErr):
            CMD = "rm " + strLogStdErr
            os.system(CMD)      
        
        CMD = ("qsub -cwd -q " + QUEUE + " -pe by_node " + CORES + " " + 
                     "-o " + strLogStdOut + " " + 
                     "-e " + strLogStdErr + " " + 
                     "-N " + "SV.Sniffles." + self.strName + " " +  
                     "-S /bin/bash " + runSnifflesScript + " " + "\"" + self.strName    + "\" " +
                                                                 "\"" + self.strBAM     + "\" " + 
                                                                 "\"" + strCurSampleDir + "\" " + 
                                                                 "\"" + CORES           + "\"")
        print("CMD:", CMD)
        print()
        os.system(CMD)
        print("\n", "***", "\n")        

def main():
    strDir = sys.argv[1]
    #Find all bam in current fastq 
    CMD = "find " + strDir + " -maxdepth 1 -type f -iname '*.bam'"
    vBAM = subprocess.getoutput(CMD).split('\n')
    vSample = []
    for strBAM in vBAM:
        objSample = ClsSample()
        objSample.Init(strBAM)
        vSample.append(objSample)
    
    for objSample in vSample:
        objSample.SubmitJob() 
            
if __name__ == "__main__":        
    main()