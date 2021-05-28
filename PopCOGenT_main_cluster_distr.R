# Plot Fig. 2B using the output of PopCOGenT
# only one strain was kept in every clonal complex
dat <- read.table("PopCOGenT_mainclusters_w_chekM.txt",sep="\t",stringsAsFactors = F) # popcogent result: only one strain of highest quality was kept in the clonal complex
cl_all <- table(dat[,2])
df <- as.data.frame(cl_all)
table(df[,2])
dfh <- data.frame(y=as.numeric(table(df[,2])),x=as.numeric(names(table(df[,2]))))
present <- as.numeric(names(table(df[,2])))
absent <- setdiff(1:max(present),present)

space<-data.frame(y=rep(0,(max(present)-length(present))),x=absent) 
bar.df <- rbind(dfh,space)
df.b <- bar.df[order(as.numeric(bar.df$x)),]

library("ggplot2")
library("ggpubr")

df.b$x = factor(df.b$x, levels=as.character(1:64))   
p1 <- ggplot(df.b,aes(x=x,y=y)) + geom_bar(stat='identity',position=position_dodge()) +
  labs(x="#strains",y="#main clusters",fill=NULL)+	
  theme_classic() + 	
  coord_cartesian(ylim = c(0,20))	
p2 <- ggplot(df.b,aes(x=x,y=y)) + geom_bar(stat='identity',position=position_dodge()) +
  labs(x=NULL,y=NULL,fill=NULL) +	
  theme_classic2() +
  theme(axis.text.x = element_blank(),axis.ticks.x = element_blank())+ 
  coord_cartesian(ylim = c(195,225)) +  
  scale_y_continuous(breaks = c(195,225,5))	
p <- ggarrange(p2,p1,heights=c(1/5, 4/5),ncol = 1, nrow = 2,align = "v")

pdf(file="PopCOGenT_summary-wo_clonal.pdf",width = 12,height = 7)
p
dev.off()


