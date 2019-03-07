rule HTSeq_run:
    input:
        "star/{sample}/Aligned.sortedByCoord.out.bam"
    output:
        "star/{sample}/count/{sample}_counts.cnt"
    conda:
        "../envs/htseq.yaml"
    log:
        "logs/star/{sample}/{sample}_htseq_count.log"
    params:
         gtf=resolve_single_filepath(*references_abs_path(),
                                    config.get("genes_gtf")),
         strand=config['strand'],
    shell:
         "htseq-count "
         "-m intersection-nonempty "
         "--stranded={params.strand} "
         "--idattr gene_id "
         "-r pos "
         "-f bam "
         "{input} {params.gtf} > {output} 2> {log}"
