#' Mandatory: Subfunction for Legion DEM
#' 
#' @description Optional: Computes several artificially raster layers from a single DEM. returns a list.
#' @name Mandatory LEGION  
#' @export Mandatory LEGION

#' @param Mandatory if function: dem - a digital elevation model in tif format
#' @param Mandatory if function: output - the path where the som and filled_dem to be saved
#' predefinition in var is recommended
#' @param Mandatory if function: tmp - a folder to save several rasterlayers (can be deleted later)
#' @param Mandatory if function: proj - desired projection for output data, predefinition in var is recommended
#' @param Mandatory if function: radius - The maximum search radius for skyview [map units]
#' @param Mandatory if function: units - the unit for slope and aspect,0=radians 1=degree, default is 0
#' @param Mandatory if function: filter - a vector of at least 2 values for sum filter in f*f for the input dem.
#' @param Mandatory if function: method - default 9 parameter 2nd order polynom (Zevenbergen & Thorne 1987) 
#' for others see http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_0.html

#Note sf: Subfunction to avoid list problem with lapply
sf_LEGION_dem <- function(dem,tmp,method=6,units=0,radius=100,proj,filter){
  
  lapply(filter, function(f){

  
  # change dem
  dem <- raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f))
  raster::writeRaster(dem,filename=paste0(file.path(paste0(tmp,"/dem_f",as.factor(f),".sdat"))),overwrite = TRUE,NAflag = 0)
  
#compute SAGA morphometrics, save to tmp folder as .sgrd
  #parameters are taken from the website saga-gis
        RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 0,
                              param = list(ELEVATION =     paste(tmp,"/dem_f",as.factor(f),".sgrd", sep = ""), 
                                           SLOPE = paste(tmp,"/slope_f",as.factor(f),".sgrd", sep = ""),
                                           ASPECT= paste(tmp,"/asp_f",as.factor(f),".sgrd", sep = ""),
                                           C_GENE= paste(tmp,"/gen_f",as.factor(f),".sgrd", sep = ""),
                                           C_PROF= paste(tmp,"/pro_f",as.factor(f),".sgrd", sep = ""),
                                           C_PLAN= paste(tmp,"/pla_f",as.factor(f),".sgrd", sep = ""),
                                           C_TANG= paste(tmp,"/tan_f",as.factor(f),".sgrd", sep = ""),
                                           C_LONG= paste(tmp,"/lon_f",as.factor(f),".sgrd", sep = ""),
                                           C_CROS= paste(tmp,"/cro_f",as.factor(f),".sgrd", sep = ""),
                                           C_MINI= paste(tmp,"/min_f",as.factor(f),".sgrd", sep = ""),
                                           C_MAXI= paste(tmp,"/max_f",as.factor(f),".sgrd", sep = ""),
                                           C_TOTA= paste(tmp,"/tol_f",as.factor(f),".sgrd", sep = ""),
                                           C_ROTO= paste(tmp,"/rot_f",as.factor(f),".sgrd", sep = ""),
                                           METHOD= method,
                                           UNIT_SLOPE= 0,#0=radians,1=degree
                                           UNIT_ASPECT=0 #0=radians,1=degree
                                           
                                           
                              ),
                              show.output.on.console = TRUE, invisible = TRUE,
                              env = env)
#compute SAGA skyview, save to tmp folder as .sgrd
    #parameters are taken from the website saga-gis
    RSAGA::rsaga.geoprocessor(lib = "ta_lighting", module = 3,
                              param = list(DEM =     paste(tmp,"/dem_f",as.factor(f),".sgrd", sep = ""),
                                           VISIBLE = paste(tmp,"/vis_f",as.factor(f),".sgrd", sep = ""),
                                           SVF =     paste(tmp,"/svf_f",as.factor(f),".sgrd", sep = ""),
                                           SIMPLE=   paste(tmp,"/sim_f",as.factor(f),".sgrd", sep = ""),
                                           TERRAIN = paste(tmp,"/ter_f",as.factor(f),".sgrd", sep = ""),
                                           DISTANCE= paste(tmp,"/dis_f",as.factor(f),".sgrd", sep = ""),
                                           RADIUS=radius,
                                           NDIRS =8, #default setting
                                           METHOD=0, #default setting
                                           DLEVEL=3  #default setting
                                           
                                           
                              ),
                              show.output.on.console = TRUE, invisible = TRUE,
                              env = env)
    
### load sgrd and change projection
#load sdat from tmp folder by name, now they are saved in variable, names will still be the names from the sdat
    slo <- raster::raster(file.path(paste0(tmp,"/slope_f",as.factor(f),".sdat")))
    asp <- raster::raster(file.path(paste0(tmp, "/asp_f",as.factor(f),".sdat")))
    gen <- raster::raster(file.path(paste0(tmp, "/gen_f",as.factor(f),".sdat")))
    pro <- raster::raster(file.path(paste0(tmp, "/pro_f",as.factor(f),".sdat")))
    pla <- raster::raster(file.path(paste0(tmp, "/pla_f",as.factor(f),".sdat")))
    tan <- raster::raster(file.path(paste0(tmp, "/tan_f",as.factor(f),".sdat")))
    lon <- raster::raster(file.path(paste0(tmp, "/lon_f",as.factor(f),".sdat")))
    cro <- raster::raster(file.path(paste0(tmp, "/cro_f",as.factor(f),".sdat")))
    min <- raster::raster(file.path(paste0(tmp, "/min_f",as.factor(f),".sdat")))
    max <- raster::raster(file.path(paste0(tmp, "/max_f",as.factor(f),".sdat")))
    tol <- raster::raster(file.path(paste0(tmp, "/tol_f",as.factor(f),".sdat")))
    rot <- raster::raster(file.path(paste0(tmp, "/rot_f",as.factor(f),".sdat")))
    vis <- raster::raster(file.path(paste0(tmp, "/vis_f",as.factor(f),".sdat")))
    svf <- raster::raster(file.path(paste0(tmp, "/svf_f",as.factor(f),".sdat")))
    sim <- raster::raster(file.path(paste0(tmp, "/sim_f",as.factor(f),".sdat")))
    ter <- raster::raster(file.path(paste0(tmp, "/ter_f",as.factor(f),".sdat")))
    dis <- raster::raster(file.path(paste0(tmp, "/dis_f",as.factor(f),".sdat")))
    
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
    stk <- raster::stack(slo,asp,gen,pro,pla,tan,lon,cro,min,max,tol,rot,vis,svf,sim,ter,dis)

    return(stk)
    
  })
}
