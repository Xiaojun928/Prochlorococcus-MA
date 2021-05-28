#!/usr/bin/R
df <- read.table("Orthogroups.GeneCount.csv",sep="\t",header=T,row.names=1,check.names=F)
famid <- read.table("Orthogroups.csv",sep="\t",header=T,row.names=1,check.names=F)
##select gene families for Prochlo phylogenomic tree construction
by.pre.abs <- function(x) {if(sum(x)>=(dim(s.df)[2]*0.75) && max(x)==1) x}  ## single-copy genes in >= XX% genomes
s.df <- df[,-544]
scp <- apply(s.df,1,by.pre.abs)
scp_core <- scp[-which(sapply(scp,is.null))]
scp_famid <- famid[names(scp_core),]
write.table(scp_famid,file="selected_scp_famliy_75presence.txt",sep="\t",quote=F)


#This part used for the Pies estimation in main clusters identified by PopCOGenT
#select core gene families for main clusters with more than 3 strains after keeping one strain in clonal complexes (if any)
dat <- read.table("../PopCOGenT_mainclusters_w_chekM.txt",sep="\t",stringsAsFactors = F) # popcogent result: only one strain of highest quality was kept in the clonal complex
cl_all <- table(dat[,2])

#get the populations with > 3 strains
main.cluster.all <- names(cl_all[which(cl_all>=3)])
all <- dat[which(dat[,2] %in% main.cluster.all),]

setwd("/home-user/xjwang/Prochlorococcus_MA/Ne_calculation/Prochlorococcus/00_seq_folder/Results_01_blast_folder_Dec18")
for (i in main.cluster.all) {

  gnm <- all[which(all[,2] == i),1]  
  s.df <- df[,gnm]
  # get the average completeness of strains in each main cluster, which can be used to determine the propotion of presence
  prop <- mean(all[which(all[,1] %in% gnm),4])
  by.pre.abs <- function(x) {if(sum(x)>=(dim(s.df)[2]*prop/100) && max(x)==1) x}  ## single-copy genes in >= XX% genomes
  scp <- apply(s.df,1,by.pre.abs)
  scp_core <- scp[-which(sapply(scp,is.null))]
  scp_famid <- famid[names(scp_core),gnm]
  filename <- paste("selected_scp","mclst",i,sep="_")
  write.table(scp_famid,file=filename,sep="\t",quote=F)
}





