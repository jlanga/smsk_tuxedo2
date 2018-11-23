rule de_install_r_packages:
    output:
        touch(DE + "packages_installed.txt")
    log:
        DE + "install_r_packages.log"
    benchmark:
        DE + "install_r_packages.time"
    conda:
        "de.yml"
    shell:
        """
        Rscript \
        -e 'BiocInstaller::biocLite("alyssafrazee/RSkittleBrewer")' \
        2> {log} 1>&2
        """


rule de_compose_phenotype_data:
    output:
        tsv=DE + "pheno_data.tsv"
    log:
        DE + "compose_pheno_data.log"
    benchmark:
        DE + "compose_pheno_data.benchmark"
    run:
        samples\
            [["sample", "sex", "population"]]\
            .rename(columns={"sample": "ids"})\
            .to_csv(
                path_or_buf=output.tsv,
                sep="\t",
                index=False
            )


rule de_ballgown:
    """Run Ballgown and get DE data"""
    input:
        expand(
            QUANT + "{sample}/{sample}_ballgown.gtf",
            sample=SAMPLES_PE
        ),
        DE + "pheno_data.tsv",
        DE + "packages_installed.txt"
    output:
        DE + "chrX_transcript_results.csv",
        DE + "chrX_gene_results.csv",
        DE + "ballgown.RData"
    log:
        DE + "ballgown.log"
    benchmark:
        DE + "ballgown.benchmark"
    conda:
        "de.yml"
    shell:
        "Rscript src/de_ballgown.R 2> {log} 1>&2"



rule de_visualize:
    """Visualize results as in Pertea et al. 2016"""
    input:
        DE + "ballgown.RData",
        DE + "pheno_data.tsv",
        DE + "packages_installed.txt"
    output:
        DE + "fpkm_boxplot.pdf",
        DE + "NM_012227.pdf",
        DE + "xist.pdf",
        DE + "plotMeans.pdf"
    log:
        DE + "visualize.log"
    benchmark:
        DE + "visualize.benchmark"
    conda:
        "de.yml"
    shell:
        "Rscript src/de_visualize.R 2> {log} 1>&2"
