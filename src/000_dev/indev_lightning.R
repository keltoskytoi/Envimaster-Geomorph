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
#' @param Mandatory if function: radius - 	The maximum search radius [map units]

skyview <- function(dem,output,tmp,proj,radius=100) {
  raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
  RSAGA::rsaga.geoprocessor(lib = "ta_lighting", module = 3,
                            param = list(DEM =     paste(tmp,"/dem.sgrd", sep = ""), 
                                         VISIBLE = paste(tmp,"/vis.sgrd", sep = ""),
                                         SVF =     paste(tmp,"/svf.sgrd", sep = ""),
                                         SIMPLE=   paste(tmp,"/sim.sgrd", sep = ""),
                                         TERRAIN = paste(tmp,"/ter.sgrd", sep = ""),
                                         DISTANCE= paste(tmp,"/dis.sgrd", sep = ""),
                                         RADIUS=radius,
                                         NDIRS =8, #default setting
                                         METHOD=0, #default setting
                                         DLEVEL=3  #default setting
                                        
                                         
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)
  

  pr4 <- utm
  vis <- raster::raster(file.path(tmp, "vis.sdat"))
  svf <- raster::raster(file.path(tmp, "svf.sdat"))
  sim <- raster::raster(file.path(tmp, "sim.sdat"))
  ter <- raster::raster(file.path(tmp, "ter.sdat"))
  dis <- raster::raster(file.path(tmp, "dis.sdat"))
  proj4string(vis) <- pr4
  proj4string(svf) <- pr4
  proj4string(sim) <- pr4
  proj4string(ter) <- pr4
  proj4string(dis) <- pr4
  raster::writeRaster(vis,filename=paste0(file.path(output,"/visible.tif")),overwrite = TRUE,NAflag = 0)
  raster::writeRaster(svf,filename=paste0(file.path(output,"/svf.tif")),overwrite = TRUE,NAflag = 0)
  raster::writeRaster(sim,filename=paste0(file.path(output,"/simple.tif")),overwrite = TRUE,NAflag = 0)
  raster::writeRaster(ter,filename=paste0(file.path(output,"/terrain.tif")),overwrite = TRUE,NAflag = 0)
  raster::writeRaster(dis,filename=paste0(file.path(output,"/distance.tif")),overwrite = TRUE,NAflag = 0)
  
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
