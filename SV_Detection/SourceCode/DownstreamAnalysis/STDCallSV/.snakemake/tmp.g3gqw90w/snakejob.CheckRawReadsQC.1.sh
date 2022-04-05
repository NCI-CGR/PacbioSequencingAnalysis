#!/bin/sh
# properties = {"type": "single", "rule": "CheckRawReadsQC", "local": false, "input": ["/scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01"], "output": ["/scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01/Report/NanoPlot/NanoPlot-report.html"], "wildcards": {"wcBuildList": "/scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01"}, "params": {}, "log": ["/scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01/Log/NanoPlot/NanoPlot.log"], "threads": 8, "resources": {}, "jobid": 1, "cluster": {}}
cd /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/STDCallSV && \
/DCEG/Resources/Tools/python3/3.7.0-shared/bin/python3.7 \
-m snakemake /scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01/Report/NanoPlot/NanoPlot-report.html --snakefile /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/STDCallSV/smCallSV.smk \
--force -j --keep-target-files --keep-remote \
--wait-for-files /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/STDCallSV/.snakemake/tmp.g3gqw90w /scratch/lix33/Test/Pacbio/StdPipeline/Data/Build_readslist_2022-04-01 --latency-wait 120 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
  -p --allowed-rules CheckRawReadsQC --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/STDCallSV/.snakemake/tmp.g3gqw90w/1.jobfinished" || (touch "/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/STDCallSV/.snakemake/tmp.g3gqw90w/1.jobfailed"; exit 1)

