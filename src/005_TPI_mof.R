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

#load data

dem <- raster::raster(file.path(envrmt$path_001_org, "DEM_mof.tif"))


#create hillshade , slope etc

slope <- terrain(dem, opt="slope")
aspect <- terrain(dem, opt='aspect')
tpi <- terrain(dem, opt = 'TPI')
tri <- terrain(dem, opt = 'TRI')
rough <- terrain(dem, opt = 'roughness')
flow <- terrain(dem, opt = 'flowdir')


hill <- hillShade(slope, aspect, 
                  angle=40, 
                  direction=170)

plot(hill,col=grey.colors(100, start=0, end=1),legend=F)

#write raster
writeRaster(slope, filename= file.path(envrmt$path_002_processed, "slope.tif"), format="GTiff", overwrite=TRUE)
writeRaster(aspect, filename= file.path(envrmt$path_002_processed, "aspect.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi, filename= file.path(envrmt$path_002_processed, "tpi.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tri, filename= file.path(envrmt$path_002_processed, "tri.tif"), format="GTiff", overwrite=TRUE)
writeRaster(rough, filename= file.path(envrmt$path_002_processed, "rough.tif"), format="GTiff", overwrite=TRUE)
writeRaster(flow, filename= file.path(envrmt$path_002_processed, "flow.tif"), format="GTiff", overwrite=TRUE)
writeRaster(hill, filename= file.path(envrmt$path_002_processed, "hill.tif"), format="GTiff", overwrite=TRUE)

# TPI for different neighborhood size:

tpiw <- function(x, w=5) {
  m <- matrix(1/(w^2-1), nc=w, nr=w)
  m[ceiling(0.5 * length(m))] <- 0
  f <- focal(x, m)
  x - f
}

#run TPI for different matrix sizes

tpi5 <- tpiw(dem, w=5)
tpi9 <- tpiw(dem, w=9)
tpi31 <- tpiw(dem, w=31)
tpi61 <- tpiw(dem, w=61)
tpi91 <- tpiw(dem, w=91)
tpi131 <- tpiw(dem, w=131)
tpi177 <- tpiw(dem, w=177)
tpi331 <- tpiw(dem, w=331)

#plot tpi's
plot(tpi5,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi9,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi31,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi61,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi91,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi131,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi177,col=grey.colors(100, start=0, end=1),legend=F)
plot(tpi331,col=grey.colors(100, start=0, end=1),legend=F)

#write raster
writeRaster(tpi5, filename= file.path(envrmt$path_002_processed, "tpi5.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi9, filename= file.path(envrmt$path_002_processed, "tpi9.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi31, filename= file.path(envrmt$path_002_processed, "tpi31.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi61, filename= file.path(envrmt$path_002_processed, "tpi61.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi91, filename= file.path(envrmt$path_002_processed, "tpi91.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi131, filename= file.path(envrmt$path_002_processed, "tpi131.tif"), format="GTiff", overwrite=TRUE)
writeRaster(tpi177, filename= file.path(envrmt$path_002_processed, "tpi177.tif"), format="GTiff", overwrite=TRUE)