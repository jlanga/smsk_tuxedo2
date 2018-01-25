rule de_compose_phenotype_data:
    output:
        tsv=DE + "pheno_data.tsv"
    log:
        DE + "compose_pheno_data.log"
    benchmark:
        DE + "compose_pheno_data.benchmark"
    run:
        with open(output.tsv, "w") as f_out:
            print('"ids","sex","population"', file=f_out)
            for sample in SAMPLES_PE:
                sex = config["samples_pe"][sample]["sex"]
                population = config["samples_pe"][sample]["population"]
                print('"{sample}","{sex}","{population}"'.format(
                    sample=sample, sex=sex, population=population
                ),file=f_out)



rule de_ballgown:
    """Run Ballgown and get DE data"""
    input:
        expand(
            QUANT + "{sample}/{sample}_ballgown.gtf",
            sample=SAMPLES_PE
        ),
        DE + "pheno_data.tsv"
    output:
        DE + "chrX_transcript_results.csv",
        DE + "chrX_gene_results.csv",
        DE + "ballgown.RData"
    log:
        DE + "ballgown.log"
    benchmark:
        DE + "ballgown.benchmark"
    shell:
        "Rscript src/de_ballgown.R 2> {log} 1>&2"



rule de_visualize:
    """Visualize results as in Pertea et al. 2016"""
    input:
        DE + "ballgown.RData",
        DE + "pheno_data.tsv"
    output:
        DE + "fpkm_boxplot.pdf",
        DE + "NM_012227.pdf",
        DE + "xist.pdf",
        DE + "plotMeans.pdf"
    log:
        DE + "visualize.log"
    benchmark:
        DE + "visualize.benchmark"
    shell:
        "Rscript src/de_visualize.R 2> {log} 1>&2"
