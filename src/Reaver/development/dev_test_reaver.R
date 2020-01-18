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
libs = c("link2GI","rgdal","plyr") 
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

# script to test the Reaver funcion

#load dem
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_dem.tif"))
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

test <- LEGION_dem(dem      =dem,
                   tmp      =envrmt$path_tmp,
                   proj     =utm)

test[[1]] # check names
par(mfrow=c(2,2))
plot(test$slo)
plot(test$pla)
plot(test$svf)
plot(test$tol)
dev.off()

#run Reaver on new brick
#load data 
poly <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp"))
poly
crs(poly)
poly<-spTransform(poly,utm)

#run
df<- Reaver(poly=poly,multilayer=test,set_ID = TRUE,spell=T,stats = F)
df
df2
#rename df for each operator typ
#subset for eg min

min <-df$df_min
min

colnames(min) <- paste(colnames(min),"test",sep = "_") # works add name to all
min

#this works to change nemae for all columns exclude "layer"
min <-df$df_min
min
colnames(min)[2:length(min)] <- paste(colnames(min)[2:length(min)],"min",sep = "_")
min

max <-df$df_max
max
colnames(max)[2:length(max)] <- paste(colnames(max)[2:length(max)],"max",sep = "_")
max

sum <-df$df_sum
sum
colnames(sum)[2:length(sum)] <- paste(colnames(sum)[2:length(sum)],"sum",sep = "_")
sum

#merge df by layer to get all the articically layer values in colums for each polygon (layer)
merg <- merge(min,max,by="layer")
merg
merg <- merge(merg,sum,by="layer")
merg
#test if values are correct
max$slo_max
sum$sim_sum
merg$slo_max
merg$sim_sum
#works

f=3
dem2 <- raster::focal(dem,w=matrix(1/(f),nrow=f,ncol=f))
test2 <- LEGION_dem(dem      =dem2,
                   tmp      =envrmt$path_tmp,
                   proj     =utm)

df2<- Reaver(poly=poly,multilayer=test2,set_ID = TRUE,spell=T,stats = T)
df2$df_mean

f=5
dem3 <- raster::focal(dem,w=matrix(1/(f),nrow=f,ncol=f))
test3 <- LEGION_dem(dem      =dem3,
                    tmp      =envrmt$path_tmp,
                    proj     =utm)

df3<- Reaver(poly=poly,multilayer=test3,set_ID = TRUE,spell=T,stats = T)
df3$df_mean
