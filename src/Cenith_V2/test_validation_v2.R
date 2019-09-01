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
source(file.path(root_folder, file.path(pathdir,"001_setup_geomorph_v1.R")))                                                              
###---------------------------------------------------------------------------------------###
#############################################################################################


# script to test the Validation V2
# test if the height values are used correcty

#source functions
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/001_cenith_val.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/002_cenith_val_v2.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_a.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_b.R")))

##load data 
chm <- raster::raster(file.path(root_folder, file.path(pathdir,"Cenith_V2/exmpl_chm.tif")))
vp <-  rgdal::readOGR(file.path(root_folder, file.path(pathdir,"Cenith_V2/vp_wrongproj.shp")))
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(chm,vp)  

## run Centih val_v2
v2 <- cenith_val_v2(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=c(8,13),vp=vp)


## check if v1 goves same results
v1_8 <- cenith_val(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=8,vp=vp)
v1_13 <- cenith_val(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=13,vp=vp)

## compare df supervised
v2
v1_8
v1_13

#compare automatic
# merge v1 df
v1 <- rbind(v1_8,v1_13)
v1
#check if v1 and v2 are identical
identical(v2,v1)

### result Validation v2 works fine :D
