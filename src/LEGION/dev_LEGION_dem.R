#' Mandatory: Legion DEM
#' 
#' @description Optional: Computes several artificially raster layers from a single DEM. Returns a Brick.
#' @name Mandatory LEGION  
#' @export Mandatory LEGION

#' @param Mandatory if function: dem - a digital elevation model in tif format
#' @param Mandatory if function: output - the path where the som and filled_dem to be saved
#' predefinition in var is recommended
#' @param Mandatory if function: tmp - a folder to save several rasterlayers (can be deleted later)
#' @param Mandatory if function: proj - desired projection for output data, predefinition in var is recommended
#' @param Mandatory if function: radius - The maximum search radius for skyview [map units]
#' @param Mandatory if function: units - the unit for slope and aspect,0=radians 1=degree, default is 0
#' @param Mandatory if function: method - default 9 parameter 2nd order polynom (Zevenbergen & Thorne 1987) 
#' for others see http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_0.html


LEGION_dem <- function(dem,tmp,method=6,units=0,radius=100,proj){
  
### compute Atrifically layers with SAGA alorithm, rastes will be saved as .sgrd in a mp folder
  
#compute SAGA morphometrics, save to tmp folder as .sgrd
  #first write the dem to sgrd (cannot be used as a variable)
    raster::writeRaster(dem,filename=paste0(file.path(tmp),"/dem.sdat"),overwrite = TRUE,NAflag = 0)
    
  #parameters are taken from the website saga-gis
  RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 0,
                              param = list(ELEVATION =     paste(tmp,"/dem.sgrd", sep = ""), 
                                           SLOPE = paste(tmp,"/slo.sgrd", sep = ""),
                                           ASPECT= paste(tmp,"/asp.sgrd", sep = ""),
                                           C_GENE= paste(tmp,"/gen.sgrd", sep = ""),
                                           C_PROF= paste(tmp,"/pro.sgrd", sep = ""),
                                           C_PLAN= paste(tmp,"/pla.sgrd", sep = ""),
                                           C_TANG= paste(tmp,"/tan.sgrd", sep = ""),
                                           C_LONG= paste(tmp,"/lon.sgrd", sep = ""),
                                           C_CROS= paste(tmp,"/cro.sgrd", sep = ""),
                                           C_MINI= paste(tmp,"/min.sgrd", sep = ""),
                                           C_MAXI= paste(tmp,"/max.sgrd", sep = ""),
                                           C_TOTA= paste(tmp,"/tol.sgrd", sep = ""),
                                           C_ROTO= paste(tmp,"/rot.sgrd", sep = ""),
                                           METHOD= method,
                                           UNIT_SLOPE= 0,#0=radians,1=degree
                                           UNIT_ASPECT=0 #0=radians,1=degree
                                           
                                           
                              ),
                              show.output.on.console = TRUE, invisible = TRUE,
                              env = env)
#compute SAGA skyview, save to tmp folder as .sgrd
    #parameters are taken from the website saga-gis
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
    
### load sgrd and change projection
#load sdat from tmp folder by name, now they are saved in variable, names will still be the names from the sdat
    slo <- raster::raster(file.path(tmp, "slo.sdat"))
    asp <- raster::raster(file.path(tmp, "asp.sdat"))
    gen <- raster::raster(file.path(tmp, "gen.sdat"))
    pro <- raster::raster(file.path(tmp, "pro.sdat"))
    pla <- raster::raster(file.path(tmp, "pla.sdat"))
    tan <- raster::raster(file.path(tmp, "tan.sdat"))
    lon <- raster::raster(file.path(tmp, "lon.sdat"))
    cro <- raster::raster(file.path(tmp, "cro.sdat"))
    min <- raster::raster(file.path(tmp, "min.sdat"))
    max <- raster::raster(file.path(tmp, "max.sdat"))
    tol <- raster::raster(file.path(tmp, "tol.sdat"))
    rot <- raster::raster(file.path(tmp, "rot.sdat"))
    vis <- raster::raster(file.path(tmp, "vis.sdat"))
    svf <- raster::raster(file.path(tmp, "svf.sdat"))
    sim <- raster::raster(file.path(tmp, "sim.sdat"))
    ter <- raster::raster(file.path(tmp, "ter.sdat"))
    dis <- raster::raster(file.path(tmp, "dis.sdat"))
    
# set projection, predefined in proj
    pr4 <- proj
    proj4string(slo) <- pr4
    proj4string(asp) <- pr4
    proj4string(gen) <- pr4
    proj4string(pro) <- pr4
    proj4string(pla) <- pr4
    proj4string(tan) <- pr4
    proj4string(lon) <- pr4
    proj4string(cro) <- pr4
    proj4string(min) <- pr4
    proj4string(max) <- pr4
    proj4string(tol) <- pr4
    proj4string(rot) <- pr4
    proj4string(vis) <- pr4
    proj4string(svf) <- pr4
    proj4string(sim) <- pr4
    proj4string(ter) <- pr4
    proj4string(dis) <- pr4
    
# brick all layers and return brick, 
    #sequence can be set here, 
    #the names will be like the sdat org names not the variable names
    sk <- raster::brick(slo,asp,gen,pro,pla,tan,lon,cro,min,max,tol,rot,vis,svf,sim,ter,dis)
    return(sk)
} #end of main function

#need if wanna write out all data
    raster::writeRaster(slo,filename=paste0(file.path(output,"/slope.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(asp,filename=paste0(file.path(output,"/aspect.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(gen,filename=paste0(file.path(output,"/cov_generel.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(pro,filename=paste0(file.path(output,"/cov_profile.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(pla,filename=paste0(file.path(output,"/cov_plan.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(tan,filename=paste0(file.path(output,"/cov_tangetial.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(lon,filename=paste0(file.path(output,"/cov_longitudal.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(cro,filename=paste0(file.path(output,"/cov_cross.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(min,filename=paste0(file.path(output,"/cov_min.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(max,filename=paste0(file.path(output,"/cov_max.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(tol,filename=paste0(file.path(output,"/cov_total.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(rot,filename=paste0(file.path(output,"/cov_flowline.tif")),overwrite = TRUE,NAflag = 0)
    
    raster::writeRaster(vis,filename=paste0(file.path(output,"/visible.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(svf,filename=paste0(file.path(output,"/svf.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(sim,filename=paste0(file.path(output,"/simple.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(ter,filename=paste0(file.path(output,"/terrain.tif")),overwrite = TRUE,NAflag = 0)
    raster::writeRaster(dis,filename=paste0(file.path(output,"/distance.tif")),overwrite = TRUE,NAflag = 0)
    
  

