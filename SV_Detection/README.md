# Introduction

## Motivation
1: Since Pacbio reads is much longer than Illumina reads, we expect it can bring us more valuable SV. 


## Initial Plan 
1: Try Targeted Pacbio Reads

2: Try whole genome pacbio Reads

## Implementation
1: Add pbsv into the pipeline 

2: Investigate and add more state-of-art tools later

3: Do benchmark to see the performance of each tools.

## Key source code introudction
- job.sh
  - sge job script file, which is used to submit host job. 
- run.sh
  - It will call the main python code
- RunPacbioSV.py
  - Main source code for data preprocessing 
- smCallSV.snake
  - Main snakemake file for calling sv by using multiple rules 
- wrapper.sh
  - wrapper that is used to load the runing env for remaining analysis (conda env "envCGR")
- cluster_config.yaml
  - define the cluser computing resources for the host job script
- pacbioSV.yaml
  - define the resources that will be used in snakemake

## Testing data
1. Bam file
  - /CGF/Bioinformatics/Production/Wen/20191120_pacbio_24320/bam_location_post
3. Reference
  - /DCEG/CGF/TempFileSwap/Kristie/References/GRCh38.p2.maimcontigs.fa
## How to run it
1. Command line
```
cd ./PacbioSV/SourceCode
qsub ./job.sh
```
2. Output
- /scratch/lix33/lxwg/Test/pacbio/06_04_2021/sv

