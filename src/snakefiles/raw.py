rule raw_make_links_pe_sample:
    """Make a link to the original file, with a prettier name than default"""
    input:
        forward= lambda wildcards: config["samples_pe"][wildcards.sample]["forward"],
        reverse= lambda wildcards: config["samples_pe"][wildcards.sample]["reverse"]
    output:
        forward= RAW + "{sample}_1.fq.gz",
        reverse= RAW + "{sample}_2.fq.gz"
    shell:
        "ln --symbolic $(readlink --canonicalize {input.forward}) {output.forward}; "
        "ln --symbolic $(readlink --canonicalize {input.reverse}) {output.reverse}"


rule raw_link_reference_fasta:
    """Link reference genome to results/raw/genome.fa"""
    input:
        fa = config["reference"]["fasta"]
    output:
        fa = RAW + "reference.fa"
    shell:
        "ln --symbolic $(readlink  --canonicalize {input.fa}) {output.fa}"



rule raw_link_reference_gtf:
    """Link reference GTF file"""
    input:
        gtf = config["reference"]["gtf"]
    output:
        gtf = RAW + "reference.gtf"
    shell:
        "ln --symbolic $(readlink  --canonicalize {input.gtf}) {output.gtf}"
