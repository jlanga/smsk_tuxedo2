

import pandas as pd
import yaml

from snakemake.utils import min_version

min_version("5.0")

shell.prefix("set -euo pipefail;")

params = yaml.safe_load(open("params.yml", "r"))
features = yaml.safe_load(open("features.yml", "r"))
samples = pd.read_csv("samples.tsv", sep="\t")

singularity: "docker://continuumio/miniconda3:4.4.10"


shell.prefix("set -euo pipefail;")

SAMPLES_PE = samples[samples["type"] == "PE"]["sample"].tolist()

snakefiles = "src/snakefiles/"
include: snakefiles + "folders.py"
include: snakefiles + "clean.py"
include: snakefiles + "raw.py"
include: snakefiles + "map.py"
include: snakefiles + "quant.py"
include: snakefiles + "de.py"




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
