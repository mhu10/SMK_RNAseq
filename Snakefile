configfile: "config/config.yaml"

IDS, = glob_wildcards(config['INPUT_DIR']+'{id}_001.fastq.gz')                ###---  modify filename if needed
SAMPLES, = glob_wildcards(config['INPUT_DIR']+'{sample}_R1_001.fastq.gz')     ###---  modify filename if needed

rule all:
    input:
        directory('results/STARindex'),
        "results/STAR_buildindex.done",
        expand("results/fastqc/{id}.html", id=IDS),
        expand("results/fastqc/{id}_fastqc.zip", id=IDS),
        expand("results/trimmomatic/{sample}_R1_trimmed.fastq", sample=SAMPLES),
        expand("results/trimmomatic/{sample}_R2_trimmed.fastq", sample=SAMPLES),
        expand("results/trimmomatic/{sample}_R1_unpaired.fastq", sample=SAMPLES),
        expand("results/trimmomatic/{sample}_R2_unpaired.fastq", sample=SAMPLES),
        expand('results/STAR/output/{sample}_Aligned.sortedByCoord.out.bam',sample=SAMPLES),
        expand('results/STAR/output/{sample}_ReadsPerGene.out.tab',sample=SAMPLES),
        'results/STAR/ExpressionTable.txt',
        'results/DESEQ2/Table_DESEQ2.txt',
        'results/DESEQ2/FigPCA.png',
        'results/DESEQ2/FigVolcano.png'

rule fastqc:
    input:
        config['INPUT_DIR']+'{id}_001.fastq.gz',
    output:
        html="results/fastqc/{id}.html",
        zip="results/fastqc/{id}_fastqc.zip",


    params: "--quiet"
    log:
        "logs/fastqc/{id}.log"

    threads: 8
    wrapper:
        "v1.7.1/bio/fastqc"


rule trimmomatic_pe:
    input:
        r1=config['INPUT_DIR']+'{sample}_R1_001.fastq.gz',
        r2=config['INPUT_DIR']+'{sample}_R2_001.fastq.gz'
    output:
        r1="results/trimmomatic/{sample}_R1_trimmed.fastq",
        r2="results/trimmomatic/{sample}_R2_trimmed.fastq",
        r1_unpaired="results/trimmomatic/{sample}_R1_unpaired.fastq",
        r2_unpaired="results/trimmomatic/{sample}_R2_unpaired.fastq"
    log:
        "logs/trimmomatic/{sample}.log"
    params:
        # list of trimmers (see manual)
        trimmer=["ILLUMINACLIP:TruSeq3-PE.fa:2:30:10","LEADING:3","TRAILING:3","SLIDINGWINDOW:4:15","MINLEN:36"],
        # optional parameters
        extra="",
        compression_level="-9"
    threads:
        8
    resources:
        mem_mb=1024
    wrapper:
        "v1.7.1/bio/trimmomatic/pe"


rule STAR_buildindex:
    input:
        fa=config['FASTA'], # provide your reference FASTA file
        gtf=config['GTF'] # provide your GTF file
    output:
        outputdir=directory('results/STARindex'),
        output_tkn=touch("results/STAR_buildindex.done")

    threads: 8
    conda:
        'envs/STARmapping.yaml'
    shell:
        "mkdir -p {output.outputdir} && "
        'STAR --runThreadN {threads} '
        '--runMode genomeGenerate '
        '--genomeDir {output.outputdir} '
        '--genomeFastaFiles {input.fa} '
        '--sjdbGTFfile {input.gtf} '
        '--sjdbOverhang 50'


rule STAR_align:
    input:
        input_tkn = "results/STAR_buildindex.done",
        r1="results/trimmomatic/{sample}_R1_trimmed.fastq",
        r2="results/trimmomatic/{sample}_R2_trimmed.fastq",
    params:
        gtf=config['GTF'],
        starindex=config['WORK_DIR']+'results/STARindex/',
        outprefix='results/STAR/output/{sample}_'
    output:
        bam='results/STAR/output/{sample}_Aligned.sortedByCoord.out.bam',
        quatread='results/STAR/output/{sample}_ReadsPerGene.out.tab'
    threads: 8
    conda:
        'envs/STARmapping.yaml'
    shell:
        "STAR "
        "--runThreadN 12 "
        "--sjdbGTFfile {params.gtf} "
        "--genomeDir {params.starindex} "
        "--readFilesIn {input.r1} {input.r2} "
        "--outFileNamePrefix {params.outprefix} "
        "--outSAMattributes Standard "
        "--outSAMtype BAM SortedByCoordinate "
        "--outReadsUnmapped Fastx "
        "--quantMode TranscriptomeSAM GeneCounts "


rule r_CombineQuant:
    input:
        expand('results/STAR/output/{sample}_ReadsPerGene.out.tab',sample=SAMPLES)
    output:
        outfile='results/STAR/ExpressionTable.txt'
    params:
        outputpath = 'results/STAR/output/'
    conda:
        'envs/r_CombineQuant.yaml'
    script:
        "scripts/CombineExp.R"


rule r_DESEQ2:
    input:
        ExpTable='results/STAR/ExpressionTable.txt'
    output:
        deseq2output='results/DESEQ2/Table_DESEQ2.txt',
        plotPCA='results/DESEQ2/FigPCA.png',
        plotVolcano='results/DESEQ2/FigVolcano.png'
    params:
        outputpath = 'results/DESEQ2/'
    conda:
        'envs/r_DEG.yaml'
    script:
        "scripts/DESEQ2.R"
