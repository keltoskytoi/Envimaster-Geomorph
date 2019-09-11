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
libs = c("link2GI","plyr") 
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


# script to Test REAVER functions

# load example data
poly <-rgdal::readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
poly
crs(poly)
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
poly<-spTransform(poly,utm)
crs(poly)

# load artificially layers
slope  <-raster::raster(file.path(envrmt$path_Reaver, "expl_slope.tif"))
aspect <-raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif"))
cov_min<-raster::raster(file.path(envrmt$path_Reaver, "expl_cov_min.tif"))
cov_max<-raster::raster(file.path(envrmt$path_Reaver, "expl_cov_max.tif"))
# create brick
stk <- raster::stack(slope,aspect,cov_min,cov_max)
stk

#source Reaver V1
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_extraction/REAVER_extraction_v1.1/000_Reaver_extraction_v1.1.R")))

###run Reaver V1
df<- Reaver_extraction(poly=poly,multilayer=stk,set_ID = TRUE,name="test")

df

df2<- Reaver_extraction(poly=poly,multilayer=brck,set_ID = TRUE,spell=F,stats = T)
df
df2
#test if spell T anf F path are idetical results
identical(df,df2) # TRUE
