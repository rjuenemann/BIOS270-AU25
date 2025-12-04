// FLYE -> 
// Expect a CSV with columns: sample,reads

nextflow.enable.dsl=2

include { FLYE } from './modules/assembly/flye.nf'

// -------------------- Channels --------------------
def samplesheet_ch = Channel
  .fromPath(params.samplesheet)
  .ifEmpty { error "Missing --samplesheet file: ${params.samplesheet}" }

samples_ch = samplesheet_ch.splitCsv(header:true).map { row ->
    tuple(row.sample.trim(), file(row.reads.trim(), absolute: true))
}


// -------------------- Workflow --------------------

workflow {
    FLYE(samples_ch)
}
workflow.onComplete {
    log.info "Pipeline finished. Results in: ${params.outdir}"
}
