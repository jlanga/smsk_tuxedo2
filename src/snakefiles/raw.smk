def get_reads(wildcards):
    sample = wildcards.sample
    forward, reverse = (
        samples
        [(samples["sample"] == sample)]
        [["forward", "reverse"]]
        .values
        .tolist()[0]
    )
    return forward, reverse


rule raw_make_links_pe:
    """Make a link to the original file, with a prettier name than default"""
    input:
        get_reads
    output:
        fwd = RAW + "{sample}_1.fq.gz",
        rev = RAW + "{sample}_2.fq.gz"
    shell:
        """
        ln --symbolic $(readlink --canonicalize {input[0]}) {output.fwd}
        ln --symbolic $(readlink --canonicalize {input[1]}) {output.rev}
        """


rule raw_link_reference_fasta:
    """Link reference genome to results/raw/genome.fa"""
    input:
        fa = features["reference"]["fasta"]
    output:
        fa = RAW + "reference.fa"
    shell:
        "ln --symbolic $(readlink  --canonicalize {input.fa}) {output.fa}"



rule raw_link_reference_gtf:
    """Link reference GTF file"""
    input:
        gtf = features["reference"]["gtf"]
    output:
        gtf = RAW + "reference.gtf"
    shell:
        "ln --symbolic $(readlink  --canonicalize {input.gtf}) {output.gtf}"
