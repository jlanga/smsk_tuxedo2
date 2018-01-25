# smsk_tuxedo2: snakemake files of the tuxedo v2 pipeline from Pertea et al 2016

[![Build Status](https://travis-ci.org/jlanga/smsk_tuxedo2.svg?branch=master)](https://travis-ci.org/jlanga/smsk_tuxedo2)



## 1. Description

This is a SnakeMake workflow to apply the protocol described in Pertea et al. 2016. With some
modifications.

The idea is to produce Differential Expression analysis given a bunch of FASTQ files,



## 2. First steps

Follow the contents of the `.travis.yml` file:

0. Install (ana|mini)conda

- [Anaconda](https://www.continuum.io/downloads)

- [miniconda](http://conda.pydata.org/miniconda.html)

1. Installation

    ```sh
    git clone https://github.com/jlanga/smsk_tuxedo2.git smsk_tuxedo2
    cd smsk_tuxedo2
    bash src/install/conda_env.sh
    ```

2. Activate the environment (`source deactivate` to deactivate):
    ```sh
    source activate smsk_tuxedo2
    ```

3. Execute the test pipeline:

    ```sh
    snakemake -j
    ```

4.  Modify the `src/config.yaml` with your samples, reference genome and GTF files.



## 3. File organization

The hierarchy of the folder is the one described in [Good enough practices in scientific computing](https://swcarpentry.github.io/good-enough-practices-in-scientific-computing/):

```
smsk
├── bin/: external scripts/binaries
├── data/: test data.
├── doc/: documentation.
├── README.md
├── results:
|   ├── raw: links to your raw data.
|   ├── map: files from HISAT2 mapping: index and CRAM files.
|   ├── quant: files from StringTie assembly and quantification
|   └── de: files from Ballgown: differential expression tables, RData objects for closer inspection.
├── Snakefile: driver script of the project.
├── environment.yml: packages to execute the analysis.
└── src: snakefiles, installers, config.yaml, R scripts.
```



## 4. Workflow description

### 4.1 Mapping with HISAT2 (`rule map`)

- Index is build from scratch

- Exons and splicing sites are computed from the reference GTF file

- Paired reads are mapped with HISAT2. Results are compressed to CRAM on the fly.

### 4.2 Transcript assembly and quantification with StringTie (`rule quant`)

- Using the exact parameters from Pertea et al. 2016

- CRAM -> SAM conversion on the fly

### 4.3 Differential expression analysis with Ballgown (`rule de`)

- Performing DE with the R script provided in `src/de_ballgown.R`

- Visualization should be done interactively.

![rulegraph](https://raw.github.com/jlanga/smsk_tuxedo2/master/rulegraph.svg?sanitize=true)



## Bibliography

- Transcript-level expression analysis of RNA-seq experiments with HISAT, StringTie and Ballgown. Pertea et al 2016

- The Sequence Alignment/Map format and SAMtools. Li et al.

- HISAT: a fast spliced aligner with low memory requirements. Kim et al.

- StringTie enables improved reconstruction of a transcriptome from RNA-seq reads. Pertea et al.

- Flexible isoform-level differential expression analysis with Ballgown. Frazee et al.

- RSkittleBrewer. Frazee et al. https://github.com/alyssafrazee/RSkittleBrewer

- SnakeMake - A scalable workflow engine. Köster et al.

- smsk - a snakemake skeleton to jumpstart your projects. Langa. http://github.com/jlanga/smsk
