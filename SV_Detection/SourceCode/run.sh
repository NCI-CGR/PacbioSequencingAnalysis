#!/bin/bash

. /etc/profile.d/modules.sh
module purge
module load sge
unset module

source /scratch/lix33/lxwg/software/conda/miniconda3/condabin/activate envCGR

# Clean output file content ->
logFile="../Log/test.out"
true > ${logFile}

# Record Time stemp
echo
echo "******************************"
date
echo "******************************"
echo

# Check version
echo "=========== Verify the version of some third-party tools in current conda envCGR ==========="
echo "Check Python3 -->"
python3 --version
echo "---"
echo "Check GCC -->"
gcc --version
echo "---"
echo "Check PBSV -->"
pbsv --version
echo "=========== Done ==========="
echo

# Run PacbioSV
python3 ./RunPacbioSV.py RunSnakemake