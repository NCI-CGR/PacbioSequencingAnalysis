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

# Run PacbioSV
python3 ../../Scripts/RunPacbioSV.py RunSnakemake
