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
libs = c("link2GI","ForestTools","uavRst","sf","sp","rgeos") 
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

# CENITH DEVELOPMENT script to develop and test CENITH functions
# to ensure that no wrong subfunctions are loaded: clean workspace for every test

# load example data
chm <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_chm.tif"))
som <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_som.tif"))
vp_chm <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"exmpl_vp_chm.shp"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"exmpl_vp_som.shp"))
crs(chm)
crs(som)
crs(vp_chm)
crs(vp_som)
vp_chm <- spTransform(vp_chm,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
vp_som <- spTransform(vp_som,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp_som) #check if projection is correct
compareCRS(chm,vp_chm) #check if projection is correct
########################################################################################
#source CENITH validation V1 basic validation a,b
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V1/001_cenith_val_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V1/sf_cenith_val_b_v1.R")))

#test CENITH validation V1
val1 <- cenith_val(chm=chm,f=1,a=c(0.04,0.08),b=c(0.01,0.09),13,vp=vp_chm)
val1
val1[which.max(val1$hitrate),]

################################################################################
#source CENITH validation V2.0 validation a,b and h
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2/002_cenith_val_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2/sf_cenith_val_a.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2/sf_cenith_val_b_v1.R")))

#test CENITH validation V2.0
val2 <- cenith_val_v2(chm=chm,f=1,a=c(0.04,0.08),b=c(0.01,0.09),h=c(8,13),vp=vp_chm)
val2
val2[which.max(val2$hit),]

################################################################################

#source CENITH validation V2.1 validation a,b and h with more results
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2.1/002_cenith_val_v2_1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2.1/sf_cenith_val_a_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_validation/CENITH_validation_V2.1/sf_cenith_val_b_v2.R")))

#test CENITH validation V2.1
val21 <- cenith_val_v2_1(chm=chm,f=1,a=c(0.04,0.08),b=c(0.01,0.09),h=c(8,13),vp=vp_chm)
val21
maxrow <- val21[which.max(val21$hit),] # search max vale but rturn only 1 value
maxhit <- maxrow$hit
val21[which(val21$hit==maxhit),] 

################################################################################

