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

#source new sf
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_chmseg_clean.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_ft_mcws_clean.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_ft_vwf_clean.R"))) 

#source Cenith Validation V2
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/development/002_cenith_val_v2_1.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/development/002_cenith_val_v2_2.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/development/dev_sf_cenith_val_a_v2.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/development/dev_sf_cenith_val_b_v2_1.R")))

# load data
chm <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_chm.tif"))
som <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_som.tif"))
vp <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"exmpl_vp.shp"))
crs(chm)
crs(som)
crs(vp)
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp) #check if projection is correct

########################################################################################

#test polygon merging ability for validation v2.1


var <- cenith_val_v2_1(chm=som,f=1,a=c(0.5,0.9),b=(0.5),h=c(0.3,0.4,0.5,0.7,0.8,0.9),vp=vp)
var2 <-cenith_val_v2_2(chm=som,f=1,a=c(0.5,0.9),b=(0.5),h=c(0.3,0.4,0.5,0.7,0.8,0.9),vp=vp,min=49,max=80)
var2

