#!/bin/bash -l

#$ -N pacbio_all
#$ -q seq-calling.q
#$ -pe by_node 1
#$ -o ../../../Log/BenchmarkTest.std.out
#$ -e ../../../Log/BenchmarkTest.std.err
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -M xin.li4@nih.gov
#$ -m aes

#All of outputs are in test.out (Both stdOut and stdErr)
/bin/bash ./run.sh
