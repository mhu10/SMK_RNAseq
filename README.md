# SMK_RNAseq

This workflow performs an RNAseq data analysis from alignement(STAR aligner) to DEG analysis(DESEQ2)



![dag1](https://user-images.githubusercontent.com/38729968/233199238-f3843147-9f4f-4950-bc82-afb1622abadd.svg)

## install Snakemake and Git

Please make sure that Snakemake and Git are correctly installed

Snakemake: https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

Git: https://anaconda.org/anaconda/git

## clone workflow into your working directory
git clone https://github.com/mhu10/SMK_RNAseq path/to/workdir


## edit config.yaml and workflow as needed
vim config.yaml or your prefered text editor

## activate snakemake
conda activate snakemake

## dry run workflow
snakemake -n

## execute workflow
snakemake --use-conda --cores 12
