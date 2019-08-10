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
libs = c("link2GI","rgdal") 
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

# script to compute several layers for example data

#load dem and compute sink only dem (som)
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_dem.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

source(file.path(root_folder, paste0(pathdir,"000_dev/cenith_fillsinks.R"))) 
cenith_fillsinks(dem      =dem,
                 output   =envrmt$path_Reaver,
                 tmp      =envrmt$path_tmp,
                 minslope =0,
                 proj     =utm)

som <- raster::raster(file.path(envrmt$path_Reaver, "som.tif"))
plot(som)
# run Cenith segmentation to compute polygons for example extraction
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_v1.R")))

expl_seg <- Cenith(chm=som,a=0.8,b=2,h=1,f=1)
plot(expl_seg$polygon)
crs(expl_seg$polygon)

# view result polygone and write to shp
mapview::mapview(som)+expl_seg$polygon
writeOGR(expl_seg$polygon,file.path(envrmt$path_Reaver, "expl_poly.shp"),"layername", driver="ESRI Shapefile")


# compute artificially layers as predictors
source(file.path(root_folder, paste0(pathdir,"000_dev/morphmetric.R"))) 
morphmetric(dem      =dem,
            output   =envrmt$path_Reaver,
            tmp      =envrmt$path_tmp,
            proj     =utm,
            method   =6)


#load polygone layer and set correct CRS ### here ask CR, wh it allways changes the towgs84 in utm crs###
poly <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
poly
crs(poly)
poly<-spTransform(poly,utm)

# load artificially layers
slope <-raster::raster(file.path(envrmt$path_Reaver, "expl_slope.tif"))
aspect<-raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif"))

### Start to develop function
par(mfrow=c(2,2))
plot(poly)
plot(slope)
plot(aspect)
dev.off()

#brick layers
anotherbrick <-raster::brick(slope,aspect)
anotherbrick
names(anotherbrick)
#add id
poly$ID=seq(1,2,1)


#rasterize polygone layer
rasterz<- rasterize(poly, anotherbrick, field="ID")
rasterz

#mask raster with cells from polygones for all layers
predator <- mask(anotherbrick, rasterz)
plot(predator)

#add the rasterizes Polygone layer to add the ID for the table
predator_bricked <- addLayer(predator, rasterz)
plot(predator_bricked)

#extract the values, clean NA and get dataframe
getval <- getValues(predator_bricked)

values<- na.omit(getval)
values_clean<- as.data.frame(values)
values_clean

names(values_clean)
