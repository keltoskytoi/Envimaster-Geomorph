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
libs = c("link2GI","ForestTools","uavRst","sf","sp","rgeos","mapview") 
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


# load example data
som <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_som.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"exmpl_vp_som.shp"))
crs(som)
crs(vp_som)
vp_som <- spTransform(vp_som,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp_som) #check if projection is correct
################################################################################
#source CENITH hollow v1 
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow/CENITH_hollow_V1/000_Cenith_hollow_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow/CENITH_hollow_V1/sf_chmseg_clean.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow/CENITH_hollow_V1/sf_ft_mcws_clean.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow/CENITH_hollow_V1/sf_ft_vwf_clean.R")))
################################################################################
#test CENITH hollow v1 

hollow <- cenith_hollow(som=som,a=0.5,b=0.5,h=0.5,min=15,max=35,f=1)
hollow
mapview(hollow)+som

################################################################################
#source CENITH hollow validation v1 
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/000_cenith_hollow_val_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/sf_cenith_hollow_val_a_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/sf_cenith_hollow_val_b_v1.R")))

valh <- cenith_hollow_val(chm=som,f=1,a=c(0.04,0.08),b=c(0.01,0.09),h=c(0.1,0.5,0.9),vp=vp_som,min=0,max=100)
valh
maxrow <- valh[which.max(valh$hit),] # search max vale but rturn only 1 value
maxhit <- maxrow$hit
valh[which(valh$hit==maxhit),] 
################################################################################
# view polygons with validation values
hol <- cenith_hollow(som=som,a=0.04,b=0.01,h=0.5,min=0,max=100,f=1)
hol
plot(hol)
mapview(hol)+som
#end of script
 