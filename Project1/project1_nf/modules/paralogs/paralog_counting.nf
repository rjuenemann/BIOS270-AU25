process PARALOGS {

    tag "$sample"
    publishDir "${params.outdir}/${sample}/paralogs", mode: 'copy', overwrite: true

    input:
        tuple val(sample), path(assembly_faa), path(cluster_tsv)

    output:
        tuple val(sample), path("${sample}_paralog_copy_numbers.tsv"), path("${sample}_top_paralogs.png")

    script:
      """
      paralogs.py --assembly ${assembly_faa} --clusters ${cluster_tsv} --sample ${sample}
      """
}
