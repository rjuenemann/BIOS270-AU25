process MMSEQS2 {

    tag "$sample"
    publishDir "${params.outdir}/${sample}/mmseqs2_out", mode: 'copy', overwrite: true

    input:
        tuple val(sample), path(faaassembly)

    output:
        tuple val(sample), path(faaassembly), path("${sample}_prot90_cluster.tsv")

    script:
        """
        mmseqs easy-cluster ${faaassembly} ${sample}_prot90 tmp --min-seq-id 0.9 -c 0.8 --cov-mode 1 -s 7 --threads 32
        """
}
