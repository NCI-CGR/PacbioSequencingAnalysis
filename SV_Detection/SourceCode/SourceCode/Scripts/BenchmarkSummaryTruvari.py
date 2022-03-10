import os
import subprocess
import sys
import yaml
import json

YAMLFile = "../Configs/benchmarkTest.yaml"

class ClsSample:
    def __init__(self):
        self.strSVCaller = ""
        self.strReadsType = ""
        self.strAligner = ""
        self.strRefVersion = ""
        self.strCriteria = ""    
        self.strSVFile = ""
        self.objMetrics = ClsMetrics()
        
    def Init(self, strDir):
        strItem = strDir.split('/')
        self.strCriteria = strItem[-2] 
        self.strReadsType = strItem[-3]
        self.strAligner = strItem[-4]
        self.strSVCaller = strItem[-5]
        self.strRefVersion = strItem[-6]
        self.objMetrics.Init(strDir)
        # Get vcf file -> go!
        self.strSVFile = subprocess.getoutput("find " + os.path.dirname(strDir) + " -maxdepth 1 -type f -iname '*.vcf' | head -n 1") 
        if not os.path.exists(self.strSVFile):
            print("Error: SV File does not exist!", self.strSVFile)
        
class ClsMetrics:
    def __init(self):
        self.iTPbase = 0
        self.iTPcall = 0
        self.iFP = 0
        self.iFN = 0
        self.fPrecision = 0
        self.fRecall = 0
        self.fF1 = 0
        self.iBaseCNT = 0
        self.iCallCNT = 0
        self.iTPcallTPgt = 0
        self.iTPcallFPgt = 0
        self.iTPbaseTPgt = 0
        self.iTPbaseFPgt = 0
        self.fGTConcordance = 0
    
    def Init(self, strDir):
        strSummaryFile = strDir + "/summary.txt"
        if not os.path.exists(strSummaryFile):
            print("Error: summary.txt is invalid!:", strSummaryFile)
        
        with open(strSummaryFile) as f:
            data = f.read()
        js = json.loads(data)
        
        self.iTPbase = int(js["TP-base"])
        self.iTPcall = int(js["TP-call"])
        self.iFP = int(js["FP"])
        self.iFN = int(js["FN"])
        self.fPrecision = float(js["precision"])
        self.fRecall = float(js["recall"])
        self.fF1 = float(js["f1"])
        self.iBaseCNT = int(js["base cnt"])
        self.iCallCNT = int(js["call cnt"])
        self.iTPcallTPgt = int(js["TP-call_TP-gt"])
        self.iTPcallFPgt = int(js["TP-call_FP-gt"])
        self.iTPbaseTPgt = int(js["TP-base_TP-gt"])
        self.iTPbaseFPgt = int(js["TP-base_FP-gt"])
        self.fGTConcordance = float(js["gt_concordance"])
        
def InitSample(vSampleList):
    strSVDir = ""
    with open(YAMLFile) as file:
        documents = yaml.full_load(file)
        strSVDir = documents["GeneralInfo"]["svDir"]
        
    if not os.path.exists(strSVDir):
        print("Error: SV Dir is invalid!:", strSVDir)
    
    vSampleList.clear()    
    vLine = subprocess.getoutput("find " + strSVDir + " -type d -iname 'Output_Benchmark_Cmp' | sort").split('\n')
    for strDir in vLine:
        objSample = ClsSample()
        objSample.Init(strDir)
        vSampleList.append(objSample)

def CreateSummaryCSV(vSampleList):
    strSVDir = ""
    with open(YAMLFile) as file:
        documents = yaml.full_load(file)
        strSVDir = documents["GeneralInfo"]["svDir"]
        
    strFileName = strSVDir + "/BenchmarkSummary.csv"
    f = open(strFileName, "w")
    strCaptions = "SVCaller,Aligner,RefVersion,ReadsType,Criteria,TP-base,TP-call,FP,FN,precision,recall,F1,base cnt,call cnt,TP-call_TP-gt,TP-call_FP-gt,TP-base_TP-gt,TP-base_FP-gt,gt_concordance,SVFile\n"
    f.write(strCaptions)
    for objSample in vSampleList:
        strLine = (objSample.strSVCaller + "," +
                   objSample.strAligner + "," +
                   objSample.strRefVersion + "," +
                   objSample.strReadsType + "," + 
                   objSample.strCriteria + "," + 
                   str(objSample.objMetrics.iTPbase) + "," +   
                   str(objSample.objMetrics.iTPcall) + "," +
                   str(objSample.objMetrics.iFP) + "," +
                   str(objSample.objMetrics.iFN)  + "," +
                   str("{:.3f}".format(objSample.objMetrics.fPrecision)) + "," +
                   str("{:.3f}".format(objSample.objMetrics.fRecall)) + "," +
                   str("{:.3f}".format(objSample.objMetrics.fF1)) + "," +
                   str(objSample.objMetrics.iBaseCNT) + "," +
                   str(objSample.objMetrics.iCallCNT) + "," +
                   str(objSample.objMetrics.iTPcallTPgt) + "," +
                   str(objSample.objMetrics.iTPcallFPgt) + "," +
                   str(objSample.objMetrics.iTPbaseTPgt) + "," +
                   str(objSample.objMetrics.iTPbaseFPgt) + "," +
                   str("{:.3f}".format(objSample.objMetrics.fGTConcordance)) + "," + 
                   objSample.strSVFile + "\n")
        f.write(strLine)
    f.close()    

def main():
    vSampleList = []
    InitSample(vSampleList)
    CreateSummaryCSV(vSampleList)
        
if __name__ == "__main__":        
    main()