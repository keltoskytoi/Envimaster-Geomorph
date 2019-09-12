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
libs = c("link2GI","ForestTools","uavRst","sf","sp","rgeos","rgdal","mapview","doParallel","parallel") 
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
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_small.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"points/lahnberge_vp.shp"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_small.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"points/bad_drieburg_vp.shp"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_small.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"points/isabellengrund_vp.shp"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_small.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"points/neu_anspach_vp.shp"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_mof_small.tif"))
vp_som <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"points/mof_vp.shp"))

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

hollow <- cenith_hollow(som=som,a=2,b=2,h=0.1,min=4,max=1000,f=1)
hollow
mapview(hollow)+vp_som

################################################################################
#source CENITH hollow validation v1 
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/000_cenith_hollow_val_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/sf_cenith_hollow_val_a_v1.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/CENITH_hollow_val/CENITH_hollow_val_V1/sf_cenith_hollow_val_b_v1.R")))

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

valh <- cenith_hollow_val(chm=som,f=1,a=c(0.1,0,2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),
                          b=c(0.01,0,02,0.03,0.04,0.05,0.06,0.07,0.08,0.09),
                          h=c(0.1,0.2,0.3,0.4,0.5),vp=vp_som,min=4,max=1000)

stopCluster(cl)

valh
maxrow <- valh[which.max(valh$hit),] # search max vale but rturn only 1 value
maxhit <- maxrow$hit
valh[which(valh$hit==maxhit),] 
################################################################################
# view polygons with validation values
hol <- cenith_hollow(som=som,a=0.05,b=0.05,h=0.45,min=3,max=100,f=1)
hol
plot(hol)
mapview(hol)+som

#write data
writeOGR(obj=hollow,dsn= file.path(envrmt$path_002_processed, "seg_lahnberge_krater_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=hollow,dsn= file.path(envrmt$path_002_processed, "seg_bad_driebach_doline_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=hollow,dsn= file.path(envrmt$path_002_processed, "seg_isabellengrund_pinge_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=hollow,dsn= file.path(envrmt$path_002_processed, "seg_neu_anspach_pinge_poly.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(obj=hollow,dsn= file.path(envrmt$path_002_processed, "seg_mof_poly.shp"),layer="testShape",driver="ESRI Shapefile")


#end of script
 
#lahnberge bombenkrater
#cenith_hollow(som=som,a=2,b=2,h=0.1,min=4,max=1000,f=1)

#bad drieburg dolinen
#cenith_hollow(som=som,a=0.1,b=0.01,h=0.1,min=8,max=1000,f=1)

#isabellengrund pingen
#cenith_hollow(som=som,a=0.1,b=0.01,h=0.1,min=8,max=1000,f=1)

#neu anspach pingen
#cenith_hollow(som=som,a=0.1,b=0.01,h=0.1,min=3,max=1000,f=1)

#mof ?
#cenith_hollow(som=som,a=0.1,b=0.01,h=0.1,min=3,max=1000,f=1)
