#!/bin/bash -l

#$ -N test_pacbio
#$ -q long.q
#$ -pe by_node 1
#$ -o ../../../Log/STDCallSV.std.out
#$ -e ../../../Log/STDCallSV.std.err
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -M xin.li4@nih.gov
#$ -m aes

#All of outputs are in test.out (Both stdOut and stdErr)
/bin/bash ./run.sh
