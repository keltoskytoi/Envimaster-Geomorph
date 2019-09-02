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
libs = c("link2GI","spatialEco","mapview") 
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

source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_v1.R"))) 


dem <- raster::raster(file.path(envrmt$path_Cenith_V2, "exampl_dem.tif"))
plot(dem)

# invert dem for positiv values inverted
dem2 <- spatialEco::raster.invert(dem)

#check differenz and projection

plot(dem)
plot(dem2)
crs(dem2)

#run Cenith
test <- Cenith(chm=dem2,h=2,a=0.,b=0.01)

#view
mapview(test$tp)+dem2
mapview(test$polygon)+dem2


sinks <- raster::raster(file.path(envrmt$path_002_processed, "fill_sink_test.tif"))
plot(sinks)
test2 <- Cenith(chm=sinks,h=0.5,a=0.,b=0.01)
mapview(test2$tp)+sinks
mapview(test2$polygon)+sinks
