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
libs = c("link2GI","ForestTools","uavRst") 
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

#source CENITH V2
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_v1.R"))) 

# load data
dem <- raster::raster(file.path(envrmt$path_Cenith_V2,"exampl_dem.tif"))
som <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_som.tif"))
vp <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"exmpl_vp.shp"))
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp) #check if projection is correct

# run several tests on som
var <- cenith_val_v2(chm=som,f=1,a=c(1,2),b=c(0.1,0.9),h=c(0.1,0.5,0.9),vp=vp)

var
### run Segmentation with CENITH V2
mapview(vp)+som
# run Cenith on som
test <- Cenith(chm=som,h=0.9,a=1,b=0.1)
mapview(test$tp)+som
mapview(test$polygon)+som

test
#end of script