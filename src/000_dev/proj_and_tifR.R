#############################################################################################
###--- Setup Environment -------------------------------------------------------------------#
                                  ###############################################           #
# require libs for setup          #EEEE n   n v       v rrrr    m     m   ttttt #           #                  
require(raster)                   #E    nn  n  v     v  r   r  m m   m m    t   #           #         
require(envimaR)                  #EE   n n n   v   v   rrrr   m m   m m    t   #           #                
require(link2GI)                  #E    n  nn    v v    r  r  m   m m   m   t   #           #             
                                  #EEEE n   n     v     r   r m    m    m   t   #           #
                                  ###############################################           #
                                                                                            #
# define needed libs and src folder                                                         #
libs = c("link2GI") 
pathdir = "repo/src/"

#set root folder for uniPC or laptop                                                        #
root_folder = alternativeEnvi(root_folder = "~/edu/Envimaster-Geomorph",                    #
                              alt_env_id = "COMPUTERNAME",                                  #
                              alt_env_value = "PCRZP",                                      #
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           #
#source environment script                                                                  #
source(file.path(root_folder, paste0(pathdir,"001_setup_geomorph_withSAGA_v1.R")))                                                              
###---------------------------------------------------------------------------------------###
#############################################################################################

#load DEM and export as SAGA format
rdem <- raster::raster(file.path(envrmt$path_Cenith_V2, "exampl_dem.tif"))
raster::writeRaster(rdem,filename=paste0(file.path(envrmt$path_002_processed),"/dem_exmpl.sdat"),overwrite = TRUE,NAflag = 0)

# compute filled DEM
RSAGA::rsaga.geoprocessor(lib = "ta_preprocessor", module = 4,
                          param = list(ELEV = paste(envrmt$path_002_processed,"/dem_exmpl.sgrd", sep = ""), 
                                       MINSLOPE = 0,
                                       WSHED = paste(envrmt$path_002_processed,"/wseh.sgrd", sep = ""),
                                       FDIR = paste(envrmt$path_002_processed,"/fdir.sgrd", sep = ""),
                                       FILLED = paste(envrmt$path_002_processed,"/filled_dem.sgrd", sep = "")
                          ),
                          show.output.on.console = TRUE, invisible = TRUE,
                          env = env)


#plot filled DEM (sdat)
dem_org <- raster::raster(file.path(envrmt$path_002_processed,"dem_exmpl.sdat"))
filled_saga <- raster::raster(file.path(envrmt$path_002_processed, "filled_dem.sdat"))
par(mfrow=c(1,2))
plot(dem_org)
plot(filled)


#set projection and convert to tif format ##### tested

filled_saga
pr4 <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
raster::writeRaster(filled_saga,filename=paste0(file.path(envrmt$path_002_processed),"/filled.tif"),overwrite = TRUE,NAflag = 0)
filled_tif <-raster::raster(file.path(envrmt$path_002_processed,"filled.tif"))

filled_saga
crs(filled_tif)

utm <- CRS(pr4)
filled_saga_utm <- CRS(pr4)
filled_tif_utm <- projectRaster(filled_tif, crs=utm)

plot(filled_saga_utm)
filled_tif_utm
###################################

proj4string(filled_saga) <- utm
filled_saga_utm <-proj4string(filled_saga) <- utm
filled_saga_utm

crs(filled_saga)
raster::writeRaster(filled_saga_utm,filename=paste0(file.path(envrmt$path_002_processed),"/filled_utmfromsaga.tif"),overwrite = TRUE,NAflag = 0)
raster::writeRaster(filled_tif_utm,filename=paste0(file.path(envrmt$path_002_processed),"/filled_utm.tif"),overwrite = TRUE,NAflag = 0)

utmsaga <-raster::raster(file.path(envrmt$path_002_processed,"filled_utmfromsaga.tif"))
utm <-raster::raster(file.path(envrmt$path_002_processed,"filled_utm.tif"))

# result: die sdat can be directly projected and saved as tif

utmsaga
utm

###

