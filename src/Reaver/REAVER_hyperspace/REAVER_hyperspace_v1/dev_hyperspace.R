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


# REAVER hyperspace development script

# load example data

df <- read.csv(file.path(envrmt$path_Reaver,"expl_df.csv"),header =T)
rownames(df)<-df$X
df<- df[2:5]
df

test2 <- Reaver_hyperspace(df,3)
test2
test[1]

test1 <-1
test2 <-2
ls <-list(test1,test2)
names(ls) <-c("test","test2")
ls

# look for a resolution to sort cluster nr by rowname (eg bombcrate) to make a statisic
hc <- test2$hc
hc
km <- test2$km
sort(hc)
sort(km)
which(".*a.*")

hc[,".venat"] 
unique(hc)
require(dplyr)
dff %>% select(starts_with('venator'))
testtt <- dplyr::select(df,("venator"))
dff$class <- rownames(dff)
dff
dff <-as.data.frame(hc)

for (i in (nrow(df))){
  dff$classs[i] <- 23
}
dff$classs[2]<-32
# a way to show the cl nr for all eg "bombs"

acc    


    