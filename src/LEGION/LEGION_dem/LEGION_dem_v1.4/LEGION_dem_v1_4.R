#' Mandatory: Legion DEM
#' 
#' @description Optional: CComputes several artificially raster layers from a single DEM and uses
#' several sum filters.Returns a single RasterStack.
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
LEGION_dem_v2 <- function(dem,tmp,method=6,units=0,radius=100,proj,filter=0){
  
  #compute SAGA morphometrics, save to tmp folder as .sgrd
  #parameters are taken from the website saga-gis
  RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 0,
                            param = list(ELEVATION =     paste0(tmp,"/dem.sgrd"), 
                                         SLOPE = paste0(tmp,"/slope.sgrd"),
                                         ASPECT= paste0(tmp,"/aspect.sgrd"),
                                         C_GENE= paste0(tmp,"/cov_general.sgrd"),
                                         C_PROF= paste0(tmp,"/cov_profil.sgrd"),
                                         C_PLAN= paste0(tmp,"/cov_plan.sgrd"),
                                         C_TANG= paste0(tmp,"/cov_tangen.sgrd"),
                                         C_LONG= paste0(tmp,"/cov_longin.sgrd"),
                                         C_CROS= paste0(tmp,"/cov_cross.sgrd"),
                                         C_MINI= paste0(tmp,"/cov_minim.sgrd"),
                                         C_MAXI= paste0(tmp,"/cov_maxim.sgrd"),
                                         C_TOTA= paste0(tmp,"/cov_total.sgrd"),
                                         C_ROTO= paste0(tmp,"/cov_flowli.sgrd"),
                                         METHOD= method,
                                         UNIT_SLOPE= 0,#0=radians,1=degree
                                         UNIT_ASPECT=0 #0=radians,1=degree
                                         
                                         
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)
  #compute SAGA skyview, save to tmp folder as .sgrd
  #parameters are taken from the website saga-gis
  RSAGA::rsaga.geoprocessor(lib = "ta_lighting", module = 3,
                            param = list(DEM =     paste0(tmp,"/dem.sgrd"),
                                         VISIBLE = paste0(tmp,"/sv_visi.sgrd"),
                                         SVF =     paste0(tmp,"/sv_svf.sgrd"),
                                         SIMPLE=   paste0(tmp,"/sv_simp.sgrd"),
                                         TERRAIN = paste0(tmp,"/sv_terr.sgrd"),
                                         DISTANCE= paste0(tmp,"/sv_dist.sgrd"),
                                         RADIUS=radius,
                                         NDIRS =8, #default setting
                                         METHOD=0, #default setting
                                         DLEVEL=3  #default setting
                                         
                                         
                            ),
                            show.output.on.console = TRUE, invisible = TRUE,
                            env = env)
  
  ### load sgrd and change projection
  #load sdat from tmp folder by name, now they are saved in variable, names will still be the names from the sdat
  slo <- raster::raster(file.path(paste0(tmp, "/slope.sdat")))
  asp <- raster::raster(file.path(paste0(tmp, "/aspect.sdat")))
  gen <- raster::raster(file.path(paste0(tmp, "/cov_general.sdat")))
  pro <- raster::raster(file.path(paste0(tmp, "/cov_profil.sdat")))
  pla <- raster::raster(file.path(paste0(tmp, "/cov_plan.sdat")))
  tan <- raster::raster(file.path(paste0(tmp, "/cov_tangen.sdat")))
  lon <- raster::raster(file.path(paste0(tmp, "/cov_longin.sdat")))
  cro <- raster::raster(file.path(paste0(tmp, "/cov_cross.sdat")))
  min <- raster::raster(file.path(paste0(tmp, "/cov_minim.sdat")))
  max <- raster::raster(file.path(paste0(tmp, "/cov_maxim.sdat")))
  tol <- raster::raster(file.path(paste0(tmp, "/cov_total.sdat")))
  rot <- raster::raster(file.path(paste0(tmp, "/cov_flowli.sdat")))
  vis <- raster::raster(file.path(paste0(tmp, "/sv_visi.sdat")))
  svf <- raster::raster(file.path(paste0(tmp, "/sv_svf.sdat")))
  sim <- raster::raster(file.path(paste0(tmp, "/sv_simp.sdat")))
  ter <- raster::raster(file.path(paste0(tmp, "/sv_terr.sdat")))
  dis <- raster::raster(file.path(paste0(tmp, "/sv_dist.sdat")))
  
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
  
  if (filter[1]==0){
    return(stk)
  }else{
  
  ls <-sf_LEGION_dem(dem,tmp,method,units,radius,proj,filter)
  
  
   
 for (i in 1:length(filter)){
   stk <-stack(stk,ls[[i]])
   
 }
   return(stk)
  }
}



