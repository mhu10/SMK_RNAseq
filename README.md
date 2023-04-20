# SMK_RNAseq

This workflow performs a RNAseq data analysis from alignement to DEG analysis



![dag1](https://user-images.githubusercontent.com/38729968/233199238-f3843147-9f4f-4950-bc82-afb1622abadd.svg)

## clone workflow into working directory
git clone https://bitbucket.org/user/myworkflow.git path/to/workdir
cd path/to/workdir

## edit config and workflow as needed
vim config.yaml

## install dependencies into isolated environment
conda env create -n myworkflow --file environment.yaml

## activate environment
source activate myworkflow

## execute workflow
snakemake -n
