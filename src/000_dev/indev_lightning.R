#' Mandatory: Cenith fill sinks
#'
#' @description Optional: preprocessing tool for Cenith Segmentation of sinks.
#' computes a Sinks only elevation model (SOM). 
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: dem - a digital elevation model in tif format
#' @param Mandatory if function: output - the path where the som and filled_dem to be saved
#' predefinition in var is recommended
#' @param Mandatory if function: tmp - a folder to save several rasterlayers (can be deleted later)
#' @param Mandatory if function: minslope - Minimum slope gradient to preserve from cell to cell;
#' with a value of zero sinks are filled up to the spill elevation (which results in flat areas). Unit [Degree]
#' @param Mandatory if function: proj - desired projection for output data, predefinition in var is recommended

cenith_fillsinks <- function(dem,output,tmp,minslope,proj) {
  raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
  
  
  RSAGA::rsaga.geoprocessor(lib = "ta_lighting", module = 3,
                            param = list(DEM = paste(envrmt$path_tmp,"/dem.sgrd", sep = ""), 
                                         VISIBLE = paste(envrmt$path_tmp,"/visible.sgrd", sep = ""),
                                         SVF = paste(envrmt$path_tmp,"/svf.sgrd", sep = ""),
                                         SIMPLE= paste(envrmt$path_tmp,"/simple.sgrd", sep = ""),
                                         TERRAIN = paste(envrmt$path_tmp,"/terrainsgrd", sep = ""),
                                         DISTANCE= paste(envrmt$path_tmp,"/distance.sgrd", sep = ""),
                                         RADIUS=100,
                                         NDIRS =8,
                                         METHOD=0,
                                         DLEVEL=3
                                        
                                         
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)
  
  
 
  pr4 <- utm
  filled_dem <- raster::raster(file.path(envrmt$path_tmp, "distance.sdat"))
  proj4string(filled_dem) <- pr4
  raster::writeRaster(filled_dem,filename=paste0(file.path(envrmt$path_tmp,"/distance.tif")),overwrite = TRUE,NAflag = 0)
  fem <- raster::raster(file.path(envrmt$path_tmp,"/distance.tif"))
  plot(fem)
  som <- fem - dem
  raster::writeRaster(som,filename=paste0(file.path(output),"/som.tif"),overwrite = TRUE,NAflag = 0)
  
}
  
# exmpl (only in loaded environment)

##load a dem
#dem <- raster::raster(file.path(envrmt$path_Cenith_V2, "exampl_dem.tif"))
##set proj
#utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

##run
#cenith_fillsinks(dem=dem,output=envrmt$path_002_processed,tmp=envrmt$path_tmp,0,proj=utm)

##plot
#plot(raster::raster(file.path(envrmt$path_002_processed,"filled_dem.tif")))
