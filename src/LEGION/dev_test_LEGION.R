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

# script to test and develop the LEGION_dem funcion

#load dem
demx <- raster::raster(file.path(envrmt$path_Reaver, "expl_dem.tif"))
xutm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

# test legion dem version 2
source(file.path(root_folder, paste0(pathdir,"LEGION/dev_sf_LEGION_dem.R"))) 

lvx <- LEGION_dem_v2(dem     =dem_x,
                     tmp      =envrmt$path_tmp,
                     proj     =xutm,
                     filter=c(1)
)

lvx[[18]]
lv2[[18]]

test1
test1 <- LEGION_dem2(dem     =dem,
                   tmp      =envrmt$path_tmp,
                   proj     =utm,
                   f=1)

testorg <-LEGION_dem(dem     =dem,
                    tmp      =envrmt$path_tmp,
                    proj     =utm
                    )


test1
testorg
test1[[1]] # check names
testorg[[1]]



#check idetical, calls false but substracted there is zero so they are the same values in it
identical(test1$slope_f1,testorg$slo)
ni <-test1$slope_f1-testorg$slo
plot(ni)

test3 <- LEGION_dem2(dem     =dem,
                     tmp      =envrmt$path_tmp,
                     proj     =utm,
                     f=9)

test3


par(mfrow=c(2,2))
plot(test1$slope_f1)
plot(lv2$slope_f1)
plot(test$svf_f1)
plot(test3$svf_f9)

plot(test$tol)
dev.off()
# combine 2 bricks
test1[[1]]
test3
tb <-stack(test1,test3)
tb[[1]]

ts <-stack(test1)
ts
ts <-stack(tb,test3)
ts
#test reaver with stack
df<- Reaver(poly=poly,multilayer=tb,set_ID = TRUE,spell=T,stats = T)
df[2]
df2<- Reaver(poly=poly,multilayer=test1,set_ID = TRUE,spell=T,stats = T)
df2[2]

#test lapply

testfun <-function(filter){
  lapply(filter, function(i){
    test <-LEGION_dem2(dem      =dem,
                       tmp      =envrmt$path_tmp,
                       proj     =utm,
                       f=i)
  })
}
filter=c(1,3,5)
test <- testfun(filter=filter)
test[[1]]
identical(test[[1]],test1)

# test demv1_3 filter fun
tf5 <- LEGION_dem3(dem     =dem,
                     tmp      =envrmt$path_tmp,
                     proj     =utm,
                     filter=c(1,3,5))
tf5
identical(tfs[[1]],test1)

class(tfs)
class(tfs[[1]])
#filter dev, what ist the typical filter/ diffenreces betwenn sum and mean, what is default. use a dem/raster where differences can be seen
val_chm_dgl
dem <- raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif")) #aspect was just used to not put in another dem example to the Reaver folder
f=9
dem_m3<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f),fun=mean)
dem_m3

dem_s3<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f),fun=sum)
dem_s3

dem_x<-raster::focal(dem,w=matrix(1/(f*f),nrow=f,ncol=f))
dem_x

par(mfrow=c(2,2))
plot(dem)
plot(dem_m3)
plot(dem_s3)
plot(dem_x)

identical(dem_x,dem_s3)
# result: use "sum" is default for focal, mean just changes the values but hase same filter result (visuel)