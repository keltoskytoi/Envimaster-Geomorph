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
libs = c("link2GI","vegan","cluster","labdsv","rgdal") 
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
source(file.path(root_folder, file.path(pathdir,"Reaver/REAVER_hyperspace/REAVER_hyperspace_v1/000_Reaver_hyperspace.R")))

#############################################################################
# selcet cols

#select col by name

df_b <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/lahnberge.csv"))
df_d <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/bad_drieburg.csv"))
df_p <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/isabellengrund.csv"))
df_p1 <-read.table(file.path(envrmt$path_002_processed,"reaver_csv/neu_anspach.csv"))
df_m <- read.table(file.path(envrmt$path_002_processed,"reaver_csv/mof.csv"))


# merge dfs
df <- rbind(df_b,df_p)
df <- rbind (df,df_d)
df <- rbind (df,df_p1)
df <- rbind (df,df_m)

# check n count string in colnames
require(stringr)
sum(str_count(colnames(df),pattern = "mean"))
sum(str_count(colnames(df),pattern = "sd"))
sum(str_count(colnames(df),pattern = "sum"))
sum(str_count(colnames(df),pattern = "min"))# min/max is although string in eg cov_max so i comes with 17+5
sum(str_count(colnames(df),pattern = "max"))


sum(str_count(rownames(df),pattern = "krat"))
sum(str_count(rownames(df),pattern = "ping"))
sum(str_count(rownames(df),pattern = "dol"))

# error in names pinge

# eliminate negative values
df[] <- lapply(df, abs)
df


# run Reaver hyperspace
test <- Reaver_hyperspace(df,3)
hc <-test$hc
test$km

#chek sums in hc cluster

# descriptive Werte. Anzahl an Objecten je Cluster als Clustergüte (zb 85% bombemkrater)
# Hyphotthese von eindeutigen zuordnbaren Cluster zb bei 85 % wird angenommen es handelt sich um den Bombemcluster
# konkrete statistische tests hat auch JK gerade keine ahnung, evt 3x3 tafel für shi2 test


# in hypersacpe function als loop schrieben !!!!


class(hc)
dfhc <- as.data.frame(hc) # integer as df
# anzahl obj gesamt
n_krat <-sum(str_count(rownames(dfhc),pattern = "krat"))
n_dol <-sum(str_count(rownames(dfhc),pattern = "dol"))
n_pin <-sum(str_count(rownames(dfhc),pattern = "ping"))

# anzahl an obj in cluster 1
c1_kra <-(str_count(rownames(dfhc),pattern = "krat"))& dfhc[,1]==1# where rowname= krater and cluster=2
c1_dol <-(str_count(rownames(dfhc),pattern = "dol")) & dfhc[,1]==1
c1_pin <-(str_count(rownames(dfhc),pattern = "ping"))& dfhc[,1]==1

# anzahl an obj in cluster 2
c2_kra <-(str_count(rownames(dfhc),pattern = "krat"))& dfhc[,1]==2# where rowname= krater and cluster=2
c2_dol <-(str_count(rownames(dfhc),pattern = "dol")) & dfhc[,1]==2
c2_pin <-(str_count(rownames(dfhc),pattern = "ping"))& dfhc[,1]==2

# anzahl an obj in cluster 3
c3_kra <-(str_count(rownames(dfhc),pattern = "krat"))& dfhc[,1]==3# where rowname= krater and cluster=2
c3_dol <-(str_count(rownames(dfhc),pattern = "dol")) & dfhc[,1]==3
c3_pin <-(str_count(rownames(dfhc),pattern = "ping"))& dfhc[,1]==3

#summe obj in clustern
n_c1 <- sum(c1_kra,c1_dol,c1_pin)
n_c2 <- sum(c2_kra,c2_dol,c2_pin)
n_c3 <- sum(c3_kra,c3_dol,c3_pin)

#c1 anteil der objecte von gesamt objecten
hit_c1_kra <- sum(c1_kra) /n_krat
hit_c1_dol <- sum(c1_dol) /n_dol
hit_c1_pin <- sum(c1_pin) /n_pin

hit_c1_kra
hit_c1_dol
hit_c1_pin

# anzahl objt in cluster 2 von geasmt zahl zb x pingen in c2 von y geasmt pingen
hit_c2_kra <- sum(c2_kra) /n_krat
hit_c2_dol <- sum(c2_dol) /n_dol
hit_c2_pin <- sum(c2_pin) /n_pin

hit_c2_kra
hit_c2_dol
hit_c2_pin

# c3
hit_c3_kra <- sum(c3_kra) /n_krat
hit_c3_dol <- sum(c3_dol) /n_dol
hit_c3_pin <- sum(c3_pin) /n_pin

hit_c3_kra
hit_c3_dol
hit_c3_pin

#c1 anteil der objecte im cluster von anzahl obejcte im cluster###############################
hit_c1_kra <- sum(c1_kra) /n_c1
hit_c1_dol <- sum(c1_dol) /n_c1
hit_c1_pin <- sum(c1_pin) /n_c1

hit_c1_kra
hit_c1_dol
hit_c1_pin

# anzahl objt in cluster 2 von geasmt zahl zb x pingen in c2 von y geasmt pingen
hit_c2_kra <- sum(c2_kra) /n_c2
hit_c2_dol <- sum(c2_dol) /n_c2
hit_c2_pin <- sum(c2_pin) /n_c2

hit_c2_kra
hit_c2_dol
hit_c2_pin

# c3
hit_c3_kra <- sum(c3_kra) /n_c3
hit_c3_dol <- sum(c3_dol) /n_c3
hit_c3_pin <- sum(c3_pin) /n_c3

hit_c3_kra
hit_c3_dol
hit_c3_pin


#end of script