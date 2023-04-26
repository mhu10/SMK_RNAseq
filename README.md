# SMK_RNAseq

This workflow performs a RNAseq data analysis from alignement to DEG analysis



![dag1](https://user-images.githubusercontent.com/38729968/233199238-f3843147-9f4f-4950-bc82-afb1622abadd.svg)

## clone workflow into working directory
git clone https://github.com/mhu10/SMK_RNAseq path/to/workdir
cd path/to/workdir

## edit config and workflow as needed
vim config.yaml or your prefered text editor


## activate snakemake
conda activate snakemake

## dry run workflow
snakemake -n

## execute workflow
snakemake --use-conda --cores 12
