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
pathdir = "repo/src"

#set root folder for uniPC or laptop                                                        #
root_folder = alternativeEnvi(root_folder = "~/edu/Envimaster-Geomorph",                    #
                              alt_env_id = "COMPUTERNAME",                                  #
                              alt_env_value = "PCRZP",                                      #
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           #
#source environment script                                                                  #
source(file.path(root_folder, paste0(pathdir,"/001_setup_geomorph_v1.R")))                                                              
###---------------------------------------------------------------------------------------###
#############################################################################################


# From Stacks and Bricks, Raster Madness

# load artificially layers
slope  <-raster::raster(file.path(envrmt$path_Reaver, "expl_slope.tif"))
aspect <-raster::raster(file.path(envrmt$path_Reaver, "expl_aspect.tif"))
cov_min<-raster::raster(file.path(envrmt$path_Reaver, "expl_cov_min.tif"))
cov_max<-raster::raster(file.path(envrmt$path_Reaver, "expl_cov_max.tif"))
# create brick and stack
stk <- raster::stack(slope,aspect,cov_min,cov_max)
brk <- raster::brick(slope,aspect,cov_min,cov_max)

#brick and stack not idetical with function identical()
identical(stk[[1]],brk[[1]])# not identical, i think due to source

#write out both 
writeRaster(stk,file.path(envrmt$path_tmp,"str.tif"),overwrite = TRUE,NAflag = 0)
writeRaster(brk,file.path(envrmt$path_tmp,"brk.tif"),overwrite = TRUE,NAflag = 0)

# load both
rstk <- raster::stack(file.path(envrmt$path_tmp,"str.tif"))
rbrk <- raster::brick(file.path(envrmt$path_tmp,"brk.tif"))

# check if loaded brick and in memory is idetnical
identical(brk,rbrk)# not idetical i think due to names and source

# write out as .grd
writeRaster(stk,file.path(envrmt$path_tmp,"myStack.grd"), format="raster")
grd <- raster::stack(file.path(envrmt$path_tmp,"myStack.grd"))

plot(grd[[1]])
plot(stk[[1]])
identical(grd[[1]],stk[[1]]) # false but:
plot(grd[[1]]-stk[[1]])# substraction gies to ZERO values, so both have same values

#save and load RDS
saveRDS(stk,file.path(envrmt$path_tmp,"stack_bsp.rds"))
rdsstk <-readRDS(file.path(envrmt$path_tmp,"stack_bsp.rds"))
identical(rdsstk,stk)
######################## best result due to TRUE identical
# end of script
