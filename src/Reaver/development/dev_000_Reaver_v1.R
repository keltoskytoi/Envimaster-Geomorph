#' Mandatory: Reaver V1.0
#'
#' @description Optional: Function to extract values from multilayer objects for several spatial polygons
#' @name Mandatory Reaver 
#' @export Mandatory Reaver

#' @param Mandatory if function: poly - a shp with polygones
#' @param Mandatory if function: multilayer - a rasterbrick, needs same CRS and extensions like the shp
#' @param Mandatory if function: set_ID - bolean, if TRUE an ID is added to the polygones, default is TRUE
#' @param Mandatory if function: stats - bolean, if TRUE returns a list with sd,mean,sum,min and max values for each polygone, default ist TRUE
#' @param Mandatory if function: spell - bolean, if TRUE the function will call the workflow position, default is TRUE


Reaver <- function(poly,multilayer,set_ID=TRUE,stats=TRUE,spell=TRUE) {
  
  #workflow with "spelling" (cat orders)
  if (spell==TRUE){
  cat(" ",sep = "\n")
  cat("### Reaver starts Extraction of Values ###")
  cat(" ",sep = "\n")
  
  #add ID column
  if (set_ID==TRUE){
    poly@data$ID=seq(1,length(poly),1)
  }else{
    poly=poly  } #if input data has a defined "ID" column
  
  #rasterize polygones , mask the multilayer to rasterized polygones and add the rasterized polygone 
  cat(" ",sep = "\n")
  cat("### Reaver rasterizes the polygones ###")
  rastrize <- raster::rasterize(poly,multilayer,field="ID")
  masked <- raster::mask(multilayer,rastrize)
  masked_ID <- raster::addLayer(masked,rastrize)
  
  #extract Values , handle NA and get df
  cat(" ",sep = "\n")
  cat("### Reaver extracts the Values from ",nlayers(multilayer),"Layers ###")
  getval <- raster::getValues(masked_ID)
  clean <- na.omit(getval)
  df_clean <- as.data.frame(clean)
  
  ### statistic path
  if (stats==TRUE){
    # calculate statistic
    cat(" ",sep = "\n")
    cat("### Reaver calculates statistic values ###")
    df_sd   <-ddply(df_clean,.(layer),colwise(sd))
    df_mean <-ddply(df_clean,.(layer),colwise(mean))
    df_sum <-ddply(df_clean,.(layer),colwise(sum))
    df_min <-ddply(df_clean,.(layer),colwise(min))
    df_max <-ddply(df_clean,.(layer),colwise(max))
    cat(" ",sep = "\n")
    cat(" ",sep = "\n")
    cat("### Reaver has finished ###")
    cat(" ",sep = "\n")
    return(list(df_clean=df_clean,
                df_sd=df_sd,
                df_mean=df_mean,
                df_sum=df_sum,
                df_min=df_min,
                df_max=df_max))
  }else{
    # return df only path
    cat(" ",sep = "\n")
    cat(" ",sep = "\n")
    cat("### Reaver has finished ###")
    cat(" ",sep = "\n")
    return(df_clean)

  }}else{
    # full workflow without spelling
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
      
      if (stats==TRUE){
        df_sd   <-ddply(df_clean,.(layer),colwise(sd))
        df_mean <-ddply(df_clean,.(layer),colwise(mean))
        df_sum <-ddply(df_clean,.(layer),colwise(sum))
        df_min <-ddply(df_clean,.(layer),colwise(min))
        df_max <-ddply(df_clean,.(layer),colwise(max))
        return(list(df_clean=df_clean,
                    df_sd=df_sd,
                    df_mean=df_mean,
                    df_sum=df_sum,
                    df_min=df_min,
                    df_max=df_max))
        }else{
      return(df_clean)
  }
}
}}
#'@examples
#'\dontrun{
#'#load data 
#'poly <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
#'poly
#crs(poly)
#poly<-spTransform(poly,utm)
## load artificially layers
#slope <-raster::raster(file.path(envrmt$path_Reaver, "expl_slope.tif"))
#aspect<-raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif"))
#cov_min<-raster::raster(file.path(envrmt$path_Reaver, "cov_min.tif"))
#cov_max<-raster::raster(file.path(envrmt$path_Reaver, "cov_max.tif"))
## create brick
#brck <- raster::brick(slope,aspect,cov_min,cov_max)
#brck
####run Reaver
#df<- Reaver(poly=poly,multilayer=brck,set_ID = TRUE,spell=F,stats = T)
#df$df_sd
#}


