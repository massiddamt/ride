
rule multiqc:
    input:
         expand("qc/fastqc/untrimmed_{sample.sample}.html", sample=samples.reset_index().itertuples()),
         expand("qc/fastqc/trimmed_{sample.sample}.html", sample=samples.reset_index().itertuples()),
         # expand("qc/fastqcscreen/trimmed_{sample.sample}.fastq_screen.txt", sample=samples.reset_index().itertuples()),
         expand("reads/trimmed/{sample.sample}-R1.fq.gz_trimming_report.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.bam_stat.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.geneBodyCoverage.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.junction.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.junctionSaturation_plot.r", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.GC.xls", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.read_distribution.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.infer_experiment.txt", sample=samples.reset_index().itertuples()),
         expand("rseqc/{sample.sample}/{sample.sample}.pos.DupRate.xls", sample=samples.reset_index().itertuples()),
         expand("star/{sample.sample}/{sample.sample}.Log.final.out", sample=samples.reset_index().itertuples()),
         expand("logs/kallisto/{sample.sample}.kallisto_quant.log", sample=samples.reset_index().itertuples())
    output:
        "qc/multiqc.html"
    params:
        params=config.get("rules").get("multiqc").get("arguments"),
        outdir="qc",
        outname="multiqc.html"
    conda:
        "../envs/multiqc.yaml"
    log:
        "logs/multiqc/multiqc.log"
    shell:
        "multiqc "
        "{input} "
        "{params.params} "
        "-o {params.outdir} "
        "-n {params.outname} "
        ">& {log}"

rule fastqc:
    input:
       "reads/untrimmed/{sample}-R1.fq.gz"
    output:
        html="qc/fastqc/untrimmed_{sample}.html",
        zip="qc/fastqc/untrimmed_{sample}_fastqc.zip"
    log:
        "logs/fastqc/untrimmed/{sample}.log"
    params: ""
    wrapper:
        config.get("wrappers").get("fastqc")

rule fastqc_trimmed:
    input:
       "reads/trimmed/{sample}-R1-trimmed.fq.gz"
    output:
        html="qc/fastqc/trimmed_{sample}.html",
        zip="qc/fastqc/trimmed_{sample}_fastqc.zip"
    log:
        "logs/fastqc/trimmed/{sample}.log"
    params: ""
    wrapper:
        config.get("wrappers").get("fastqc")


# rule fastq_screen:
#     input:
#         "reads/trimmed/{sample}-R1-trimmed.fq.gz"
#     output:
#         png="qc/fastqscreen/trimmed_{sample}.fastq_screen.png",
#         txt="qc/fastqscreen/trimmed_{sample}.fastq_screen.txt",
#         html="qc/fastqscreen/trimmed_{sample}.fastq_screen.html",
#         filtered_fastq="qc/fastqscreen/trimmed_{sample}.fastq_screen.filtered.fastq"
#     conda:
#         "../envs/fastq_screen.yaml"
#     params:
#         params=config.get("rules").get("fastq_screen").get("params"),
#         config_file=config.get("rules").get("fastq_screen").get("config_file"),
#         prefix=lambda wildcards: wildcards.sample
#     threads: pipeline_cpu_count()
#     shell:
#         "fastq_screen  "
#         "{params.params} "
#         "--conf {params.config_file} "
#         "--threads {threads} "
#         "{input[0]} "
#         "&& find ./ -name {params.prefix}*_screen.txt -type f -print0 | xargs -0 -I file mv " \
#         "file {output.txt} ;"
#         "find ./ -name {params.prefix}*_screen.png -type f -print0 | xargs -0 -I file mv " \
#         "file {output.png} ;"
#         "find ./ -name {params.prefix}*_screen.html -type f -print0 | xargs -0 -I file mv " \
#         "file {output.html} ;"
#         "find ./ -name {params.prefix}*.tagged_filter.fastq -type f -print0 | xargs -0 -I file mv " \
#         "file {output.filtered_fastq} "
#
#
