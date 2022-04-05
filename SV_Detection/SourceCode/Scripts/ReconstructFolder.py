'''
1: Parse Pacbio SV data
2: Call Pacbio SV
3: Generate Report
'''
######################
import os
import sys
import subprocess
import csv
from datetime import date
from pathlib import Path

class ClsBuild:
    def __init__(self):
        self.strName = ""
        self.vSample = []
    
    def InitSample(self, strCSVFile):
        # Set Build Name 
        strFileName = os.path.basename(strCSVFile).split('.')[0]
        self.strName = "Build_" + strFileName 
        # Set sample info
        self.vSample.clear()
        with open(strCSVFile, mode='r') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            for row in csv_reader:
                objSample = ClsSample()
                objSample.strName = row['reads']
                objSample.strPath = row['path']
                self.vSample.append(objSample)
    
    def CreateDir(self, strPath):
        if os.path.exists(strPath):
            return
        CMD = "mkdir -p " + strPath
        os.system(CMD)
    
    def ReconstructBuildDir(self, strRootDir):
        #Check if we have the folder contain bild name
        bFindExist = False
        strBuildDir = "" 
        if os.path.exists(strRootDir):
            CMD = "find " + strRootDir + " -mindepth 1 -maxdepth 1 -type d -iname '*" + self.strName + "*'"
            print(CMD)
            strFileList = subprocess.getoutput(CMD)
            if strFileList != "":
                strBuildDir = strFileList
                bFindExist = True 
                
        #If not create a new build folder
        if not bFindExist:
            strBuildDir =  strRootDir + "/" + self.strName + "_" + str(date.today())
            CMD = "mkdir -p " + strBuildDir
            os.system(CMD)
        else:
            print("strBuildDir EXISTED!") 
        print("strBuildDir:", strBuildDir)
        
        # Create Folder -> Go!
        strSampleDir = strBuildDir + "/Sample"
        self.CreateDir(strSampleDir)
        strBAMDir = strBuildDir + "/BAM/v38"
        self.CreateDir(strBAMDir)
        strLogDir = strBuildDir + "/Log"
        self.CreateDir(strLogDir)
        strBenchmarkDir =  strBuildDir + "/Benchmark"
        self.CreateDir(strBenchmarkDir)
        strReportDir =  strBuildDir + "/Report"
        self.CreateDir(strReportDir)
        strTmpDir =  strBuildDir + "/Tmp"
        self.CreateDir(strTmpDir)
        
        # Initiate Sample 
        for objSample in self.vSample:
            strCurDir = strSampleDir + "/" +  objSample.strName
            # Create sample folder
            if not os.path.exists(strCurDir):
                CMD = "mkdir -p " + strCurDir 
                os.system(CMD)
            # Create softlink
            strSoftLink = strCurDir + "/" + objSample.strName + "_hifi_reads.bam"
            if Path(strSoftLink).is_symlink():
                continue
            else:
                if not os.path.exists(strSoftLink):
                    print("It is me!", strSoftLink)
                    CMD = "ln -s " + objSample.strPath + " " + strSoftLink 
                    os.system(CMD)

class ClsSample:
    def __init__(self):
        self.strName = ""
        self.strPath = ""

def main():
    # Get Argument1 and Argument 2 to build the structure of    
    rootDir = sys.argv[1]
    readsCSV = sys.argv[2]
    
    objBuild = ClsBuild()     
    objBuild.InitSample(readsCSV)
    objBuild.ReconstructBuildDir(rootDir)
    
if __name__ == "__main__":        
    main()