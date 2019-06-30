#' Mandatory: 
#'
#' @description Optional:  
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: dem - a digital elevation model in tif format
#' @param Mandatory if function: output - the path where the som and filled_dem to be saved
#' predefinition in var is recommended
#' @param Mandatory if function: tmp - a folder to save several rasterlayers (can be deleted later)
#' @param Mandatory if function: proj - desired projection for output data, predefinition in var is recommended

tpi <- function(dem,output,tmp,proj) {
  raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
  RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = XX, # unable to find inhered module nr
                            param = list(DEM =    paste(tmp,"/dem.sgrd", sep = ""), 
                                         TPI =    paste(tmp,"/tpi.sgrd", sep = ""),
                                         SCALE_MIN = 1,
                                         SCALE_MAX = 8,
                                         SCALE_NUM = 3
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)

  pr4 <- proj
  tpi <- raster::raster(file.path(tmp, "tpi.sdat"))
  proj4string(tpi) <- pr4
  raster::writeRaster(tpi,filename=paste0(file.path(output),"/tpi.tif"),overwrite = TRUE,NAflag = 0)
}
 
tmp=envrmt$path_tmp
  proj=utm
  dem=dem
  output=envrmt$path_002_processed
