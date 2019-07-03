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


#parameters refering to descrption of function as error (and as shoen in command line in SAGA Doku too)
tpi2 <- function(dem,output,tmp,proj) {
  raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
  RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 18, # unable to find inhered module nr
                            param = list(DEM =    paste(tmp,"/dem.sgrd", sep = ""), 
                                         TPI =    paste(tmp,"/tpi.sgrd", sep = ""),
                                         STANDARD = 0,
                                         RADIUS = 100,
                                         SCALE_MAX = 8,
                                         SCALE_NUM = 3,
                                         DW_WEIGHTING = 0,
                                         DW_IDW_POWER = 0,
                                         DW_IDW_OFFSET =1,
                                         DW_BANDWIDTH = 0
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)

  pr4 <- proj
  tpi <- raster::raster(file.path(tmp, "tpi.sdat"))
  proj4string(tpi) <- pr4
  raster::writeRaster(tpi,filename=paste0(file.path(output),"/tpi.tif"),overwrite = TRUE,NAflag = 0)
}

#parameters refering to SAGA Docu: http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_18.html

tpi2 <- function(dem,output,tmp,proj) {
  raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
  RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 18, # unable to find inhered module nr
                            param = list(DEM =    paste(tmp,"/dem.sgrd", sep = ""), 
                                         TPI =    paste(tmp,"/tpi.sgrd", sep = ""),
                                         STANDARD = 0,
                                         RADIUS = 100,
                                         SCALE_MAX = 8,
                                         SCALE_NUM = 3,
                                         DW_WEIGHTING = 0,
                                         DW_IDW_POWER = 0,
                                         DW_IDW_OFFSET =1,
                                         DW_BANDWIDTH = 0
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
  
  ### liegt das an falschem "format" von der SAGA seite?
