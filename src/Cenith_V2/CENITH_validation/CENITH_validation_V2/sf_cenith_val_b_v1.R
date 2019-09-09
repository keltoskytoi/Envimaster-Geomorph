#' Mandatory: Cenith Validation Subfunction validation for value b
#'
#' @description Optional: primary subfunction for segmentation over b and calculate statistc results
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: chm - a canopy height model
#' @param Mandatory if function: a, b - parameters for moving window
#' @param Mandatory if function: h - minimum height to detect trees
#' @param Mandatory if function: optional vp - a pointlayer (shp) with positions of Trees

#Note V1: basic hit and miss rates for result
cenith_val4b_v1 <- function(chm,a,b,h,vp){
  result <- data.frame(matrix(nrow = length(b), ncol = 6)) # ncol = n information stored
  for (j in seq(1:length(b))){
    cat       (" ",sep="\n")
    
    cat(paste0("### Cenith starts loop b ",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    cat       ("#############################",sep="\n")
    cat       (" ",sep="\n")
    cat("### Cenith computes Treepos Layer ###",sep = "\n")
    tpos = ForestTools::vwf(chm, 
                            winFun = function(x){x * a + b[j]}, 
                            minHeight = h, 
                            verbose = TRUE)
    
    #cat(paste0("### Cenith computes polygon layer with b",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    seg <- chmseg_FT(chm = chm,
                     treepos = tpos,
                     format = "polygons",
                     minTreeAlt = h,
                     verbose = TRUE)
    
    cat(paste0("### Cenith calculates precision ratios for b ",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    stat <- ForestTools::sp_summarise(vp, seg) # compute data points in polygons
    stat[is.na(stat$TreeCount)] <- 0 # na to 0
    
    
    pkb <- sum(stat$TreeCount<1) # amount polygon without tree (miss)
    pb <- sum(stat$TreeCount==1) # amount polygon with exact 1 tree (hit)
    pmb <-sum(stat$TreeCount>1) # amount polygon with more than 1 tree (miss)
    
    hit = pb/length(stat$TreeCount) # calc hit ration in percent (amount of exact trees
    over = pkb/length(stat$TreeCount) #calc empty ration in percent (amount of polygon without trees)
    under = pmb/length(stat$TreeCount) # mis.rati miss rate in percent (amount of polygons with more than 1 Tree)

    
    
    result[j, 1] <- a
    result[j, 2] <- b[j]
    result[j, 3] <- h
    result[j, 4] <- hit
    result[j, 5] <- over
    result[j, 6] <- under
    cat       (" ",sep="\n")
    cat(paste0("### Cenith rdy with b ",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    cat       ("#############################",sep="\n")
    cat       (" ",sep="\n")
  } 
  return(result)
}
