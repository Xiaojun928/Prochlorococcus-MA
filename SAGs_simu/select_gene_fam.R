#!/usr/bin/R
args=commandArgs(T)
rnd <- as.numeric(args[1])
dir <- args[2]
orth_dir <- args[3]
outdir <- args[4]

setwd(orth_dir)
df <- read.table("Orthogroups.GeneCount.csv",sep="\t",header=T,row.names=1,check.names=F)

famid <- read.table("Orthogroups.csv",sep="\t",header=T,row.names=1,check.names=F)
##select gene families for Prochlo phylogenomic tree construction
s.df <- df[,-(dim(df)[2])]
setwd(dir)

##get the average completeness for each round
cmp <- read.table("simu_completeness_avg",sep="\t",row.names=1)[rnd,]
by.pre.abs <- function(x) {if(sum(x)>=(dim(s.df)[2]*cmp) && max(x)==1) x}  ## single-copy genes in >= XX% genomes
scp <- apply(s.df,1,by.pre.abs)
scp_core <- scp[-which(sapply(scp,is.null))]
scp_famid <- famid[names(scp_core),]
setwd(outdir)
write.table(scp_famid,file="selected_scp_famliy.txt",sep="\t",quote=F)


