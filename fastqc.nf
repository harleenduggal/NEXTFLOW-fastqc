	#!/usr/bin/env nextflow
params.reads = "/home/ubuntu/fastqc/SRR14609304_2.fastq"
params.outdir = "results"

log.info """\
 FASTQC-NF PIPELINE
 ===================================
 reads        : ${params.reads}
 outdir       : ${params.outdir}
 """


Channel
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .into { read_pairs_ch; read_pairs2_ch }

process fastqc {
    tag "FASTQC on $sample_id"
    publishDir params.outdir

    input:
    set sample_id, file(reads) from read_pairs2_ch

    output:
    file("fastqc_${sample_id}_logs") into fastqc_ch


    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs  -q ${reads}
    """
}

workflow.onComplete {
        println ( workflow.success ? "\nDone! --> $params.outdir/\n" : "Oops .. something went wrong" )
}
