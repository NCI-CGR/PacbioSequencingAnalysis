#!/bin/bash

#$ -N BenchmarkTest
#$ -q all.q
#$ -pe by_node 1
#$ -cwd
#$ -o ./Log/BenchmarkTesting.std.out
#$ -e ./Log/BenchmarkTesting.std.err
#$ -j y
#$ -S /bin/bash
#$ -M xin.li4@nih.gov
#$ -m aes

/bin/bash ./run.sh
