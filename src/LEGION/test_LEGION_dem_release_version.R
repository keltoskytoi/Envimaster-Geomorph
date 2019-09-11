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
libs = c("link2GI") 
pathdir = "repo/src"

#set root folder for uniPC or laptop                                                        #
root_folder = alternativeEnvi(root_folder = "~/edu/Envimaster-Geomorph",                    #
                              alt_env_id = "COMPUTERNAME",                                  #
                              alt_env_value = "PCRZP",                                      #
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           #
#source environment script                                                                  #
source(file.path(root_folder, paste0(pathdir,"/001_setup_geomorph_withSAGA_v1.R")))                                                              
###---------------------------------------------------------------------------------------###
#############################################################################################

# LEGION_dem Release Version

# load example data
dem <- raster::raster(file.path(envrmt$path_src,"/LEGION/exmpl_dem.tif"))
#set paths
tmp <- envrmt$path_tmp
utm<-"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
################################################################################

################################################################################
#source LEGION dem release
source(file.path(root_folder, file.path(pathdir,"LEGION/LEGION_dem/LEGION_dem_v1.4/LEGION_dem_v1_4.R")))
source(file.path(root_folder, file.path(pathdir,"LEGION/LEGION_dem/LEGION_dem_v1.4/sf_LEGION_dem_v1_4.R")))

################################################################################
#test LEGION_dem release

#test for filters missing, should return stack with unfiltered rasters
test <- LEGION_dem(dem = dem,tmp = tmp,proj = utm)
test
#test for single filter, should return stack with unfiltered rasters and raster with filtertag
testf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=3)
testf

identical(test[[1]],testf[[1]])
testf[[18]] #should be slope_f3

#test for multiple filter, should return stack with unfiltered rasters and rasters with for all filters
testmf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=c(3,5))
testmf

identical(test[[1]],testmf[[1]])
identical(testf[[18]],testmf[[18]])
testmf[[35]] #should be slope_f5

# end of script
