#' Mandatory: Reaver Hyperspace
#'
#' @description Optional: performs ordination and cluster analysis to get information from a n-dimensional Hyperspace
#' prints nmds and dca ordiantions with Hierarchical Clustering and K-Means Clustering
#' @name Mandatory Reaver 
#' @export Mandatory Reaver

#' @param Mandatory if function: df - a data.frame with sites in rows and parameters in columns with numeric values.
#' @param Mandatory if function: indi - if TRUE the indicator parameters are printed, default = TRUE

#note: v1.2 returning improved cluster quality parameters
# stats for HC only !!!


Reaver_hyperspace_imgs <-function(df,font){
  cl=3 # set value, desciptiv stats work only for 3
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
  cutclust <- cutree(cluster, k=3)
  #kmeans clustering
  km_cl <- kmeans(df,centers=cl,nstart=20)
  #plot
  par(mfrow=c(2,2))
  
  #plot with hc nmds
  sc<-scores(nmds)
  ordiplot(nmds,type="n",main="hc_nmds")
  orditorp(nmds,display="sites",cex=font,air=0.01)
  points(sc[,1],sc[,2],cex=2,pch=20,col=cutclust)
  ordihull(nmds, cutclust, lty=2, col="blue")
  
  #plot with km nmds 
  ordiplot(nmds,type="n",main="km_nmds")
  orditorp(nmds,display="sites",cex=font,air=0.01)
  ordihull(nmds, km_cl$cluster, lty=3, col="grey60",lwd=2)
  points(sc[,1],sc[,2],cex=2,pch=20,col=km_cl$cluster)

  #plot with hc dca points
  scd<-scores(dca)
  plot(dca,display="sites",type="n", main="hc_dca")
  orditorp(dca,display="sites",cex=font,air=0.01)
  points(scd[,1],scd[,2],cex=2,pch=20,col=cutclust)
  ordihull(dca, cutclust, lty=2, col="blue")
  
  
  
  #plot with km dca points
  plot(dca,display="sites",type="n", main="km_dca")
  orditorp(dca,display="sites",cex=font,air=0.01)
  points(scd[,1],scd[,2],cex=2,pch=20,col=km_cl$cluster)
  ordihull(dca, km_cl$cluster, lty=3, col="grey60",lwd=2)
  
 

  
}#end of fucntion
  

#'@examples
#'\dontrun{

#'}

