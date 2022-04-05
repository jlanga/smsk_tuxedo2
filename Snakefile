

import pandas as pd
import yaml

from snakemake.utils import min_version

min_version("5.0")

shell.prefix("set -euo pipefail;")

params = yaml.load(open("params.yml", "r"), Loader=yaml.FullLoader)
features = yaml.load(open("features.yml", "r"), Loader=yaml.FullLoader)
samples = pd.read_table("samples.tsv")

singularity: "docker://continuumio/miniconda3:4.4.10"


shell.prefix("set -euo pipefail;")

SAMPLES_PE = samples[samples["type"] == "PE"]["sample"].tolist()

snakefiles = "src/snakefiles/"
include: snakefiles + "folders.smk"
include: snakefiles + "clean.smk"
include: snakefiles + "raw.smk"
include: snakefiles + "map.smk"
include: snakefiles + "quant.smk"
include: snakefiles + "de.smk"




rule all:
    input:
        # RAW
        # RAW + "reference.fa",
        # RAW + "reference.gtf",
        # expand(
        #     RAW + "{sample}_{end}.fq.gz",
        #     sample = SAMPLES_PE,
        #     end = "1 2".split()
        # ),
        # MAP
        # MAP + "splice_sites.tsv",
        # MAP + "exons.tsv",
        # MAP + "reference",
        # expand(
        #     MAP + "{sample}.cram",
        #     sample=SAMPLES_PE
        # ),
        # QUANT
        # expand(
        #     QUANT + "{sample}/{sample}.gtf",
        #     sample=SAMPLES_PE
        # ),
        # QUANT + "merged.gtf",
        # expand(
        #     QUANT + "merged.{extension}",
        #     extension="annotated.gtf loci merged.gtf.refmap merged.gtf.tmap stats tracking".split()
        # ),
        # expand(
        #     QUANT + "{sample}/{sample}_ballgown.gtf",
        #     sample=SAMPLES_PE
        # ),
        # DE
        # DE + "pheno_data.tsv",
        DE + "chrX_transcript_results.csv",
        DE + "chrX_gene_results.csv",
        DE + "ballgown.RData",
        # DE + "fpkm_boxplot.pdf",
        # DE + "NM_012227.pdf",
        # DE + "xist.pdf",
        # DE + "plotMeans.pdf"



rule map:
    """Build index and map"""
    input:
        expand(
            MAP + "{sample}.cram",
            sample=SAMPLES_PE
        )


rule quant:
    """Assemble and quantify"""
    input:
        expand(
            QUANT + "{sample}/{sample}_ballgown.gtf",
            sample=SAMPLES_PE
        )



rule de:
    """Perform differential expression analysis"""
    input:
        DE + "ballgown.RData"
