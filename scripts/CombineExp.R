samples <- snakemake@input
out_file <- snakemake@output[["outfile"]]
dirpath <- snakemake@params[['outputpath']]


data <- lapply(samples, function(s){
    sname <- strsplit(s, dirpath)[[1]][2]
    sname <- strsplit(sname, "_ReadsPerGene.out.tab")[[1]][1]
    sample_data <- read.table(s, sep="\t", row.names='V1')
    colnames(sample_data) <- rep(sname,3)
    return(sample_data)
})

data <- do.call(cbind, data)
data <- data[,seq(3,length(colnames(data)),3)]

write.table(data, out_file, sep="\t")
