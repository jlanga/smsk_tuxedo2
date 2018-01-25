rule quant_stringtie:
    """assemble transcripts with stringtie"""
    input:
        bam = MAP + "{sample}.bam",
        gtf = RAW + "reference.gtf"
    output:
        gtf = QUANT + "{sample}/{sample}.gtf"
    threads:
        1000
    params:
        label = "{sample}"
    log:
        QUANT + "{sample}/stringtie_{sample}.log"
    benchmark:
        QUANT + "{sample}/stringtie_{sample}.benchmark"
    shell:
        "stringtie "
            "-p {threads} "
            "-G {input.gtf} "
            "-o {output.gtf} "
            "-l {params.label} "
            "{input.bam} "
        "2> {log}"



rule quant_stringtie_merge:
    """merge assembled transcripts with stringtie"""
    input:
        ref_gtf = RAW + "reference.gtf",
        samples_gtf = expand(
            QUANT + "{sample}/{sample}.gtf",
            sample=SAMPLES_PE
        )
    output:
        gtf = QUANT + "merged.gtf"
    threads:
        10000
    log:
        QUANT + "stringtie_merge.log"
    benchmark:
        QUANT + "stringtie_merge.benchmark"
    shell:
        "stringtie "
            "--merge "
            "-p {threads} "
            "-G {input.ref_gtf} "
            "-o {output.gtf} "
            "{input.samples_gtf} "
        "2> {log}"



rule quant_gffcompare:
    """Compare merged assembled transcripts to the ones in the reference"""
    input:
        ref_gtf=RAW + "reference.gtf",
        merged_gtf=QUANT + "merged.gtf"
    output:
        expand(
            QUANT + "merged.{extension}",
            extension="annotated.gtf loci merged.gtf.refmap merged.gtf.tmap stats tracking".split()
        )
    params:
        prefix=QUANT + "merged"
    log:
        QUANT + "gffcompare.log"
    benchmark:
        QUANT + "gffcompare.benchmark"
    shell:
        "gffcompare "
            "-r {input.ref_gtf} "
            "-G "
            "-o {params.prefix} "
            "{input.merged_gtf} "
        "2> {log}"


rule quant_stringtie_quant:
    """Quantify abundances with StringTie"""
    input:
        merged_gtf = QUANT + "merged.gtf",
        sample_bam = MAP + "{sample}.bam"
    output:
        ballgown_gtf = QUANT + "{sample}/{sample}_ballgown.gtf"
    threads:
        1000
    log:
        QUANT + "{sample}/stringtie_quant_{sample}.log"
    benchmark:
        QUANT + "{sample}/stringtie_quant_{sample}.benchmark"
    shell:
        "stringtie -e -B "
            "-e "
            "-B "
            "-p {threads} "
            "-G {input.merged_gtf} "
            "-o {output.ballgown_gtf} "
            "{input.sample_bam} "
        "2> {log}"
