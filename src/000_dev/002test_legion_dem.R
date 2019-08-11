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

#load dem
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_dem.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

test <- LEGION_dem(dem      =dem,
                   tmp      =envrmt$path_tmp,
                   proj     =utm)

par(mfrow=c(2,2))
plot(test$slo)
plot(test$pla)
plot(test$svf)
plot(test$tol)
dev.off()

#run Reaver on new brick
#load data 
poly <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
poly
crs(poly)
poly<-spTransform(poly,utm)

#run
df<- Reaver(poly=poly,multilayer=test,set_ID = TRUE,spell=T,stats = T)
df$df_mean
