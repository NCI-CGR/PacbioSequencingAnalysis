#!/bin/bash

sniffles="/scratch/lix33/lxwg/software/sniffles/Sniffles-master/bin/sniffles-core-1.0.12/sniffles"
strRef="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/reference/human_GRCh38_no_alt_analysis_set.fasta"
coreNum="18"

echo "=============== Process low-input =============="
#For low input
strRoot="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples"
strBAM1=${strRoot}/Sample_low-14123/aligned/m64159_210812_110946.GRCh38.bam
strBAM2=${strRoot}/Sample_low-14535/aligned/m64159_210820_084120.GRCh38.bam
strBAM3=${strRoot}/Sample_low-14983/aligned/m64159_210824_221323.GRCh38.bam
strBAM4=${strRoot}/Sample_low-14990/aligned/m64159_210831_000858.GRCh38.bam


listBAM="${strBAM1} ${strBAM2} ${strBAM3} ${strBAM4}"
strOutputRoot="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples/Sample_low-sum1/aligned"
strOutputBAM="${strOutputRoot}/m64159_low_input.GRCh38.bam"

# # Run merge
# samtools merge -@ 32 -f ${strOutputBAM} ${listBAM}
# 
# # generate index 
# samtools index -@ 32 ${strOutputBAM}
# 
# # sort
OUT_TMP_PREFIX="low_input"
#strOutputSortedBAM="${strOutputRoot}/m64159_low_input.GRCh38.sorted.bam"
strOutputSortedBAM="${strOutputRoot}/m64159_111111_111111.GRCh38.bam"
# samtools sort -@ 32 -T ${OUT_TMP_PREFIX}_SM_renamed_sorted_temp -o ${strOutputSortedBAM} ${strOutputBAM}

#Build index for sorted BAM
#samtools index -@ 32 ${strOutputSortedBAM}

# Generate MD tag -> Go!
strOutputSortedBAMWithMDTag="${strOutputRoot}/m64159_111111_111111.GRCh38.MD.bam"
if [ ! -f ${strOutputSortedBAMWithMDTag} ]; then 
    CMD="samtools calmd -@ ${coreNum} ${strOutputSortedBAM} ${strRef} -b > ${strOutputSortedBAMWithMDTag}"
    SECONDS=0
    eval ${CMD}
    result=$?
    duration=$SECONDS
    echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
    echo ${strOutputSortedBAM}
    if [[ ${result} -ne 0 ]]; then
      echo "Error: $(date) samtools calmd (add MD tag) was failed!"
      exit 1
    else
      echo "$(date) samtools calmd (add MD tag) was finished successfully!"
    fi
 
    # Create index for this new BAM file
    samtools index -@ ${coreNum} ${strOutputSortedBAMWithMDTag}
fi

# Call SV
echo "Run sniffles ->"
strSVReport="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples/Sample_low-sum1/sniffle/output.vcf"
CMD="${sniffles} -t ${coreNum} -m ${strOutputSortedBAMWithMDTag} -v ${strSVReport}"

SECONDS=0
eval ${CMD}
result=$?
duration=$SECONDS
echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
echo ${strOutputSortedBAM}
if [[ ${result} -ne 0 ]]; then
  echo "Error: $(date) SV check was failed!"
  exit 1
else
  echo "$(date) SV was finished successfully!"
fi


echo
echo "=============== Process std-input =============="
#For std input
strBAM1=${strRoot}/Sample_std-14125/aligned/m64159_210813_220544.GRCh38.bam
strBAM2=${strRoot}/Sample_std-14665/aligned/m64159_210821_193722.GRCh38.bam
strBAM3=${strRoot}/Sample_std-14985/aligned/m64159_210826_090758.GRCh38.bam

listBAM="${strBAM1} ${strBAM2} ${strBAM3}"
strOutputRoot="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples/Sample_std-sum1/aligned"
strOutputBAM="${strOutputRoot}/m64159_std_input.GRCh38.bam"

# # Run merge
# samtools merge -@ 32 -f ${strOutputBAM} ${listBAM}
# 
# # generate index 
# samtools index -@ 32 ${strOutputBAM}
# 
# # sort
OUT_TMP_PREFIX="std_input"
#strOutputSortedBAM="${strOutputRoot}/m64159_std_input.GRCh38.sorted.bam"
strOutputSortedBAM="${strOutputRoot}/m64159_222222_222222.GRCh38.bam"
# samtools sort -@ 32 -T ${OUT_TMP_PREFIX}_SM_renamed_sorted_temp -o ${strOutputSortedBAM} ${strOutputBAM}

#Build index for sorted BAM
#samtools index -@ 32 ${strOutputSortedBAM}

# Generate MD tag -> Go!
strOutputSortedBAMWithMDTag="${strOutputRoot}/m64159_222222_222222.GRCh38.MD.bam"
if [ ! -f ${strOutputSortedBAMWithMDTag} ]; then
    CMD="samtools calmd -@ ${coreNum} ${strOutputSortedBAM} ${strRef} -b > ${strOutputSortedBAMWithMDTag}"
    SECONDS=0
    eval ${CMD}
    result=$?
    duration=$SECONDS
    echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
    echo ${strOutputSortedBAM}
    if [[ ${result} -ne 0 ]]; then
      echo "Error: $(date) samtools calmd (add MD tag) was failed!"
      exit 1
    else
      echo "$(date) samtools calmd (add MD tag) was finished successfully!"
    fi
    
    # Create index for this new BAM file
    samtools index -@ ${coreNum} ${strOutputSortedBAMWithMDTag}
fi

echo "Run sniffles ->"
strSVReport="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples/Sample_std-sum1/sniffle/output.vcf"
CMD="${sniffles} -t ${coreNum} -m ${strOutputSortedBAMWithMDTag} -v ${strSVReport}"

SECONDS=0
eval ${CMD}
result=$?
duration=$SECONDS
echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
echo ${strOutputSortedBAM}
if [[ ${result} -ne 0 ]]; then
  echo "Error: $(date) SV check was failed!"
  exit 1
else
  echo "$(date) SV was finished successfully!"
fi

echo "All Set!"
