#' Mandatory: Reaver Hyperspace
#'
#' @description Optional: performs ordination and cluster analysis to get information from a n-dimensional Hyperspace
#' prints nmds and dca ordiantions with Hierarchical Clustering and K-Means Clustering
#' @name Mandatory Reaver 
#' @export Mandatory Reaver

#' @param Mandatory if function: df - a data.frame with sites in rows and parameters in columns with numeric values.
#' @param Mandatory if function: cl - desired n-count of clusters

#note: v1 returns cluster

#dev
cl=3

Reaver_hyperspace <-function(df,cl){
  cat(" ",sep = "\n")
  cat("### Reaver starts to reduce the ",nrow(df),"-dimensional Hyperspace ###")
  cat(" ",sep = "\n")
  #ordinations
  #dca
  dca<-decorana(df)
  #nmds
  nmds<-metaMDS(df)
  #clusters#########################################################################################
  #bray ward
  vdist <- vegdist(df, method = "bray", binary = FALSE)
  cluster <- hclust(vdist, method = "ward.D")
  cutclust <- cutree(cluster, k=cl)
  #kmeans clustering
  km_cl <- kmeans(df,centers=cl,nstart=20)
  #plot
  par(mfrow=c(2,2))
  
  #plot with hc nmds
  sc<-scores(nmds)
  ordiplot(nmds,type="n",main="hc_nmds")
  orditorp(nmds,display="sites",cex=1,air=0.01)
  points(sc[,1],sc[,2],cex=2,pch=20,col=cutclust)
  ordihull(nmds, cutclust, lty=2, col="blue")
  
  #plot with km nmds 
  ordiplot(nmds,type="n",main="km_nmds")
  orditorp(nmds,display="sites",cex=1,air=0.01)
  ordihull(nmds, km_cl$cluster, lty=3, col="grey60",lwd=2)
  points(sc[,1],sc[,2],cex=2,pch=20,col=km_cl$cluster)

  #plot with hc dca points
  scd<-scores(dca)
  plot(dca,display="sites",type="n", main="hc_dca")
  orditorp(dca,display="sites",cex=1,air=0.01)
  points(scd[,1],scd[,2],cex=2,pch=20,col=cutclust)
  ordihull(dca, cutclust, lty=2, col="blue")
  
  #plot with km dca points
  plot(dca,display="sites",type="n", main="km_dca")
  orditorp(dca,display="sites",cex=1,air=0.01)
  points(scd[,1],scd[,2],cex=2,pch=20,col=km_cl$cluster)
  ordihull(dca, km_cl$cluster, lty=3, col="grey60",lwd=2)
  
  if ("condition")
  
  #indicator for hc
  const_hc <-const(df, cutclust)
  import_hc <-importance(df, cutclust,show=NA)
  hc_ival <- indval(df, cutclust)
  
  const_km <-const(df, km_cl$cluster)
  import_km <-importance(df,km_cl$cluster,show=NA)
  km_ival <- indval(df, km_cl$cluster) # summarys indicator
#####################################################################

  #return data

  km <- as.data.frame(km_cl$cluster)
  hc <- as.data.frame(cutclust)

  
  # n-Objects per class
  n_bom <-sum(str_count(rownames(hc),pattern = "krat"))
  n_dol <-sum(str_count(rownames(hc),pattern = "doli"))
  n_pin <-sum(str_count(rownames(hc),pattern = "ping"))
  
  # prepare new df
  
  ################################################
  # cluster quality 
  cq <- data.frame(matrix(nrow=3,ncol=8))
  colnames(cq) <- c("cluster","bomb","% in cl","pinge","% in cl","doline","% in cl","n_obj")
  cq$cluster <- 1:3
  
  for (i in 1:max(cl)){
    cq[i,2] <- paste0(sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i),"/",n_bom)
    cq[i,3] <- (sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i) / n_bom)
    cq[i,4] <- paste0(sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i),"/",n_pin)
    cq[i,5] <- (sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i) / n_pin)
    cq[i,6] <- paste0(sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i),"/",n_dol)
    cq[i,7] <- (sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i) / n_dol)
    cq[i,8] <- sum(hc[,1]==i)
  }
 
  ###################################################################
  # cluster quality long format with rounded percent
  cql <- data.frame(matrix(nrow=7,ncol=3))
  rownames(cql) <- c("n_obj","bomb","b% in cl","pinge","p% in cl","doline","d% in cl")
  cql
  colnames(cql) <- 1:3
  
  for (i in 1:max(cl)){
    cql[2,i] <- paste0(sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i),"/",n_bom)
    cql[3,i] <- round((sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i) / n_bom),digits = 4)
    cql[4,i] <- paste0(sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i),"/",n_pin)
    cql[5,i] <- round((sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i) / n_pin),digits = 4)
    cql[6,i] <- paste0(sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i),"/",n_dol)
    cql[7,i] <- round((sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i) / n_dol),digits = 4)
    cql[1,i] <- sum(hc[,1]==i)
  }
  
  
  ####################################################################
  # cluster quality with esitmated cluster class by max percent amount of obj/ n_obj in cluster
  
  cqe <- data.frame(matrix(nrow=3,ncol=10))
  colnames(cqe) <- c("cluster","bomb","% in cl","pinge","% in cl","doline","% in cl","n_obj","max_class","class%")
  cqe$cluster <- 1:3
  i=3
  for (i in 1:max(cl)){
    cqe[i,2] <- paste0(sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i),"/",n_bom)
    cqe[i,3] <- (sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i) / n_bom)
    cqe[i,4] <- paste0(sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i),"/",n_pin)
    cqe[i,5] <- (sum(str_count(rownames(hc),pattern = "ping")& hc[,1]==i) / n_pin)
    cqe[i,6] <- paste0(sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i),"/",n_dol)
    cqe[i,7] <- (sum(str_count(rownames(hc),pattern = "doli")& hc[,1]==i) / n_dol)
    cqe[i,8] <- sum(hc[,1]==i)
   if ( which(cqe[i,]==max(cqe[i,c(3,5,7)]))==3)  {cqe[i,9] <- "bomb"} else if(
      which(cqe[i,]==max(cqe[i,c(3,5,7)]))==5){cqe[i,9] <- "pinge" } else if(
        which(cqe[i,]==max(cqe[i,c(3,5,7)]))==7){cqe[i,9] <- "doline" }
    cqe[i,10] <- max(cqe[i,c(3,5,7)])
}
  ##############################################################################

  
  if (st<1){print("1")}
  sum(str_count(rownames(hc),pattern = "krat")& hc[,1]==i
  hc
  ls <-list(cutclust,kmeansCL)
  names(ls) <-c("hc","km")
  print(ls)
  return(ls)
  
}#end of fucntion
  

#'@examples
#'\dontrun{

#'}

