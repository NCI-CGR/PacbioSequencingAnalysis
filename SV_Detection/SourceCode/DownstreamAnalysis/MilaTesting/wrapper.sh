#!/bin/bash
set -o pipefail

# subshells do not inherit bash functions, so conda must be initialized again
#. /etc/profile.d/modules.sh
#. /home/lix33/.bashrc

#module purge
#module load miniconda/4.8.3
#module load sge
#unset module


#source /scratch/lix33/lxwg/software/conda/miniconda3/condabin/activate envCGR
#source /home/lix33/.conda/envs/envCGR/etc/profile.d/conda.sh
#conda activate /home/lix33/.conda/envs/envCGR

# Check version in Wrapper 
# echo 
# 
# echo "> Check Version number in Wrapper ->"
# echo "1) Check Python3 -- "
# python3 --version
# echo
# 
# echo "2) Check GCC -- "
# gcc --version
# echo
# 
# echo "3) Check PBSV -- "
# pbsv --version
# echo
# 
# echo "4) Check sniffles -- "
# echo
# sniffles 2> >(grep -i 'Version')
# 
# echo

echo "5) Check Snakemake version --"
which snakemake 
snakemake --version
echo


# Get argument
smClusterPara=$1
smkFile="./MilaTesting.smk" 

snakemake \
    --snakefile ${smkFile} \
    --keep-going --local-cores 1 --jobs 50 \
    --rerun-incomplete --restart-times 1\
    --latency-wait 120 all \
    --cluster "${smClusterPara}" \
    -np
#    -np
