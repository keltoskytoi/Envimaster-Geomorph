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
libs = c("link2GI","ggplot2") 
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

# Script to plot profiles for "künzelstab"

#set output path
pathout=envrmt$path_künzelplots

#load fucntion to save plot as png, 

#load subfunction
# changes for plot design will be used for all plots
plot_profile <- function(output,depth, strikes, plotname,title=1){
  #perpare df
  data <- data.frame(
    Depth=depth ,  
    Strikes=strikes
  )
  #prepare ggplot with Titel
  
  if (title==1){
  profile_plot <- ggplot(data, aes(x=Depth, y=Strikes)) +
    geom_bar(stat = "identity") +
    ggtitle(plotname)+
    coord_flip() # flips plot to horizontal
  png(filename = file.path(output, paste0(plotname, ".png")))
  # no titel
  } else if (title==0){
    profile_plot <- ggplot(data, aes(x=Depth, y=Strikes)) +
      geom_bar(stat = "identity") +
      coord_flip() # flips plot to horizontal
    png(filename = file.path(output, paste0(plotname, ".png")))
  } else {
    stop("missing argument for title")
  }
  #plot for writing to output path
  plot(profile_plot)
  dev.off() # set device to zero
#plot(profile_plot) # plot for in R
  }


overlord <-function(out=pathout,plot_title=1){
  
  
# Krater 1
## Profil 1.1
plotname <- "Profil_1.1" # name of the created plot

tiefe <- c(-10, -20, -30, -40, -50, -60)
schlaege <- c(18, 17, 18, 18, 17, 39)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 1.2
plotname <- "Profil_1.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70)
schlaege <- c(12, 13, 10, 12, 17, 38, 53)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 1.3
plotname <- "Profil_1.3"

tiefe <- c(-160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10) 
schlaege <- c(53, 38, 52 ,46, 37, 23, 18, 16, 15, 9, 12 ,8, 7,13, 10, 8)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 1.4
plotname <- "Profil_1.4"

tiefe <- c(-250, -240, -230, -220, -210, -200, -190, -180,
           -170, -160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10)
schlaege <- c(64, 21, 11, 10, 8, 5, 4, 5, 4, 3, 4, 9,7, 12,
              11, 14, 15, 15, 22 ,22, 19, 14, 12, 6, 7)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 1.5
plotname <- "Profil_1.5"

tiefe <- c(-160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10)
schlaege <- c(17, 7, 6, 8, 10, 13, 7, 6, 7, 9, 10, 13, 14, 15, 15, 10)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
# Krater 2
## Profil 2.1
plotname <- "Profil_2.1"

tiefe <- c(-10, -20, -30, -40, -50, -60)
schlaege <- c(24, 33 ,22, 35, 39, 34)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 2.2
plotname <- "Profil_2.2"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(21, 13, 30, 40)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 2.3
plotname <-  "Profil_2.3"

tiefe <- c(-10, -20, -30)
schlaege <- c(3, 18, 35)

plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 2.4
plotname <- "Profil_2.4"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(1, 4, 24, 16)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
# Krater 3
## Profil 3.1
plotname <- "Profil_3.1"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(8, 18, 22, 22)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 3.2
plotname <- "Profil_3.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110, -120)
schlaege <- c(3, 7, 11, 9, 9, 9, 12, 17, 14, 30, 55, 78)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 3.3
plotname <- "Profil_3.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110)
schlaege <- c(6, 18, 23, 25, 15, 24, 26, 20, 31, 35, 15)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 3.4
plotname <- "Profil_3.4"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(1, 40, 40, 70)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
#Krater 4
## Profil 4.1
plotname <- "Profil_4.1"

tiefe <- c(-10, -20, -30, -40, -50)
schlaege <-c(16, 22, 21, 30, 60)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 4.2
plotname <- "Profil_4.2"

tiefe <- c(-10, -20, -30, -40, -50 ,-60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150, -160)
schlaege <- c(5, 6, 7, 6, 5, 9, 10, 12, 23, 21, 30, 37, 40, 38, 52, 65)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 4.3
plotname <- "Profil_4.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110, -120)
schlaege <- c(7, 10, 20, 15, 17, 14, 18, 18, 18, 14, 22, 55)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 4.4
plotname <- "Profil_4.4"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90)
schlaege <- c(1, 9, 12, 16, 13, 15, 20, 25, 27)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
# Krater 5 mit keiner Aufnahme

# Krater 6
## Profil 6.1
plotname <- "Profil_6.1"

tiefe <- c(-10, -20, -30, -40, -50, -60)
schlaege <- c(4, 9, 17, 28, 52, 30)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## profil 6.2
plotname <- "Profil_6.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110)
schlaege <- c(2, 3, 7, 5, 3, 6, 13, 16, 22, 32, 57)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 6.3
plotname <- "Profil_6.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150)
schlaege <- c(7, 11, 8, 8, 10, 9, 10, 13, 9, 16, 18, 19, 14, 10, 30)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
# Krater 7
##Profil 7.1
plotname <- "Profil_7.1"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(5, 15, 13, 26)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 7.2
plotname <- "Profil_7.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70)
schlaege <- c(6, 9, 11, 7, 23 ,50, 80)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 7.3
plotname <- "Profil_7.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140)
schlaege <- c(4, 12, 10, 12, 23, 16, 20, 20, 23, 19, 20, 28, 18, 30)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
## Profil 7.4
plotname <- "Profil_7.4"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150, -160, -170, -180)
schlaege <- c(10, 14, 15, 11, 9, 6, 7, 9, 9, 10, 16, 15, 16, 15, 9, 12, 20, 15)
plot_profile(output=out,depth = tiefe, strikes = schlaege, plotname= plotname,title = plot_title)
cat("Overlord finished")}

# run overlord
overlord(plot_title=0)


#end of script