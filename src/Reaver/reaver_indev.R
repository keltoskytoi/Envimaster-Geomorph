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

#load dem and compute sink only dem (som)
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
# run Cenith segmentation to compute polygons for example extraction
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_v1.R")))

expl_seg <- Cenith(chm=som,a=0.8,b=2,h=1,f=1)
expl_seg
plot(expl_seg$polygon)
crs(expl_seg$polygon)
mapview::mapview(som)+expl_seg$polygon
writeOGR(expl_seg$polygon,file.path(envrmt$path_002_processed, "exp_poly.shp"),"layername", driver="ESRI Shapefile")
require(rgdal)

#load polygone layer and set correct CRS ### here ask CR, wh it allways changes the towgs84 in utm crs###
poly <-readOGR(file.path(envrmt$path_002_processed,"exp_poly.shp"))
poly
crs(poly)
poly<-spTransform(poly,utm)

### Start to develop function

som
poly


