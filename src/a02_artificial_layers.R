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
libs = c("link2GI","plyr","rgeos","rgdal","mapview","doParallel","parallel") 
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

#IMPORTANT
#erase previous data from tmp before

#load data
 # use dem of aoi
dem <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/dem_mof.tif"))

dem <- raster::raster(file.path(envrmt$path_001_org, "dem_small_lahnberge.tif"))
dem <- raster::raster(file.path(envrmt$path_001_org, "dem_small_bad_drieburg.tif"))
dem <- raster::raster(file.path(envrmt$path_001_org, "dem_small_isabellengrund.tif"))
dem <- raster::raster(file.path(envrmt$path_001_org, "dem_small_neu_anspach.tif"))
dem <- raster::raster(file.path(envrmt$path_001_org, "dem_small_mof.tif"))

#load som
som <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/som_mof.tif"))

som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_small.tif"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_small.tif"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_small.tif"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_small.tif"))
som <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_mof_small.tif"))

 #load polygon

poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"mof_big/seg_mof_big_poly_01_2_02_20_70_1.shp"))

poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_krater_poly.shp"))
poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_driebach_doline_poly.shp"))
poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_isabellengrund_pinge_poly.shp"))
poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_pinge_poly.shp"))
poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_mof_poly.shp"))
#set desired CRS
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
#check if projection is correct
crs(dem)
crs(som)
crs(poly)
som <- spTransform(som,utm)
compareCRS(dem,som)
poly <- spTransform(poly,utm)
compareCRS(dem,poly)
plot(dem)
plot(som)
plot(poly)
###first generate several artifically layers using the LEGION_dem function

#source LEGION 
source(file.path(root_folder, file.path(pathdir,"LEGION/LEGION_dem/LEGION_dem_v1.4/LEGION_dem_v1_4.R")))
source(file.path(root_folder, file.path(pathdir,"LEGION/LEGION_dem/LEGION_dem_v1.4/sf_LEGION_dem_v1_4.R")))

#set tmp path
tmp <- envrmt$path_tmp

#set cluster computing
cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#test for filters missing, should return stack with unfiltered rasters 
#erase previous data from tmp before
stck <- LEGION_dem(dem = dem,tmp = tmp,proj = utm)
stck

#test for single filter, should return stack with unfiltered rasters and raster with filtertag ###filter not working
stckf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=3)
#stckf

plot(stckf$slope)

#stop cluster computing
stopCluster(cl)

identical(stck[[1]],stckf[[1]])
testf[[18]] #should be slope_f3

#test for multiple filter, should return stack with unfiltered rasters and rasters with for all filters
stckmf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=c(3,5))
stckmf

identical(stck[[1]],stckmf[[1]])
identical(stckf[[18]],stckmf[[18]])
stckmf[[35]] #should be slope_f5

### compute the polygons using a SOM (sink only elevation model) and CENITH V2 segmentation algorithem

### extract Values from the Stack and compute statisics for each polygone using REAVER
#source Reaver V1
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_extraction/REAVER_extraction_v1.1/000_Reaver_extraction_v1.1.R")))

df<- Reaver_extraction(poly=poly,multilayer=stck,set_ID = TRUE,name="mof")

df

#write data
write.table(df,file=file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

write.table(df,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
write.table(df,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
write.table(df,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
write.table(df,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
write.table(df,file=file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

#read data
df1 <- read.table(file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

df1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
df1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
df1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
df1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
df1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

#save as rds
saveRDS(stck,file.path(path_002_processed,"mof_big/mof.rds"))

saveRDS(stck,file.path(envrmt$path_002_processed,"lahnberge.rds"))
saveRDS(stck,file.path(envrmt$path_002_processed,"bad_drieburg.rds"))
saveRDS(stck,file.path(envrmt$path_002_processed,"isabellengrund.rds"))
saveRDS(stck,file.path(envrmt$path_002_processed,"neu_anspach.rds"))
saveRDS(stck,file.path(envrmt$path_002_processed,"mof.rds"))

#read rds
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

rdsstk <-readRDS(file.path(envrmt$path_002_processed,"lahnberge.rds"))
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"bad_drieburg.rds"))
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"isabellengrund.rds"))
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"neu_anspach.rds"))
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"mof.rds"))