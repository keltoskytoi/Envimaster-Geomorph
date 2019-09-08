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
crs(chm)
crs(som)
crs(vp)
vp <- spTransform(vp,"+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
compareCRS(som,vp) #check if projection is correct

### check if v1 goves same results / detect logical issues ############################################

## run Centih val_v2
v2 <- cenith_val_v2(chm,f=1,a=c(0.04,0.08),b=c(0.2,0.4),h=c(9,10,11),vp=vp)
f3 <- cenith_val_v2(chm,f=3,a=c(0.04,0.08),b=c(0.2,0.4),h=c(9,10,11),vp=vp)
f5 <- cenith_val_v2(chm,f=5,a=c(0.04,0.08),b=c(0.2,0.4),h=c(9,10,11),vp=vp)

f3
maxrow <- var[which.max(var$hit),] # search max vale but rturn only 1 value
maxhit <- maxrow$hit
var[which(var$hit==maxhit),] 
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

var <- v2
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

require(mapview)
mapview(test1$polygon)+som
# visual check for overlapping
mapview(test1$polygon)+test2$polygon+test3$polygon
mapview(test3$polygon)+som

inter <-intersect(test1$polygon,test1$polygon)
class(inter)
mapview(inter)
mapview(test1$polygon)
identical(inter,test1$polygon)

### test to merge
library(sf)
library(sp)
library(rgeos)
clusterSF <- function(sfpolys){
  dmat = st_distance(sfpolys)
  hc = hclust(as.dist(dmat), method="single")
  groups = cutree(hc, h=0.5)
  d = st_sf(
    geom = do.call(c,
                   lapply(1:max(groups), function(g){
                     st_union(sfpolys[groups==g,])
                   })
    )
  )
  d$group = 1:nrow(d)
  d
}
#################################
#perape polygons
polys <- test1$polygon
poly_sf <- st_as_sf(polys)
#poly_sf <- poly_sf_col[,5]
class(poly_sf)
poly_sf

distancematrix <- st_distance(poly_sf)
thresh <-grid::unit(1,"cm")
hc = hclust(as.dist(distancematrix), method="single")

hctests <- clusterSF(poly_sf,1)
###
set.seed(123)
pols  = st_as_sf(
  gBuffer(SpatialPoints(cbind(100*runif(20),100*runif(20))), width=12, byid=TRUE)
)


pc= clusterSF(poly_sf)
plot(pols)
plot(polscluster)
mapview(pc)

pc
class(pols)
class(poly_sf)

class(polscluster)

sp_cluster <- sf:::as_Spatial(pc)

sp_cluster

# test fall: es werden 2 polygone in einem crater gezeigt, die aneinander liegen.
# Function läuft und merge beide, rdy to implenetate to validation algo.
stat <- ForestTools::sp_summarise(vp, sp_cluster)

stat[is.na(stat$TreeCount)] <- 0 # na to 0


pkb <- sum(stat$TreeCount<1) # amount polygon without tree (miss)
pb <- sum(stat$TreeCount==1) # amount polygon with exact 1 tree (hit)
pmb <-sum(stat$TreeCount>1) # amount polygon with more than 1 tree (miss)

hit = pb/length(stat$TreeCount) # calc hit ration in percent (amount of exact trees
over = pkb/length(stat$TreeCount) #calc empty ration in percent (amount of polygon without trees)
under = pmb/length(stat$TreeCount) 

hit
over
under
area <-area(sp_cluster)

### check reuslts building
result <- data.frame(matrix(nrow = 4, ncol = 4))
j=3

result[j, 1] <- a
result[j, 2] <- b[j]
result[j, 3] <- h
result[j, 1] <- hit
result[j, 5] <- ntree_vp
result[j, 2] <- over
result[j, 3] <- area[j]
result[j, 4] <- under

result

#result all 3 test polygons overlap each other so the area is exactly the same

identical(sum(test1$polygon$crownArea),
          sum(test2$polygon$crownArea),
          sum(test3$polygon$crownArea))


#end of script