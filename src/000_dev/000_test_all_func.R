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
dem <- raster::raster(file.path(envrmt$path_Cenith_V2, "exampl_dem.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

source(file.path(root_folder, paste0(pathdir,"000_dev/cenith_fillsinks.R"))) 
cenith_fillsinks(dem      =dem,
                 output   =envrmt$path_002_processed,
                 tmp      =envrmt$path_tmp,
                 minslope =0,
                 proj     =utm)

som <- raster::raster(file.path(envrmt$path_002_processed, "som.tif"))
plot(som)

source(file.path(root_folder, paste0(pathdir,"000_dev/indev_lightning.R"))) 
skyview(dem      =dem,
        output   =envrmt$path_002_processed,
        tmp      =envrmt$path_tmp,
        proj     =utm,
        radius   =100)

svf <- raster::raster(file.path(envrmt$path_002_processed, "svf.tif"))
plot(svf)

source(file.path(root_folder, paste0(pathdir,"000_dev/morphmetric.R"))) 
morphmetric(dem      =dem,
        output   =envrmt$path_002_processed,
        tmp      =envrmt$path_tmp,
        proj     =utm,
        method   =6)

cov_max <-raster::raster(file.path(envrmt$path_002_processed, "cov_max.tif"))
plot(cov_max)

# tpi doesnt work inhered nr for module
#source(file.path(root_folder, paste0(pathdir,"000_dev/tpi.R"))) 
#tpi        (dem      =dem,
#            output   =envrmt$path_002_processed,
#            tmp      =envrmt$path_tmp,
#            proj     =utm
#            )
#
#tpi <-raster::raster(file.path(envrmt$path_002_processed, "tpi.tif"))
#plot(tpi)
