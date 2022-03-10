#!/bin/bash -l

#$ -N test_pacbio
#$ -q bigmem.q
#$ -pe by_node 1
#$ -o ../../Log/test.out
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -M xin.li4@nih.gov
#$ -m aes

#All of outputs are in test.out (Both stdOut and stdErr)
/bin/bash ./run.sh
