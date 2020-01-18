#' Mandatory: Cenith subfunction cleaned chmseg
#'
#' @description Optional: Segmentation Alogrithm for a elevation modell 
#' @name Mandatory Cenith  
#' @export Mandatory Cenith



#note identical to UAVRST chmseg but deleted cat spellings

sf_chmseg_clean <-function (treepos = NULL, chm = NULL, minTreeAlt = 2, format = "polygons", 
                         winRadius = 1.5, verbose = FALSE) 
{
  if (class(treepos) %in% c("RasterLayer", "RasterStack", "RasterBrick")) {
    pr <- raster::crs(raster::projection(raster::raster(chm)))
    raster::projection(treepos) <- pr
    treepos <- raster::rasterToPoints(treepos, spatial = TRUE)
    treepos@data$layer <- 1
    treepos@data$winRadius <- 1.5
    treepos@data$treeID <- seq(1:nrow(treepos@data))
    names(treepos) <- c("height", "treeID", "winRadius", 
                        "layer")
  }
  crownsFT<- sf_ft_mcws_clean(treetops = treepos, CHM = chm, 
                              format = format, minHeight = minTreeAlt, verbose = verbose)
  return(crownsFT)
}