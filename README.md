# SMK_RNAseq

This workflow performs a RNAseq data analysis from alignement to DEG analysis



![dag1](https://user-images.githubusercontent.com/38729968/233199238-f3843147-9f4f-4950-bc82-afb1622abadd.svg)


## Workflow structure

  |── .gitignore
  |── README.md
  ├── LICENSE.md
  ├── workflow
  │   ├── rules
  |   │   ├── module1.smk
  |   │   └── module2.smk
  │   ├── envs
  |   │   ├── tool1.yaml
  |   │   └── tool2.yaml
  │   ├── scripts
  |   │   ├── script1.py
  |   │   └── script2.R
  │   ├── notebooks
  |   │   ├── notebook1.py.ipynb
  |   │   └── notebook2.r.ipynb
  │   ├── report
  |   │   ├── plot1.rst
  |   │   └── plot2.rst
  |   └── Snakefile
  ├── config
  │   ├── config.yaml
  │   └── some-sheet.tsv
  ├── results
  └── resources
