#' Mandatory: Cenith Segementation for Tiles V2
#'
#' @description Optional:Computes TreeCrowns for Tiles
#' @name Mandatory Cenith  
#' @export Mandatory Cenith
#' @param Mandatory if function: chm - a chm rasterlayer
#' @param Mandatory if function: tiles - a tileShema class object, created by "Cenith_tiles" function
#' @param Mandatory if function: tp - a treeposlayer
#' @param Mandatory if function: h - height

#Note: V2 uses cleaned chmseg function with deleted spelling

cenith_seg_tiles <- function(x=chm,tiles,tp,h) {
  
  lapply(seq(1:length(tiles$tilePolygons)),function (i){
    cat(" ",sep = "\n")
    cat(paste0("### Cenith computes Crowns for Tile ",as.factor(i)," / ",length(tiles$tilePolygons)," ###",sep = "\n"))
  tmpcrop <- crop(x,tiles$buffPolygons[i,])
  crownlyr <- sf_chmseg_clean(tmpcrop,
                              treepos = tp,
                              format = "polygons",
                              minTreeAlt = h,
                              verbose = TRUE)
  crs(crownlyr) <- crs(x)
  ids <- na.omit(over(tp,crownlyr))
  ids$rownames <- as.numeric(row.names(ids))
  crownlyr@data$treeID <- ids$rownames
  crownlyr <- crop(crownlyr,tiles$nbuffPolygons[i,])
  
return(crownlyr)})

}

