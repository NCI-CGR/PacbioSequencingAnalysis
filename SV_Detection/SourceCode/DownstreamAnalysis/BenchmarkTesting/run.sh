#!/bin/bash

. /etc/profile.d/modules.sh
module purge

module load miniconda/4.8.3 sge

#. /home/lix33/.bashrc

#module load sge
#unset module
#source /scratch/lix33/lxwg/software/conda/miniconda3/condabin/activate envCGR

source /home/lix33/.conda/envs/envCGR/etc/profile.d/conda.sh
conda activate /home/lix33/.conda/envs/envCGR

module load python3/3.8.12 samtools/1.10 tabix/1.9 bgzip/0.2.6 gcc/7.2.0

# Clean output file content ->
#logFile="../../../Log/BM.out"
#true > ${logFile}

# Record Time stemp
echo
echo "******************************"
date
echo "******************************"
echo

# # Check version
# echo "=========== Verify the version of some third-party tools in current conda envCGR ==========="
# echo "Check Python3 -->"
# python3 --version
# echo "---"
# 
# echo "Check GCC -->"
# gcc --version
# echo "---"
# 
# echo "Check PBSV -->"
# pbsv --version
# echo "---"
# 
# echo "Check sniffle -->"
# sniffles 2> >(grep -i 'Version')
# echo "---"
# 
# echo "4) Check Snakemake version --"
# which snakemake 
# snakemake --version
# echo
# 
# echo "=========== Done ==========="
# echo

#exit

# Run PacbioSV
python3 ../../Scripts/RunPacbioSV.py RunSnakemake
