# SMK_RNAseq

This workflow performs an RNAseq data analysis from alignement(STAR aligner) to DEG analysis(DESEQ2)



![dag1](https://user-images.githubusercontent.com/38729968/233199238-f3843147-9f4f-4950-bc82-afb1622abadd.svg)

## Install Snakemake and Git

Please make sure that Git and Snakemake are correctly installed

Git: https://anaconda.org/anaconda/git
Snakemake: https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

## Clone workflow into your working directory

```
git clone https://github.com/mhu10/SMK_RNAseq path/to/workdir
```

## Modify filenames of your raw fastq files as needed
The format of your pair-end fastq files must be 

prefix_R1.fastq.gz

prefix_R2.fastq.gz

## Edit config file and Snakefile file as needed

./SMK_RNAseq/config/'config.yaml

./SMK_RNAseq/Snakefile

## Activate snakemake

```
conda activate snakemake
```

## Dry run workflow

```
snakemake -n
```

## Execute workflow

```
snakemake --use-conda --cores 12
```

## Build DAG workflow chart

```
snakemake --rulegraph | dot -Tsvg > dag1.svg
```

