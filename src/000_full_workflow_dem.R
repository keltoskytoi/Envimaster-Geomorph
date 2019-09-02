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

# Script to run the workflow from a single dem to a dataframe with several single values for each polygone

# ( moin jan, dieses script sollte sauber durchlaufen. Du musst nur in Zeile 31 den Path vom DEM angeben, der 
# Rest sollte passen. bei Zeile 80 mal gucken ob die parameter schon reich. Soll nur polygone erzeugen,
# ist hier noch nicht wichtig ob die auch passen.)


#load data
dem <- raster::raster(file.path(envrmt$path_001_org, "dem_mof_ex.tif")) # use dem of aoi
#set desired CRS
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

###first generate several artifically layers using the LEGION_dem function

#source LEGION 
source(file.path(root_folder, paste0(pathdir,"LEGION/dev_LEGION_dem_v2.R"))) 
source(file.path(root_folder, paste0(pathdir,"LEGION/dev_sf_LEGION_dem.R"))) 

#set filter sizes
fs <- c(1,3,5,9)

#run LEGION_dm_v2
stck <- LEGION_dem_v2(dem    =dem,
                      tmp    =envrmt$path_tmp,
                      proj   =utm,
                      filter =fs)
  
stck #should be a stack containing 56 raster layers (nlayer for the stack)

### compute the polygons using a SOM (sink only elevation model) and CENITH V2 segmentation algorithem

#first generate the SOM

#source CENITH fillsinks (in development folder)
source(file.path(root_folder, paste0(pathdir,"000_dev/cenith_fillsinks.R"))) 

#run CENITH fillsinks

cenith_fillsinks(dem=dem,
                 output=envrmt$path_002_processed,
                 tmp=envrmt$path_tmp,
                 0,
                 proj=utm)

som <- raster::raster(file.path(envrmt$path_002_processed, "som.tif")) 
som # should be a raster with small clusters of cell

#source full CENITH package
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/000_cenith_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_tp_v2.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_tiles.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_merge.R")))
source(file.path(root_folder, file.path(pathdir,"Cenith_V2/cenith_seg_v1.R")))

# run CENITH V2 (the moving window must not be perfect for the test of the full workflow, just need some polygons)
seg <- Cenith(chm=som,a=2, b=1,h=1)

# view result polygone
mapview::mapview(som)+seg$polygon

#write out polygones
writeOGR(seg$polygon,file.path(envrmt$path_002_processed, "poly.shp"),"layername", driver="ESRI Shapefile")

#load polygone layer and set correct CRS ### here ask CR, why it allways changes the towgs84 in utm after loading crs###
poly <-readOGR(file.path(envrmt$path_002_processed,"poly.shp"))
crs(poly)
poly<-spTransform(poly,utm)

### extract Values from the Stack and compute statisics for each polygone using REAVER
#source REAVER
source(file.path(root_folder, file.path(pathdir,"Reaver/dev_000_Reaver_v1_2.R")))

#run REAVER
df<- Reaver(poly=poly,multilayer=stck,set_ID = TRUE,spell=TRUE,stats = TRUE)

#view dataframe, should show rows for the polygones (column"layer"is the ID of the polygons)
#and columns with several values for eg "slo"(slope) "asp" (aspect) for several filtered dems (with "_3" etc)
df

