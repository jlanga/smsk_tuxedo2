rule map_extract_splice_sites:
    """Get splice sites from GTF"""
    input:
        genes = RAW + "reference.gtf"
    output:
        splice_sites = MAP + "splice_sites.tsv"
    shell:
        "hisat2_extract_splice_sites.py {input} > {output}"



rule map_extract_exons:
    """Get exon sites from GTF"""
    input:
        genes = RAW + "reference.gtf"
    output:
        splice_sites = MAP + "exons.tsv"
    shell:
        "hisat2_extract_exons.py {input} > {output}"



rule map_hisat2_build:
    """Build HISAT2 index"""
    input:
        fa = RAW + "reference.fa",
        splice_sites = MAP + "splice_sites.tsv",
        exons = MAP + "exons.tsv"
    output:
        suffixes=protected(expand(
            MAP + "reference.{extension}.ht2",
            extension="1 2 3 4 5 6 7 8".split()
        )),
        mock=protected(touch(MAP + "reference"))
    params:
        prefix = MAP + "reference"
    threads:
        1000
    log:
        MAP + "hisat2_build.log"
    benchmark:
        MAP + "hisat2_build.benchmark"
    shell:
        "hisat2-build "
            "-p {threads} "
            "--ss {input.splice_sites} "
            "--exon {input.exons} "
            "{input.fa} "
            "{params.prefix} "
        "2> {log}"



rule map_hisat2_align:
    """Map reads with hisat2 and convert to bam on the fly"""
    input:
        index_prefix= MAP + "reference",
        index_files=expand(
            MAP + "reference.{extension}.ht2",
            extension="1 2 3 4 5 6 7 8".split()
        ),
        forward=RAW + "{sample}_1.fq.gz",
        reverse=RAW + "{sample}_2.fq.gz"
    output:
        bam = temp(MAP + "{sample}.bam")
    threads:
        1000
    log:
        MAP + "hisat2_align_{sample}.log"
    benchmark:
        MAP + "hisat2_align_{sample}.benchmark"
    shell:
        "(hisat2 "
            "--threads {threads} "
            "--dta "
            "-x {input.index_prefix} "
            "-1 {input.forward} "
            "-2 {input.reverse} "
            "-S /dev/stdout "
        "| samtools view "
            "-Shu "
            "/dev/stdin "
        "| samtools sort "
            "-@ {threads} "
            "-f - "
            "{output.bam}) "
        "2> {log}"
