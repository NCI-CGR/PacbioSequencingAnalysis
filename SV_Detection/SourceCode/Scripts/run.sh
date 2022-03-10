#!/bin/bash

. /etc/profile.d/modules.sh

module load python3/3.7.0

python3 ./BenchmarkComparison.py
