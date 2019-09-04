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


# test script to check if functions work
#source Cenith Validation V1
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/001_cenith_val.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/sf_cenith_val_b_v1.R")))

#source Cenith Validation V2
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/002_cenith_val_v2.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_a.R")))
source(file.path(root_folder, paste0(pathdir,"Cenith_V2/dev_sf_cenith_val_b_v2.R")))

#source CENITH V2
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/sf_cenith_seg_v1.R"))) 


# load data
chm <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_chm.tif"))
som <- raster::raster(file.path(envrmt$path_Cenith_V2,"exmpl_som.tif"))
vp <-  rgdal::readOGR(file.path(envrmt$path_Cenith_V2,"vp_wrongproj.shp"))
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp) #check if projection is correct

### check if v1 goves same results / detect logical issues ############################################

## run Centih val_v2
v2 <- cenith_val_v2(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=c(9,10,11),vp=vp)


## check if v1 goves same results
v1_9 <- cenith_val(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=9,vp=vp)
v1_10 <- cenith_val(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=10,vp=vp)
v1_11 <- cenith_val(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=11,vp=vp)

#compare automatic
# merge v1 df
v1 <- rbind(v1_9,v1_10,v1_11)
v1
#check if v1 and v2 hitrate are identical
identical(v2[,4],v1[,4])

### result Validation v2 works fine :D

### check how the results can be used to find best moving window #######################################
# run several tests on som
var <- cenith_val_v2(chm=som,f=1,a=c(0.5,0.9),b=c(0.5,0.9),h=c(0.5,0.7),vp=vp)

# plot best hit rate
maxrow <- var[which.max(var$hit),] # search max vale but rturn only 1 value
maxhit <- maxrow$hit
var[which(var$hit==maxhit),] 


### run Segmentation with CENITH V2
# var returns the result that with same height the a and b window returns the same area
# test is to check if the result for CENITH have identical areas
# run Cenith on som
test1 <- Cenith(chm=som,h=0.7,a=0.9,b=0.1)
test2 <- Cenith(chm=som,h=0.7,a=0.5,b=0.5)
test3 <- Cenith(chm=som,h=0.7,a=0.1,b=0.9)

# visual check for overlapping
mapview(test1$polygon)+test2$polygon+test3$polygon
mapview(test3$polygon)+som
#result all 3 test polygons overlap each other so the area is exactly the same

identical(sum(test1$polygon$crownArea),
          sum(test2$polygon$crownArea),
          sum(test3$polygon$crownArea))


#end of script