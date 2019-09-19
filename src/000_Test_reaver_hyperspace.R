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
libs = c("link2GI","vegan","cluster","labdsv") 
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

# Script for workflow dataframes to cluster analysis
utm <- "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
#load data 
df_b <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp")) # bomb
df_p <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp")) # pinge
df_d <-readOGR(file.path(envrmt$path_Reaver,"expl_poly.shp")) # doline



df_m <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

df_b <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
df_pa <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
df_pb <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
df_pc <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
df_da <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
df_db <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
df_dc <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))

#source function
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_hyperspace/REAVER_hyperspace_v1/000_Reaver_hyperspace.R")))

# merge dfs old
df <- rbind(df_b,df_p)
df <- rbind (df,df_d)
df <- rbind (df,df_p1)
df <- rbind (df,df_m)

#merge new areas attempt
df <- rbind(df_b,df_pa)
df <- rbind (df,df_pb)
df <- rbind (df,df_pc)
df <- rbind (df,df_da)
df <- rbind (df,df_db)
df <- rbind (df,df_dc)
df <- rbind (df,df_m)

#eliminate layer column
df <- df[,2:length(df)]

# eliminate negative values
df[] <- lapply(df, abs)
df


# run Reaver hyperspace
test <- Reaver_hyperspace(df,3)
test$hc
test$km

#end of script