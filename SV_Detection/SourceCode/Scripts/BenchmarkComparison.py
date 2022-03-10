import os
import subprocess
import sys

strTrueSet = "/scratch/lix33/lxwg/Project/Pacbio/TrueSet/HG002_SVs_Tier1_v0.6.vcf"
#strTrueSet = "/home/lixin/lxwg/Data/TrueSVSet/HG002_Test_Set.vcf"

strSVCallSetDir = "/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/SV"
#strSVCallSetDir = "/home/lixin/lxwg/Data/svCallSet"

#Compare the results with Benchmark -> Go!

class ClsSV:
    def __init__(self):
        self.strChrom = ""
        self.strType = ""        
        self.iPos = ""
        self.strRef = ""
        self.strAlt = ""
        self.strGenotype = ""
    def Print(self):
        print("strChrom:", self.strChrom)
        print("strType :", self.strType)
        print("iPos    :", self.iPos) 
        print("strRef  :", self.strRef)
        print("strAlt  :", self.strAlt)
        print()
    
    def InitFromVCF(self, strLine):
        vInfo = strLine.split('\t')
        self.strChrom = vInfo[0]
        if "chr" not in self.strChrom:
            self.strChrom = "chr" + self.strChrom
        self.iPos = int(vInfo[1])
        self.strRef = vInfo[3]
        self.strAlt = vInfo[4]
        self.strType = vInfo[7].split('SVTYPE=')[-1].split(';')[0]

class ClsTrueSet:
    def __init__(self):
        self.vSV = []
        self.objMetrics = ClsMetrics()
        self.dicSV = {}
            
    def InitSV(self, strTrueSetFile):
        self.vSV.clear()    
        CMD = ("tail -n +$(echo $(grep -in '#CHROM' " + strTrueSetFile + 
              " | awk -F ':' '{print $1}') + 1 | bc) " + strTrueSetFile)
        vLine = subprocess.getoutput(CMD).split('\n')        
        for strLine in vLine:
            objSV = ClsSV()
            objSV.InitFromVCF(strLine)
            self.vSV.append(objSV)
        # -> Init Dic SV (separate SV by Chrom Name)
        for objSV in self.vSV:
            if objSV.strChrom not in self.dicSV.keys():
                self.dicSV[objSV.strChrom] = []
            self.dicSV[objSV.strChrom].append(objSV)
        
        # for key in self.dicSV:
        #     print(key)
        #     print(len(self.dicSV[key]))  
            
    def GetBasicMetricsInfo(self):
        self.objMetrics.GetBasicMetricsInfo(self.vSV)
        
class ClsSample:
    def __init__(self):
        self.strRefVersion = ""
        self.strSVCaller = ""
        self.strAligner = ""
        self.strReadsType = ""
        self.strThreashold = ""
        self.objMetrics = ClsMetrics()        
        self.vSV = []
        self.dicSV = {}
    
    def InitSV(self, strVCF):
        self.vSV.clear()
        # Read SV
        CMD = ("tail -n +$(echo $(grep -in '#CHROM' " + strVCF + 
              " | awk -F ':' '{print $1}') + 1 | bc) " + strVCF)
        vLine = subprocess.getoutput(CMD).split('\n')
        for strLine in vLine:
            objSV = ClsSV()
            objSV.InitFromVCF(strLine)
            self.vSV.append(objSV)
        
        # for objSV in self.vSV:
        #     objSV.Print()
        #     break
        
        # -> Init Dic SV (separate SV by Chrom Name)
        for objSV in self.vSV:
            if objSV.strChrom not in self.dicSV.keys():
                self.dicSV[objSV.strChrom] = []
            self.dicSV[objSV.strChrom].append(objSV)
        
        # for key in self.dicSV:
        #     print(key)
        #     print(len(self.dicSV[key])) 
    
    def InitBasicInfo(self, strFile):
        vInfo = strFile.split(strSVCallSetDir + "/")[1].split('/')
        #print(vInfo)
        self.strRefVersion = vInfo[0]
        self.strSVCaller = vInfo[1]
        self.strAligner = vInfo[2]
        self.strReadsType = vInfo[3]
        self.strThreashold = vInfo[4]
    
    def GetBasicMetricsInfo(self):
        print("========== Current Set Info ===========")
        self.objMetrics.GetBasicMetricsInfo(self.vSV)
    
    def GetCompInfo(self, objTrueSet):
        # Do Comparison Here
        self.objMetrics.GetCompInfo(self.dicSV, objTrueSet.dicSV, len(objTrueSet.vSV))
    
    def PrintCmpInfo(self):
        print("------- Sample Info --------")
        self.Print()        
        print('>>>>>> Cmp Metrics Info <<<<<<<')
        print("dicTypeNum             :", self.objMetrics.dicTypeNum)
        print("dicHitSVNum            :", self.objMetrics.dicHitSVNum)
        print("iTrueNum               :", self.objMetrics.iTrueNum)
        print("iTotalTargetTypeInCurSV:", self.objMetrics.iTotalTargetTypeInCurSV)
        print("iFalseNum              :", self.objMetrics.iFalseNum, "(iTotalTargetTypeInCurSV - iTrueNum)")
        print("fAccuracy              :", "{:.4f}".format(self.objMetrics.fAccuracy))
        print("fSensitivity           :", "{:.4f}".format(self.objMetrics.fSensitivity))
        print("fF1                    :", "{:.4f}".format(self.objMetrics.fF1))
    
    def Print(self):
        print("strRefVersion:", self.strRefVersion)
        print("strSVCaller  :", self.strSVCaller)
        print("strAligner   :", self.strAligner)
        print("strReadsType :", self.strReadsType)
        print("strThreashold:", self.strThreashold)    
        print()

class ClsMetrics():
    def __init__(self):
        self.iSVNum = ""
        self.dicTypeNum = {}
        self.dicHitSVNum = {}
        self.iTrueNum = 0
        self.iFalseNum = 0        
        self.fAccuracy = 0
        self.fSensitivity = 0
        self.fF1 = 0
        self.iTotalTargetTypeInCurSV = 0
    
    def GetBasicMetricsInfo(self, vSV):
        self.iSVNum = len(vSV)
        self.dicTypeNum.clear()
        for objSV in vSV:
            if not objSV.strType in self.dicTypeNum.keys(): 
                self.dicTypeNum[objSV.strType] = 1
            else:
                self.dicTypeNum[objSV.strType] += 1
        print("iSVNum    :",  self.iSVNum)
        print("dicTypeNum:", self.dicTypeNum)
        print()
    
    def GetCompInfo(self, dicCurSV, dicTrueSV, iTrueSetSVTotal):
        # Go!        
        self.iTotalTargetTypeInCurSV = 0        
        for key in dicTrueSV:
            if key in dicCurSV.keys():
                #Only count the number of DEL and INS, since only these two types of SV contains in True Set.
                for tmpSV in dicCurSV[key]:
                    if "DEL" in tmpSV.strType or "INS" in tmpSV.strType: 
                        self.iTotalTargetTypeInCurSV += 1
                # Do Comparison
                for trueSV in dicTrueSV[key]:
                    for curSV in dicCurSV[key]:
                        if curSV.strType == trueSV.strType and abs(curSV.iPos - trueSV.iPos) <= 100: 
                            if curSV.strType not in self.dicHitSVNum.keys():
                                self.dicHitSVNum[curSV.strType] = 1
                            else:
                                self.dicHitSVNum[curSV.strType] += 1
            else:
                #print("Nothing can be found! --> ", key)
                continue            
        #print("Hit Set:", self.dicHitSVNum)
        
        # Calculate Metrics for current Sample:
        for key in self.dicHitSVNum:
            self.iTrueNum += self.dicHitSVNum[key]
            
        #self.iFalseNum = self.iSVNum - self.iTrueNum
        #self.fAccuracy = self.iTrueNum / self.iSVNum                
        self.iFalseNum = self.iTotalTargetTypeInCurSV - self.iTrueNum
        self.fAccuracy = self.iTrueNum / self.iTotalTargetTypeInCurSV
        
        self.fSensitivity = self.iTrueNum / iTrueSetSVTotal
        
        self.fF1 = 2 * self.fAccuracy * self.fSensitivity / (self.fAccuracy + self.fSensitivity)
                
# Done 
def GetTrueSetInfo(objTrueSet):
    if not os.path.exists(strTrueSet):
        print("Error: Cannot find tree set!")
        return 1
    
    objTrueSet.InitSV(strTrueSet)
    objTrueSet.GetBasicMetricsInfo()
    
    # for objSV in objTrueSet.vSV:
    #     objSV.Print()
    #     break    

# Go Next
def GetSampleInfo(vSample):
    if not os.path.exists(strSVCallSetDir):
        print("Error: sv path cannot be found!")
        return 1
    
    CMD = "find " + strSVCallSetDir + " -iname '*.vcf'"
    vLine = subprocess.getoutput(CMD).split('\n')
    vSample.clear()
    for strVCF in vLine:
        objSample = ClsSample()
        objSample.InitSV(strVCF)
        # Read Other basic sample info
        objSample.InitBasicInfo(strVCF)        
        #objSample.Print()        
        vSample.append(objSample)

# Go Comparison
def Comparison(objSample, objTrueSet):
    objSample.GetBasicMetricsInfo()
    objSample.GetCompInfo(objTrueSet)
    objSample.PrintCmpInfo()
    
def PrintCmpResult(vSample, objTrueSet):
    strFile = "/scratch/lix33/lxwg/SourceCode/PacbioSV/Log/Benchmark/BenchmarkTesting.csv"
    original_stdout = sys.stdout
    with open(strFile, 'w') as f:
        sys.stdout = f
        print("#TrueSet Info")
        print("iSVNum    :", objTrueSet.objMetrics.iSVNum)
        print("dicTypeNum:", objTrueSet.objMetrics.dicTypeNum)
        print()
        print("Caller_Name,Ref_Version,Aligner,ReadsType,Threshold,Accuracy,Sensitivity,F1,HitTrueSetNum,HitTypeNun,dicHitSV,dicOrgSV")
        # Print the sample comparison info
        for objSample in vSample:            
            strLine = (objSample.strSVCaller + "," + 
                       objSample.strRefVersion + "," +
                       objSample.strAligner + "," +
                       objSample.strReadsType + "," +
                       objSample.strThreashold + "," +
                       "{:.4f}".format(objSample.objMetrics.fAccuracy) + "," +
                       "{:.4f}".format(objSample.objMetrics.fSensitivity) + "," +
                       "{:.4f}".format(objSample.objMetrics.fF1) + "," +
                       str(objSample.objMetrics.iTrueNum) + "," +
                       str(objSample.objMetrics.iTotalTargetTypeInCurSV) + ",") 
            print(strLine, objSample.objMetrics.dicHitSVNum, ",", objSample.objMetrics.dicTypeNum)
    sys.stdout = original_stdout

def main():
    objTrueSet = ClsTrueSet()
    vSample = []
    
    # Get True set Info
    print("=========== Ground Truth Info (True Set, V37) ===========")
    GetTrueSetInfo(objTrueSet)
    print(">>>>>>>>>>>>>------<<<<<<<<<<<<<<<<<")
    
    # Get Sample Info
    GetSampleInfo(vSample)
    
    # Do Comparison
    for objSample in vSample:
        Comparison(objSample, objTrueSet)
    
    PrintCmpResult(vSample, objTrueSet)
        
if __name__ == "__main__":        
    main()
        
        