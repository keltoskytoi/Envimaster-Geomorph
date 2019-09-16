#' Mandatory: Reaver Hyperspace
#'
#' @description Optional: performs ordination and cluster analysis to get information from a n-dimensional Hyperspace
#' prints nmds and dca ordiantions with Hierarchical Clustering and K-Means Clustering
#' @name Mandatory Reaver 
#' @export Mandatory Reaver

#' @param Mandatory if function: df - a data.frame with sites in rows and parameters in columns with numeric values.
#' @param Mandatory if function: cl - desired n-count of clusters

#note: v1 returns cluster



Reaver_hyperspace <-function(df,cl){
  cat(" ",sep = "\n")
  cat("### Reaver starts to reduce the ",nrow(df),"-dimensional Hyperspace ###")
  cat(" ",sep = "\n")
  #ordinations
  #ca
  ca<-cca(df)
  #plot(ca,display="sites")
  
  #dca
  dca<-decorana(df)
  #plot(dca,display="sites")
  
  #nmds
  nmds<-metaMDS(df)
  #plot(nmds,display="sites",type="t",main="NMDS")
  
  #plot nmds with parameters
  #ordiplot(nmds,type="n")
  #orditorp(nmds,display="sites",cex=1,air=0.01)
  #orditorp(nmds,display="species",col="red",air=0.01)
  
  #clusters#########################################################################################
  #bray ward
  par(mfrow=c(1,1))
  vdist <- vegdist(df, method = "bray", binary = FALSE)
  cluster <- hclust(vdist, method = "ward.D")
  plot(cluster, hang = -1)
  cat("after plot")
  rect.hclust(cluster,2, border ="green")
  Sys.sleep(1)
  rect.hclust(cluster,3, border="blue")
  Sys.sleep(1)
  rect.hclust(cluster,4, border="orange")
  Sys.sleep(5)
  cutclust <- cutree(cluster, k=cl)
  #kmeans clustering
  km_cl <- kmeans(df,centers=cl,nstart=20)
  
  #plot
  par(mfrow=c(2,2))
  
  #plot with nmds
  #plot with hc nmds
  sc<-scores(nmds)
  ordiplot(nmds,type="n",main="hc_nmds")
  orditorp(nmds,display="sites",cex=1,air=0.01)
  orditorp(nmds,display="species",col="red",air=0.01)
  points(sc[,1],sc[,2],cex=2,pch=20,col=cutclust)
  ordihull(nmds, cutclust, lty=2, col="blue")
  
  #plot with km nmds 
  ordiplot(nmds,type="n",main="km_nmds")
  orditorp(nmds,display="sites",cex=1,air=0.01)
  orditorp(nmds,display="species",col="red",air=0.01)
  ordihull(nmds, km_cl$cluster, lty=3, col="grey60",lwd=2)
  points(sc[,1],sc[,2],cex=2,pch=20,col=km_cl$cluster)

  #plot with dca
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
  
  warning("plot may differ, run function severel times, maybe a problme with less data")
  #indicator for hc
  const_hc <-const(df, cutclust)
  import_hc <-importance(df, cutclust,show=NA)
  hc_ival <- indval(df, cutclust)
  print(summary(hc_ival))

  
  const_km <-const(df, km_cl$cluster)
  import_km <-importance(df,km_cl$cluster,show=NA)
  km_ival <- indval(df, km_cl$cluster)
  print(summary(km_ival))

  #return data
  par(mfrow=c(1,1))
  kmeansCL <- km_cl$cluster
  ls <-list(cutclust,kmeansCL)
  names(ls) <-c("hc","km")
  print(ls)
  return(ls)
  
}#end of fucntion
  

#'@examples
#'\dontrun{

#'}

