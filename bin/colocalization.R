#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

qtl_path <- args[1]
gwas_path <- args[2]

# Run colocalization
library(coloc)

eqtl <- read.table(file=qtl_path, header=T, as.is=T); head(eqtl) 
gwas <- read.table(file=gwas_path, header=T, as.is=T); head(gwas)

eqtl$varbeta_eqtl <- eqtl$se^2
gwas$varbeta_gwas <- gwas$mtag_se^2

input <- merge(eqtl, gwas, by="SNP", all=FALSE, suffixes=c("_eqtl","gwas")); head(input)

dataset1=list(beta=input$mtag_beta, varbeta=input$varbeta_gwas, snp=input$SNP, position= input$BP, type="quant", N=nrow(gwas), MAF=input$FRQ)
dataset2=list(beta=input$b, varbeta=input$varbeta_eqtl, snp=input$SNP, position= input$BP, type="quant", N=nrow(eqtl), MAF=input$freq)

check_dataset(dataset1)

result <- coloc.abf(dataset1,dataset2)

arquivo <- tools::file_path_sans_ext(basename(qtl_path))
line = paste(arquivo, result[[1]][6], sep = "\t")
write(line,file=paste0(arquivo,"_coloc.txt"))

 