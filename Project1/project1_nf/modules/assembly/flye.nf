process FLYE {

    tag "$sample"
    publishDir "${params.outdir}/${sample}/flye_out", mode: 'copy', overwrite: true

    input:
      tuple val(sample), path(reads)

    output:
      path "assembly.fasta"
      path "*"

    script:
      """
      flye \
        --nano-raw "$reads" \
        --out-dir . \
        --threads 32
      """
}

