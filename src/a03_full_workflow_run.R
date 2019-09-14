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

### IMPORTANT: First create tmp,tmp1 etc folders in tmp directory
### SAGA version 6.3 suggested for use


#load data
# use dem of aoi
dem <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/dem_mof.tif"))

dem1 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_lahnberge.tif"))
dem2 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_bad_drieburg.tif"))
dem3 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_isabellengrund.tif"))
dem4 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_neu-anspach.tif"))
dem5 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_mof.tif"))

#load som
som <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/som_mof.tif"))

som1 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_small.tif"))
som2 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_small.tif"))
som3 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_small.tif"))
som4 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_small.tif"))
som5 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_mof_small.tif"))

#load polygon

poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"mof_big/seg_mof_big_poly_01_2_02_20_70_1.shp"))

poly1 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_krater_poly.shp"))
poly2 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_driebach_doline_poly.shp"))
poly3 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_isabellengrund_pinge_poly.shp"))
poly4 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_pinge_poly.shp"))
poly5 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_mof_poly.shp"))

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
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_extraction/REAVER_extraction_v1.1/000_Reaver_extraction_v1.1.R")))

#set tmp path ###always clean after one run instead use subfolders 
tmp <- envrmt$path_tmp

#set cluster computing
cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#test for filters missing, should return stack with unfiltered rasters 
#erase previous data from tmp before
tmp <- file.path(envrmt$path_tmp,"tmp")
stck <- LEGION_dem(dem = dem,tmp = tmp,proj = utm)
df<- Reaver_extraction(poly=poly,multilayer=stck,set_ID = TRUE,name="mof_big")

tmp <- file.path(envrmt$path_tmp,"tmp1")
stck1 <- LEGION_dem(dem = dem1,tmp = tmp,proj = utm)
df1<- Reaver_extraction(poly=poly1,multilayer=stck1,set_ID = TRUE,name="lahnberge")

tmp <- file.path(envrmt$path_tmp,"tmp2")
stck2 <- LEGION_dem(dem = dem2,tmp = tmp,proj = utm)
df2<- Reaver_extraction(poly=poly2,multilayer=stck2,set_ID = TRUE,name="bad_drieburg")

tmp <- file.path(envrmt$path_tmp,"tmp3")
stck3 <- LEGION_dem(dem = dem3,tmp = tmp,proj = utm)
df3<- Reaver_extraction(poly=poly3,multilayer=stck3,set_ID = TRUE,name="isabellengrund")

tmp <- file.path(envrmt$path_tmp,"tmp4")
stck4 <- LEGION_dem(dem = dem4,tmp = tmp,proj = utm)
df4<- Reaver_extraction(poly=poly4,multilayer=stck4,set_ID = TRUE,name="neu_anspach")

tmp <- file.path(envrmt$path_tmp,"tmp5")
stck5 <- LEGION_dem(dem = dem5,tmp = tmp,proj = utm)
df5<- Reaver_extraction(poly=poly5,multilayer=stck5,set_ID = TRUE,name="mof")


#stop cluster computing
stopCluster(cl)

#write data
write.table(df,file=file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

write.table(df1,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
write.table(df2,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
write.table(df3,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
write.table(df4,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
write.table(df5,file=file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

#read data
dfn <- read.table(file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

dfn1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
dfn2 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
dfn3 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
dfn4 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
dfn5 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

#save as rds
saveRDS(stck,file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

saveRDS(stck1,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge.rds"))
saveRDS(stck2,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg.rds"))
saveRDS(stck3,file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
saveRDS(stck4,file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
saveRDS(stck5,file.path(envrmt$path_002_processed,"reaver_rds/mof.rds"))

#read rds
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

rdsstk1 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge.rds"))
rdsstk2 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg.rds"))
rdsstk3 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
rdsstk4 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
rdsstk5 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/mof.rds"))
