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
libs = c("link2GI","vegan","cluster","labdsv","rgdal","stringr") 
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
# test and documentat several ordination runs wit reducing df or selecting high indicator parameters

#source function
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_hyperspace/REAVER_hyperspace_v1.1/000_Reaver_hyperspace_v1_1.R")))

#############################################################################
# selcet cols

#select col by name

#mof layersdf_mb <- read.table(file.path(envrmt$path_002_processed,"mof_big/mof.csv"))
df_m <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))

#test layers
df_dt <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_test.csv"))
df_bt <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_test.csv"))

#train layers
df_b <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge_a.csv"))
df_pa <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
df_pb <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
df_pc <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach_a.csv"))
df_da <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_a.csv"))
df_db <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_b.csv"))
df_dc <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg_c.csv"))


# merge dfs
df <- rbind(df_b,df_pa)
df <- rbind (df,df_pb)
df <- rbind (df,df_pc)
df <- rbind (df,df_da)
df <- rbind (df,df_db)
df <- rbind (df,df_dc)

#test layers
df <- rbind (df,df_bt)
df <- rbind (df,df_dt)


df <- rbind (df,df_mb)

df <- rbind (df,df_m)

# eliminate negative values and layer column
df[] <- lapply(df, abs)
df <- df[,2:length(df)]

#select col by name
# only slope
dfslo <-df[,which(str_count(colnames(df),pattern = "slop")==1)]

#get col position for multiple cols
slo <-which(str_count(colnames(df),pattern = "slop")==1)
asp <-which(str_count(colnames(df),pattern = "asp")==1)
c <- c(slo,asp)
#only slope and aspect
dfsa <-df[,c]

# all col with sd
sd <-which(str_count(colnames(df),pattern = "sd")==1)
dfsd <- df[,sd]

max <- which(str_count(colnames(df),pattern = "max")==1)
dfmax <-df[,max]
rm(df)


#run



# run Reaver hyperspace
test <- Reaver_hyperspace(df,indi=T)

#get col position for multiple cols
asp_min <-which(str_count(colnames(df),pattern = "aspect_min")==1)
cov_mean <-which(str_count(colnames(df),pattern = "cov_flowli_mean")==1)
sv_dist <-which(str_count(colnames(df),pattern = "sv_dist_sum")==1)

c <- c(asp_min,cov_mean,sv_dist)
dfx <-df[,c]
# descriptive Werte. Anzahl an Objecten je Cluster als Clustergüte (zb 85% bombemkrater)
# Hyphotthese von eindeutigen zuordnbaren Cluster zb bei 85 % wird angenommen es handelt sich um den Bombemcluster
# konkrete statistische tests hat auch JK gerade keine ahnung, evt 3x3 tafel für chi2 test



#end of script