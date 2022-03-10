#!/bin/sh
# properties = {"type": "single", "rule": "cuteSV_call", "local": false, "input": ["/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/ngmlr/v37/StdReads/StdReads.HG002.MD.sorted.bam"], "output": ["/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/SV/v37/cuteSV/ngmlr/StdReads/minSupport_10/StdReads.HG002.MD.sorted.10.cuteSV.vcf", "/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/SV/v37/cuteSV/ngmlr/StdReads/minSupport_10/Tmp/"], "wildcards": {"wcRefVersion": "v37", "wcAligner": "ngmlr", "wcReadsType": "StdReads", "wcMinSupportCuteSV": "10"}, "params": {"ms": "10", "ref": "/scratch/lix33/Data/Reference/v37/hg19_canonical+phiX.fa", "mcbINS": 1000, "drmINS": 0.9, "mcbDEL": 1000, "drmDEL": 0.5}, "log": ["/CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/SV/v37/cuteSV/ngmlr/StdReads/minSupport_10/Log/StdReads.HG002.MD.sorted.10.cuteSV.log"], "threads": 24, "resources": {}, "jobid": 13, "cluster": {}}
cd /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/BenchmarkTesting && \
/DCEG/Resources/Tools/python3/3.7.0-shared/bin/python3.7 \
-m snakemake /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/SV/v37/cuteSV/ngmlr/StdReads/minSupport_10/StdReads.HG002.MD.sorted.10.cuteSV.vcf --snakefile /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/BenchmarkTesting/BenchmarkTest.smk \
--force -j --keep-target-files --keep-remote \
--wait-for-files /scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/BenchmarkTesting/.snakemake/tmp.1bd233ey /CGF/Bioinformatics/Production/Wen/20200117_pacbio_snp_call/29461_WGS_cell_line/bam_bemchmark/ngmlr/v37/StdReads/StdReads.HG002.MD.sorted.bam --latency-wait 120 \
 --attempt 2 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
  -p --allowed-rules cuteSV_call --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/BenchmarkTesting/.snakemake/tmp.1bd233ey/13.jobfinished" || (touch "/scratch/lix33/lxwg/SourceCode/PacbioSV/SourceCode/DownstreamAnalysis/BenchmarkTesting/.snakemake/tmp.1bd233ey/13.jobfailed"; exit 1)

