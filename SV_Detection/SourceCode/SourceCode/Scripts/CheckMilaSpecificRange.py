'''
Abandon!
'''
import os
import subprocess

class ClsSV:
    def __init__(self):
        self.strChrom = ""
        self.strType = ""        
        self.iPos = ""
        self.strRef = ""
        self.strAlt = ""
        self.strGenotype = ""
        
    def InitFromVCF(self, strLine):
        vInfo = strLine.split('\t')
        self.strChrom = vInfo[0]
        if "chr" not in self.strChrom:
            self.strChrom = "chr" + self.strChrom
        self.iPos = int(vInfo[1])
        self.strRef = vInfo[3]
        self.strAlt = vInfo[4]
        self.strType = vInfo[7].split('SVTYPE=')[-1].split(';')[0]

class ClsCuteSV:
    def __init__(self):
        self.vThreshould = []
        self.vSV = [] # this should be [[]]
        self.vHit = []

class ClsSample:
    def __init__(self):
        self.strRefVersion = ""
        self.strSVCaller = ""
        self.strAligner = ""
        self.strReadsType = ""
        self.strThreashold = ""
        self.objMetrics = ClsMetrics()        
        self.vSV = []        
    
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

def main():    
    
    vSample = []
    
    # Get True set Info
    GetTrueSetInfo(objTrueSet)
    
    # Get Sample Info
    GetSampleInfo(vSample)
    
    # Do Comparison
    for objSample in vSample:
        Comparison(objSample, objTrueSet)
        #PrintCmpResult(objSample, objTrueSet)
        
if __name__ == "__main__":        
    main()
            