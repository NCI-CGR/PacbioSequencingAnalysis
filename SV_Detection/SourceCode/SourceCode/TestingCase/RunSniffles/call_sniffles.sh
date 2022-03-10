#!/bin/bash

strSampleName=$1
strBAM=$2
strResultDir=$3
coreNum=$4

# Init Runing ENV
. /etc/profile.d/modules.sh
module purge
module load miniconda/4.8.3 sge

source /home/lix33/.conda/envs/envCGR/etc/profile.d/conda.sh
conda activate /home/lix33/.conda/envs/envCGR

module load python3/3.7.0 samtools/1.10



sniffles="/scratch/lix33/lxwg/software/sniffles/Sniffles-master/bin/sniffles-core-1.0.12/sniffles"
strRef="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/reference/human_GRCh38_no_alt_analysis_set.fasta"
#coreNum="18"

echo "=============== Process ${strSampleName} =============="
echo
strRoot="/scratch/lix33/lxwg/Project/Pacbio/pb-human-wgs-workflow-snakemake/Git/pb-human-wgs-workflow-snakemake/samples"

# # Run merge
# samtools merge -@ 32 -f ${strOutputBAM} ${listBAM}
# 
# # generate index 
# samtools index -@ 32 ${strOutputBAM}
# 

# sort
echo "Sort Sample ${strSampleName}"
strSortBAMDir=${strResultDir}/SortedBAM
mkdir -p ${strSortBAMDir}

strSortedBAM=${strSortBAMDir}/${strSampleName}.sorted.bam

if [ ! -f ${strSortedBAM} ]; then
    # sort BAM
    samtools sort -@ ${coreNum} -o ${strSortedBAM} ${strBAM}

    # Build index for sorted BAM
    samtools index -@ ${coreNum} ${strSortedBAM}
fi

# # Generate MD tag -> Go!
# strOutputSortedBAMWithMDTag="${strOutputRoot}/m64159_111111_111111.GRCh38.MD.bam"
# if [ ! -f ${strOutputSortedBAMWithMDTag} ]; then 
#     CMD="samtools calmd -@ ${coreNum} ${strOutputSortedBAM} ${strRef} -b > ${strOutputSortedBAMWithMDTag}"
#     SECONDS=0
#     eval ${CMD}
#     result=$?
#     duration=$SECONDS
#     echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
#     echo ${strOutputSortedBAM}
#     if [[ ${result} -ne 0 ]]; then
#       echo "Error: $(date) samtools calmd (add MD tag) was failed!"
#       exit 1
#     else
#       echo "$(date) samtools calmd (add MD tag) was finished successfully!"
#     fi
#  
#     # Create index for this new BAM file
#     samtools index -@ ${coreNum} ${strOutputSortedBAMWithMDTag}
# fi

# Call SV
echo "Run sniffles ->"
strSVReport="${strResultDir}/${strSampleName}.sv.sniffles.vcf"
CMD="${sniffles} -t ${coreNum} -m ${strSortedBAM} -v ${strSVReport}"

SECONDS=0
eval ${CMD}
result=$?
duration=$SECONDS
echo "Running Time: $(($duration / 3600))hrs $((($duration / 60) % 60))min $(($duration % 60))sec"
echo ${strSortedBAM}
if [[ ${result} -ne 0 ]]; then
  echo "Error: $(date) ${strSampleName} SV check was failed!"
  exit 1
else
  echo "$(date) ${strSampleName} SV was finished successfully!"
fi
