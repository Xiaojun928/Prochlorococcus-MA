# K means clustering for ds matrix with NA cells
devtools::install_github("o1iv3r/ClustImpute")
library(ClustImpute)
library(ggplot2)


# read the ds matrix from process at the below link
# https://github.com/luolab-cuhk/Thermococcus-mut-genome-size/tree/main/Relationship%20analysis/Pies_calculation
ds_mtx <- read.table("ds_mtx_M1.txt", as.is = T, header=T,check.names = F,
                     row.names = 1,na.strings = "-")
#ds_mtx_add <- rbind(ds_mtx,ds_mtx[61,])
nr_iter <- 10 # iterations of procedure
n_end <- 10 # step until convergence of weight function to 1
nr_cluster <- 2 # number of clusters
c_steps <- 50 # numer of cluster steps per iteration
res1 <- ClustImpute(ds_mtx,nr_cluster=nr_cluster, nr_iter=nr_iter, c_steps=c_steps, n_end=n_end) 
#res <- ClustImpute(ds_mtx_add,nr_cluster=nr_cluster, nr_iter=nr_iter, c_steps=c_steps, n_end=n_end) 

df <- ds_mtx#_add
df$cluster <- paste0('c', res1$clusters)
df1 <- cbind(df$cluster,df)
write.table(df1,file = "ds_mtx_M1_with-K2.txt",quote = F,sep="\t")



##Below are from the https://www.r-bloggers.com/2019/06/intoducing-clustimpute-a-new-approach-for-k-means-clustering-with-build-in-missing-data-imputation/
### Random Dataset
set.seed(739)
n <- 7500 # numer of points
nr_other_vars <- 4
mat <- matrix(rnorm(nr_other_vars*n),n,nr_other_vars)
me<-4 # mean
x <- c(rnorm(n/3,me/2,1),rnorm(2*n/3,-me/2,1)) 
y <- c(rnorm(n/3,0,1),rnorm(n/3,me,1),rnorm(n/3,-me,1))
true_clust <- c(rep(1,n/3),rep(2,n/3),rep(3,n/3)) # true clusters
dat <- cbind(mat,x,y)
dat<- as.data.frame(scale(dat)) # scaling


plot(dat$x,dat$y)


dat_with_miss <- miss_sim(dat,p=.975,seed_nr=120)
mis_ind <- is.na(dat_with_miss) # missing indicator
#corrplot(cor(mis_ind),method="number")

dat_with_miss1 <- miss_sim(ordered.dS,p=.975,seed_nr=120)
mis_ind1 <- is.na(dat_with_miss1)

nr_iter <- 10 # iterations of procedure
n_end <- 10 # step until convergence of weight function to 1
nr_cluster <- 2 # number of clusters
c_steps <- 50 # numer of cluster steps per iteration
#tic("Run ClustImpute")
res <- ClustImpute(dat_with_miss,nr_cluster=nr_cluster, nr_iter=nr_iter, c_steps=c_steps, n_end=n_end) 
#toc()

ggplot(res$complete_data,aes(x,y,color=factor(res$clusters))) + geom_point()
