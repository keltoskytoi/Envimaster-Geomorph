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

#load data
 # use dem of aoi
dem <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/dem_mof.tif"))

dem1 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_lahnberge.tif"))
dem2 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_bad_drieburg.tif"))
dem3 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_isabellengrund.tif"))
dem4 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_neu-anspach.tif"))
dem5 <- raster::raster(file.path(envrmt$path_001_org, "dem_small_mof.tif"))

dem6 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative.tif"))
dem7 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative1.tif"))
dem8 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative2.tif"))
dem9 <- raster::raster(file.path(envrmt$path_001_org, "dem_neu_anspach_alternative.tif"))
dem10 <- raster::raster(file.path(envrmt$path_001_org, "dem_lahnberge_alternative.tif"))


#load som
som <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/som_mof.tif"))

som1 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_small.tif"))
som2 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_small.tif"))
som3 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_small.tif"))
som4 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_small.tif"))
som5 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_mof_small.tif"))

som6 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt.tif"))
som7 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt1.tif"))
som8 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt2.tif"))
som9 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_alt.tif"))
som10 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_alt.tif"))


 #load polygon

poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"mof_big/seg_mof_big_poly_01_2_02_20_70_1.shp"))

poly1 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_krater_poly.shp"))
poly2 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_driebach_doline_poly.shp"))
poly3 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_isabellengrund_pinge_poly.shp"))
poly4 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_pinge_poly.shp"))
poly5 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_mof_poly.shp"))

poly6 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt_poly.shp"))
poly7 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt1_poly.shp"))
poly8 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt2_poly.shp"))
poly9 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_alt_poly.shp"))
poly10 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_alt_poly.shp"))


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

#set tmp path ###always clean after one run instead use subfolders 
tmp <- envrmt$path_tmp

#set cluster computing
cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#test for filters missing, should return stack with unfiltered rasters 
#erase previous data from tmp before
stck <- LEGION_dem(dem = dem,tmp = tmp,proj = utm)

stck1 <- LEGION_dem(dem = dem1,tmp = tmp,proj = utm)
stck2 <- LEGION_dem(dem = dem2,tmp = tmp,proj = utm)
stck3 <- LEGION_dem(dem = dem3,tmp = tmp,proj = utm)
stck4 <- LEGION_dem(dem = dem4,tmp = tmp,proj = utm)
stck5 <- LEGION_dem(dem = dem5,tmp = tmp,proj = utm)

stck6 <- LEGION_dem(dem = dem6,tmp = tmp,proj = utm)
stck7 <- LEGION_dem(dem = dem7,tmp = tmp,proj = utm)
stck8 <- LEGION_dem(dem = dem8,tmp = tmp,proj = utm)
stck9 <- LEGION_dem(dem = dem9,tmp = tmp,proj = utm)
stck10 <- LEGION_dem(dem = dem10,tmp = tmp,proj = utm)


plot(stck1$aspect)
#stck

#test for single filter, should return stack with unfiltered rasters and raster with filtertag 
#stckf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=3)
#stckf

#plot(stck$slope)

#test
#identical(stck[[1]],stckf[[1]])
#testf[[18]] #should be slope_f3

#test for multiple filter, should return stack with unfiltered rasters and rasters with for all filters
#stckmf <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, filter=c(3,5))
#stckmf

#identical(stck[[1]],stckmf[[1]])
#identical(stckf[[18]],stckmf[[18]])
#stckmf[[35]] #should be slope_f5

### compute the polygons using a SOM (sink only elevation model) and CENITH V2 segmentation algorithem

### extract Values from the Stack and compute statisics for each polygone using REAVER
#source Reaver V1
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_extraction/REAVER_extraction_v1.1/000_Reaver_extraction_v1.1.R")))

df<- Reaver_extraction(poly=poly,multilayer=stck,set_ID = TRUE,name="mof_big")

df1<- Reaver_extraction(poly=poly1,multilayer=stck1,set_ID = TRUE,name="lahnberge")
df2<- Reaver_extraction(poly=poly2,multilayer=stck2,set_ID = TRUE,name="bad_drieburg")
df3<- Reaver_extraction(poly=poly3,multilayer=stck3,set_ID = TRUE,name="isabellengrund")
df4<- Reaver_extraction(poly=poly4,multilayer=stck4,set_ID = TRUE,name="neu_anspach")
df5<- Reaver_extraction(poly=poly5,multilayer=stck5,set_ID = TRUE,name="mof")

df6<- Reaver_extraction(poly=poly6,multilayer=stck6,set_ID = TRUE,name="bad_drieburg_a")
df7<- Reaver_extraction(poly=poly7,multilayer=stck7,set_ID = TRUE,name="bad_drieburg_b")
df8<- Reaver_extraction(poly=poly8,multilayer=stck8,set_ID = TRUE,name="bad_drieburg_c")
df9<- Reaver_extraction(poly=poly9,multilayer=stck9,set_ID = TRUE,name="neu_anspach_a")
df10<- Reaver_extraction(poly=poly10,multilayer=stck10,set_ID = TRUE,name="lahnberge_a")

#df

#stop cluster computing
stopCluster(cl)

#write data
write.table(df,file=file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

write.table(df1,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
write.table(df2,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
write.table(df3,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
write.table(df4,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
write.table(df5,file=file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

write.table(df6,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
write.table(df7,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
write.table(df8,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))
write.table(df9,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
write.table(df10,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_a.csv"))


#read data
dfn <- read.table(file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

dfn1 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
dfn2 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
dfn3 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
dfn4 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
dfn5 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

dfn6 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
dfn7 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
dfn8 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))
dfn9 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
dfn10 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_a.csv"))


#save as rds
saveRDS(stck,file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

saveRDS(stck1,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge.rds"))
saveRDS(stck2,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg.rds"))
saveRDS(stck3,file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
saveRDS(stck4,file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
saveRDS(stck5,file.path(envrmt$path_002_processed,"reaver_rds/mof.rds"))

saveRDS(stck6,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_a.rds"))
saveRDS(stck7,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_b.rds"))
saveRDS(stck8,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_c.rds"))
saveRDS(stck9,file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach_a.rds"))
saveRDS(stck10,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_a.rds"))


#read rds
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

rdsstk1 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge.rds"))
rdsstk2 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg.rds"))
rdsstk3 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
rdsstk4 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
rdsstk5 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/mof.rds"))

rdsstk6 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_a.rds"))
rdsstk7 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_b.rds"))
rdsstk8 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_c.rds"))
rdsstk9 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach_a.rds"))
rdsstk10 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_a.rds"))
