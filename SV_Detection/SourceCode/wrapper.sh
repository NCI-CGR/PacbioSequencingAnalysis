#!/bin/bash

# subshells do not inherit bash functions, so conda must be initialized again
. /etc/profile.d/modules.sh
module purge
module load sge
unset module

source /scratch/lix33/lxwg/software/conda/miniconda3/condabin/activate envCGR

# Check version in Wrapper 
echo 
echo "> Check Version number in Wrapper ->"
echo "1) Check Python3 -- "
python3 --version
echo "2) Check GCC -- "
gcc --version
echo "3) Check PBSV -- "
pbsv --version
echo

# Get argument
smClusterPara=$1

snakemake \
    --snakefile ./smCallSV.snake \
    --keep-going --local-cores 1 --jobs 100 \
    --rerun-incomplete --restart-times 1\
    --latency-wait 120 all \
    --cluster "${smClusterPara}"
