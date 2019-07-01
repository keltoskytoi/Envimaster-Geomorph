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
libs = c("link2GI","spatialEco","mapview", "rgdal", "doParallel","parallel" ) 
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

#load data

demex <- raster::raster(file.path(envrmt$path_Cenith_V2, "exampl_dem.tif"))

dem <- raster::raster(file.path(envrmt$path_001_org, "DEM_mof.tif"))
rgb <- raster::raster(file.path(envrmt$path_001_org, "RGB_mof.tif"))


# invert dem for positiv values inverted

dem2 <- spatialEco::raster.invert(dem)

#check differenz and projection

plot(dem)
plot(dem2)
crs(dem2)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#run Cenith

test1 <- Cenith(chm=dem2,h=2,a=0.01,b=0.8, ntx = 2, nty = 2)

#stop cluster

stopCluster(cl)

#view

mapview(test1$tp)+dem2
mapview(test1$polygon)+dem2

#run with filled sinks raster

sinksex <- raster::raster(file.path(envrmt$path_002_processed, "fill_sink_test.tif"))
sinks <- raster::raster(file.path(envrmt$path_002_processed, "som.tif"))
plot(sinks)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

test2 <- Cenith(chm=sinks,h=0.5,a=0.01,b=0.8)

#stop cluster

stopCluster(cl)

#view
mapview(test2$tp)+rgb
mapview(test2$tp)+dem
mapview(test2$tp)+hill
mapview(test2$polygon)+sinks

#write data
writeOGR(obj=test1,dsn= file.path(envrmt$path_002_processed, "seg_mof_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=test1$tp,dsn= file.path(envrmt$path_002_processed, "seg_mof_tp.shp"),layer="testShape",driver="ESRI Shapefile")

writeOGR(obj=test2$polygon,dsn= file.path(envrmt$path_002_processed, "seg_sinks_mof_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=test2$tp,dsn= file.path(envrmt$path_002_processed, "seg_sinks_mof_tp.shp"),layer="testShape",driver="ESRI Shapefile")        
