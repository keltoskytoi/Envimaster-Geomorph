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


dem6 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative.tif"))
dem7 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative1.tif"))
dem8 <- raster::raster(file.path(envrmt$path_001_org, "dem_bad_drieburg_alternative2.tif"))
dem9 <- raster::raster(file.path(envrmt$path_001_org, "dem_neu_anspach_alternative.tif"))
dem10 <- raster::raster(file.path(envrmt$path_001_org, "dem_lahnberge_alternative.tif"))
dem11 <- raster::raster(file.path(envrmt$path_001_org, "isabellengrund_new.tif"))

#load som
som <- raster::raster(file.path(envrmt$path_002_processed, "mof_big/som_mof.tif"))

som1 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_small.tif"))
som2 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_small.tif"))
som3 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_small.tif"))
som4 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_small.tif"))


som6 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt.tif"))
som7 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt1.tif"))
som8 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_bad_drieburg_alt2.tif"))
som9 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_neu_anspach_alt.tif"))
som10 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_lahnberge_alt.tif"))
som11 <- raster::raster(file.path(envrmt$path_002_processed, "som_small/som_isabellengrund_new.tif"))

#load polygon

poly <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"mof_big/seg_mof_big_poly_01_2_02_20_70_1.shp"))

poly1 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_krater_poly.shp"))
poly2 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_driebach_doline_poly.shp"))
poly3 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_isabellengrund_pinge_poly.shp"))
poly4 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_pinge_poly.shp"))


poly6 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt_poly.shp"))
poly7 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt1_poly.shp"))
poly8 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_bad_drieburg_alt2_poly.shp"))
poly9 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_neu_anspach_alt_poly.shp"))
poly10 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_lahnberge_alt_poly.shp"))
poly11 <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"poly/seg_isabellengrund_poly_new.shp"))

mapview(poly4)

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
plot(dem11)
plot(som11)
plot(poly11)
mapview(poly1)+dem1
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


#erase previous data from tmp before
tmp <- file.path(envrmt$path_tmp,"tmp")
stck <- LEGION_dem(dem = dem,tmp = tmp,proj = utm, units = 0)
df<- Reaver_extraction(poly=poly,multilayer=stck,set_ID = FALSE,name="test_mof")



tmp <- file.path(envrmt$path_tmp,"tmp3")
stck3 <- LEGION_dem(dem = dem3,tmp = tmp,proj = utm, units = 0)
df3<- Reaver_extraction(poly=poly3,multilayer=stck3,set_ID = TRUE,name="pinge_a")

tmp <- file.path(envrmt$path_tmp,"tmp4")
stck4 <- LEGION_dem(dem = dem4,tmp = tmp,proj = utm, units = 0)
df4<- Reaver_extraction(poly=poly4,multilayer=stck4,set_ID = TRUE,name="pinge_b")

tmp <- file.path(envrmt$path_tmp,"tmp9")
stck9 <- LEGION_dem(dem = dem9,tmp = tmp,proj = utm, units = 0)
df9<- Reaver_extraction(poly=poly9,multilayer=stck9,set_ID = TRUE,name="pinge_c")

#alternative areas
tmp <- file.path(envrmt$path_tmp,"tmp6")
stck6 <- LEGION_dem(dem = dem6,tmp = tmp,proj = utm, units = 0)
df6<- Reaver_extraction(poly=poly6,multilayer=stck6,set_ID = TRUE,name="doline_a")

tmp <- file.path(envrmt$path_tmp,"tmp7")
stck7 <- LEGION_dem(dem = dem7,tmp = tmp,proj = utm, units = 0)
df7<- Reaver_extraction(poly=poly7,multilayer=stck7,set_ID = TRUE,name="doline_b")

tmp <- file.path(envrmt$path_tmp,"tmp8")
stck8 <- LEGION_dem(dem = dem8,tmp = tmp,proj = utm, units = 0)
df8<- Reaver_extraction(poly=poly8,multilayer=stck8,set_ID = TRUE,name="doline_c")

tmp <- file.path(envrmt$path_tmp,"tmp10")
stck10 <- LEGION_dem(dem = dem10,tmp = tmp,proj = utm, units = 0)
df10<- Reaver_extraction(poly=poly10,multilayer=stck10,set_ID = TRUE,name="krater_a")




####test layers

######## test layer krater
tmp <- file.path(envrmt$path_tmp,"tmp11")
stck11 <- LEGION_dem(dem = dem1,tmp = tmp,proj = utm, units = 0)
df11<- Reaver_extraction(poly=poly1,multilayer=stck11,set_ID = TRUE,name="test_k")

######### test layer dolinen
tmp <- file.path(envrmt$path_tmp,"tmp2")
stck2 <- LEGION_dem(dem = dem2,tmp = tmp,proj = utm, units = 0)
df2<- Reaver_extraction(poly=poly2,multilayer=stck2,set_ID = TRUE,name="test_d")

######### test layer pingen
tmp <- file.path(envrmt$path_tmp,"tmp1")
stck12 <- LEGION_dem(dem = dem11,tmp = tmp,proj = utm, units = 0)
df12<- Reaver_extraction(poly=poly11,multilayer=stck12,set_ID = TRUE,name="test_p")

mapview(poly2)+som2
mapview(poly1)+som1
mapview(poly11)+som11

### add testdat to traindat (optional)
tmp <- file.path(envrmt$path_tmp,"tmp11")
stck11 <- LEGION_dem(dem = dem1,tmp = tmp,proj = utm, units = 0)
df11<- Reaver_extraction(poly=poly11,multilayer=stck11,set_ID = TRUE,name="krater_b")

tmp <- file.path(envrmt$path_tmp,"tmp2")
stck2 <- LEGION_dem(dem = dem2,tmp = tmp,proj = utm, units = 0)
df2<- Reaver_extraction(poly=poly2,multilayer=stck2,set_ID = TRUE,name="doline_d")

tmp <- file.path(envrmt$path_tmp,"tmp1")
stck12 <- LEGION_dem(dem = dem11,tmp = tmp,proj = utm, units = 0)
df12<- Reaver_extraction(poly=poly11,multilayer=stck12,set_ID = TRUE,name="pinge_d")


#stop cluster computing
stopCluster(cl)

#write data

#mof
write.table(df,file=file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

#train
write.table(df3,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
write.table(df4,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
write.table(df6,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
write.table(df7,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
write.table(df8,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))
write.table(df9,file=file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
write.table(df10,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_a.csv"))

#test
write.table(df11,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_test.csv"))
write.table(df2,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_test.csv"))
write.table(df12,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund_test.csv"))

# added testdate named class_d
write.table(df11,file=file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_test.csv"))
write.table(df2,file=file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_test.csv"))
write.table(df12,file=file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund_test.csv"))

#read data

#mof
dfn <- read.table(file.path(envrmt$path_002_processed,"mof_big/mof.csv"))

#train
dfn3 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
dfn4 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
dfn6 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
dfn7 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
dfn8 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))
dfn9 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
dfn10 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_a.csv"))

#test
dfn11 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_test.csv"))
dfn2 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_test.csv"))
dfn12 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/Isabellengrund_test.csv"))

# added testdate named class_d
dfn11 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_test.csv"))
dfn2 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_test.csv"))
dfn12 <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/Isabellengrund_test.csv"))

#save as rds

#mof
saveRDS(stck,file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

#train
saveRDS(stck3,file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
saveRDS(stck4,file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
saveRDS(stck6,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_a.rds"))
saveRDS(stck7,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_b.rds"))
saveRDS(stck8,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_c.rds"))
saveRDS(stck9,file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach_a.rds"))
saveRDS(stck10,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_a.rds"))

#test
saveRDS(stck11,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_test.rds"))
saveRDS(stck2,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_test.rds"))
saveRDS(stck12,file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund_test.rds"))

# added testdate named class_d
saveRDS(stck11,file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_test.rds"))
saveRDS(stck2,file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_test.rds"))
saveRDS(stck12,file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund_test.rds"))

#read rds

#mof
rdsstk <-readRDS(file.path(envrmt$path_002_processed,"mof_big/mof.rds"))

#train
rdsstk3 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund.rds"))
rdsstk4 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach.rds"))
rdsstk6 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_a.rds"))
rdsstk7 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_b.rds"))
rdsstk8 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_c.rds"))
rdsstk9 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/neu_anspach_a.rds"))
rdsstk10 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_a.rds"))

#test
rdsstk11 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_test.rds"))
rdsstk2 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_test.rds"))
rdsstk12 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund_test.rds"))

# added testdate named class_d
rdsstk11 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/lahnberge_test.rds"))
rdsstk2 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/bad_drieburg_test.rds"))
rdsstk12 <-readRDS(file.path(envrmt$path_002_processed,"reaver_rds/isabellengrund_test.rds"))
