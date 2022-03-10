#!/bin/bash -l

#$ -N MilaTesting
#$ -q long.q
#$ -pe by_node 1
#$ -o ../../../Log/MilaTest.std.out
#$ -e ../../../Log/MilaTest.std.err
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -M xin.li4@nih.gov
#$ -m aes

#All of outputs are in test.out (Both stdOut and stdErr)
/bin/bash ./run.sh