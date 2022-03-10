#!/bin/bash

. /etc/profile.d/modules.sh
module purge

module load miniconda/4.8.3 sge

#. /home/lix33/.bashrc

#module load sge
#unset module
#source /scratch/lix33/lxwg/software/conda/miniconda3/condabin/activate envCGR
echo  "Start to run run.sh"
echo 

source /home/lix33/.conda/envs/envCGR/etc/profile.d/conda.sh
conda activate /home/lix33/.conda/envs/envCGR

module load python3/3.7.0 samtools/1.10

bash call_multi_ban_one_sample_pbsv.sh