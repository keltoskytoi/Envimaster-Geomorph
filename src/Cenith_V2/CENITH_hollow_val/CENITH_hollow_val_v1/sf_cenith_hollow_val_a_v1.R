#' Mandatory: Cenith Hollow Validation v1 Subfunction validation for value a
#'
#' @description Optional: subfunction for running val4b over a
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: chm - a canopy height model
#' @param Mandatory if function: a, b - parameters for moving window
#' @param Mandatory if function: h - minimum height to detect trees
#' @param Mandatory if function: optional vp - a pointlayer (shp) with positions of Trees

#Note v1: uses cleaned sf

cenith_hollow_val_a_v1 <-function(chm,a,b,h,vp,min,max){
  result <- data.frame(matrix(nrow = 3, ncol = 5))
  
for (i in seq(1:length(a))){
  cat(paste0("### Cenith starts with loop a ",as.factor(i)," / ",as.factor(length(a))," ###",sep = "\n"))
  cat       ("#############################",sep="\n")

 
   if(i==1){
    res  <-cenith_hollow_val_b_v1(chm,a[i],b,h,vp,min,max)
  }    else {
    res2 <-cenith_hollow_val_b_v1(chm,a[i],b,h,vp,min,max)
    res= rbind(res,res2)}


  
  
}

  return(res)
}


  