process BAKTA {

    tag "$sample"
    publishDir "${params.outdir}/${sample}/bakta_out", mode: 'copy', overwrite: true

    input:
        tuple val(sample), path(assembly)

    output:
        path "*"

    script:
        """
        bakta \
            --db /farmshare/home/classes/bios/270/data/archive/bakta_db/db \
            --output . \
            --force \
            ${assembly}
        """
}
