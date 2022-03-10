#!/bin/bash

. /etc/profile.d/modules.sh; module load miniconda/3
unset module

mkdir -p Logs

qsub -V -cwd -S /bin/bash -j y -o Logs wrapper.sh

