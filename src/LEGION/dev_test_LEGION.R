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
libs = c("link2GI","rgdal","plyr") 
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

# script to test and develop the LEGION_dem funcion

#load dem
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_dem.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

test2 <- LEGION_dem2(dem      =dem,
                   tmp      =envrmt$path_tmp,
                   proj     =utm)

test[[1]] # check names
test2[[1]]

identical(test,test2)

par(mfrow=c(2,2))
plot(test$slo)
plot(test$pla)
plot(test$svf)
plot(test$tol)
dev.off()

#filter dev, what ist the typical filter/ diffenreces betwenn sum and mean, what is default. use a dem/raster where differences can be seen
val_chm_dgl
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif")) #aspect was just used to not put in another dem example to the Reaver folder
f=9
dem_m3<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f),fun=mean)
dem_m3

dem_s3<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f),fun=sum)
dem_s3

dem_x<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f))
dem_x

par(mfrow=c(2,2))
plot(dem)
plot(dem_m3)
plot(dem_s3)
plot(dem_x)

identical(dem_x,dem_s3)
# result: use "sum" is default for focal, mean just changes the values but hase same filter result (visuel)