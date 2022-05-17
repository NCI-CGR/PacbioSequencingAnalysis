### Motivation
1. Mila sent us several samples and there are some SVs should be contained by all these samples.
2. Mila want to address the issue why these SVs did not report in callset.
3. These SVs are very important for her research project.

### Purpose (CGR)
1. Find a way to call these missing SVs
2. Explain why these SVs were missing 
3. Build a benchmark to create a guaidline to let people know 
   * how to choose parameters
   * how to choose aligners
   * how to choose SV callsers
4. New project: Create a general SV pipeline to handle NCI/CGR-site-wide samples for general purpose
   * Will crate another doc for this project

### Prgress 
1. Finished
   * Find a way to call these missing SVs
   * Explain why these SVs were missing
   * The testing by using
     *  Different caller
     *  Different aligner
     *  Different parameters
2. TBD
    * Summarize the guaidline

### Resources (Doc)
1. Frogbug tickets
   * https://cgr-bugz.nci.nih.gov/f/cases/30037/
   * https://cgr-bugz.nci.nih.gov/f/cases/30000
 
2. Repo
   * https://github.com/NCI-CGR/PacbioSequencingAnalysis/tree/main/SV_Detection/SourceCode
 
### Data Resources (Benchmark)
1. Reference (v37)
   * /CGF/Resources/Data/genome/obsolete/hg19_canonical+phiX.fa

2. SV True Set (v37)
   * /CGF/Bioinformatics/Production/data/Giab/AshkenazimTrio_v4.2.1/HG002_SVs_Tier1_v0.6.vcf.gz

3. pbmm2 BAM location (Mila's data, v38)
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_location

4. NGMLR BAM location (Mila's data, v38)
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_location_ngmlr

5. SV calling results location
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/SV/Callset

6. SV Benchmark Analysis results:
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/SV/Benchmark

7. Benchmark pbmm2 BAM location (HG002 with v37)
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/pbmm2/v37

8. Benchmark NGMLR BAM location (HG002 with v37)
   * /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/ngmlr/v37

9. Raw reads (HG002):
   * a)HG002 standard (3 smart cell): 
      * 24385-Standard    NP0084-002    15611    17449    15024    
   * b)HG002 Ultra Low (4 smart cell)
      * 24385-Ultra-Low    NP0084-002      7880    8308    15230
