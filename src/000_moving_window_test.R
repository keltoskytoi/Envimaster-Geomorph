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
source(file.path(root_folder, paste0(pathdir,"001_setup_geomorph_v1.R")))                                                              
###---------------------------------------------------------------------------------------###
#############################################################################################


# script to test optimal moving window using CENITH Validation V2

#source Cenith Validation V2
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/002_cenith_val_v2.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_a.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_b.R")))

# load data

chm <- raster::raster(file.path(root_folder, file.path(pathdir,".tif")))
vp <-  rgdal::readOGR(file.path(root_folder, file.path(pathdir,".shp")))
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(chm,vp) #check if projection is correct

# run several tests

var <- cenith_val_v2(chm,f=1,a=c(),b=c(),h=c(),vp=vp)

#end of script