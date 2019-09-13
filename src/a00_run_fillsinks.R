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
libs = c("link2GI","rgdal","parallel", "doParallel", "mapview") 
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
dem <- raster::raster(file.path(envrmt$path_001_org, "DEM_mof.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

source(file.path(root_folder, paste0(pathdir,"000_dev/cenith_fillsinks.R"))) 

#run cluster
cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#run cenith fill sinks
cenith_fillsinks(dem      =dem,
                 output   =envrmt$path_002_processed,
                 tmp      =envrmt$path_tmp,
                 minslope =0,
                 proj     =utm)

#stop cluster
stopCluster(cl)

som <- raster::raster(file.path(envrmt$path_002_processed, "som.tif"))

mapview(som)

writeRaster(som, filename= file.path(envrmt$path_002_processed, "som_mof.tif"), format="GTiff", overwrite=TRUE)
