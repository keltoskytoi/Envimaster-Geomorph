#' Mandatory: Reaver V1.0
#'
#' @description Optional: Function to extract values from multilayer objects for several spatial polygons
#' @name Mandatory Reaver 
#' @export Mandatory Reaver

#' @param Mandatory if function: poly - a shp with polygones
#' @param Mandatory if function: multilayer - a rasterbrick, needs same CRS and extensions like the shp
#' @param Mandatory if function: set_ID - bolean, if TRUE an ID is added to the polygones
#' @param Mandatory if function: spell - bolean, if TRUE the function will call the workflow position


Reaver <- function(poly,multilayer,set_ID=TRUE,spell=TRUE) {
  if (spell==TRUE){
  cat(" ",sep = "\n")
  cat("### Reaver starts Extraction of Values ###")
  cat(" ",sep = "\n")
  if (set_ID==TRUE){
    poly@data$ID=seq(1,length(poly),1)
  }else{
    poly=poly  }
  cat(" ",sep = "\n")
  cat("### Reaver rasterizes the polygones ###")
  rastrize <- raster::rasterize(poly,multilayer,field="ID")
  masked <- raster::mask(multilayer,rastrize)
  masked_ID <- raster::addLayer(masked,rastrize)
  cat(" ",sep = "\n")
  cat("### Reaver extracts the Values from ",nlayers(multilayer),"Layers ###")
  getval <- raster::getValues(masked_ID)
  clean <- na.omit(getval)
  df_clean <- as.data.frame(clean)
  cat(" ",sep = "\n")
  cat(" ",sep = "\n")
  cat("### Reaver has finished ###")
  cat(" ",sep = "\n")
  return(df_clean)
  }else{
    if (spell==FALSE){
      if (set_ID==TRUE){
        poly@data$ID=seq(1,length(poly),1)
      }else{
        poly=poly  }
      rastrize <- raster::rasterize(poly,multilayer,field="ID")
      masked <- raster::mask(multilayer,rastrize)
      masked_ID <- raster::addLayer(masked,rastrize)
      getval <- raster::getValues(masked_ID)
      clean <- na.omit(getval)
      df_clean <- as.data.frame(clean)
      return(df_clean)
  }
}
}
#'@examples
#'\dontrun{
#'#load data 
poly <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
poly
crs(poly)
poly<-spTransform(poly,utm)
# load artificially layers
slope <-raster::raster(file.path(envrmt$path_Reaver, "expl_slope.tif"))
aspect<-raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif"))
cov_min<-raster::raster(file.path(envrmt$path_Reaver, "cov_min.tif"))
cov_max<-raster::raster(file.path(envrmt$path_Reaver, "cov_max.tif"))
# create brick
brck <- raster::brick(slope,aspect,cov_min,cov_max)
brck
###run Reaver
df<- Reaver(poly=poly,multilayer=brck,set_ID = TRUE,spell=TRUE)
df
brck@data
}




