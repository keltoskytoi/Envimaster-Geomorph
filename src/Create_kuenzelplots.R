# Preparings
library(ggplot2)


if (dir.exists(paths = "~/edu/Envimaster-Geomorph/data/img/kuenzelplots")) {
  print("Output directory already exists")
} else{
dir.create(path = "~/edu/Envimaster-Geomorph/data/img/kuenzelplots", recursive = TRUE)
}

filename <- "~/edu/Envimaster-Geomorph/data/img/kuenzelplots" # your output filename


plot_profile <- function(data, Tiefe, Schlaege, filename, plotname){
  profile_plot <- ggplot(data, aes(x=Tiefe, y=Schlaege)) +
    geom_bar(stat = "identity") +
    coord_flip() # flips plot to horizontal
  png(filename = paste(filename, paste0(plotname, ".png"), sep = "/"))
  plot(profile_plot)
  dev.off()
}

# Krater 1
## Profil 1.1
plotname <- "Profil_1.1" # name of the created plot

tiefe <- c(-10, -20, -30, -40, -50, -60)
schlaege <- c(18, 17, 18, 18, 17, 39)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 1.2
plotname <- "Profil_1.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70)
schlaege <- c(12, 13, 10, 12, 17, 38, 53)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 1.3
plotname <- "Profil_1.3"

tiefe <- c(-160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10) 
schlaege <- c(53, 38, 52 ,46, 37, 23, 18, 16, 15, 9, 12 ,8, 7,13, 10, 8)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 1.4
plotname <- "Profil_1.4"

tiefe <- c(-250, -240, -230, -220, -210, -200, -190, -180,
           -170, -160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10)
schlaege <- c(64, 21, 11, 10, 8, 5, 4, 5, 4, 3, 4, 9,7, 12,
              11, 14, 15, 15, 22 ,22, 19, 14, 12, 6, 7)


data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 1.5
plotname <- "Profil_1.5"

tiefe <- c(-160, -150, -140, -130, -120, -110, -100,
           -90, -80, -70, -60, -50, -40, -30, -20, -10)
schlaege <- c(17, 7, 6, 8, 10, 13, 7, 6, 7, 9, 10, 13, 14, 15, 15, 10)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

# Krater 2
## Profil 2.1
plotname <- "Profil_2.1"

tiefe <- c(-10, -20, -30, -40, -50, -60)
schlaege <- c(24, 33 ,22, 35, 39, 34)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 2.2
plotname <- "Profil_2.2"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(21, 13, 30, 40)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 2.3
plotname <-  "Profil_2.3"

tiefe <- c(-10, -20, -30)
schlaege <- c(3, 18, 35)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 2.4
plotname <- "Profil_2.4"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(1, 4, 24, 16)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

# Krater 3
## Profil 3.1
plotname <- "Profil_3.1"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(8, 18, 22, 22)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 3.2
plotname <- "Profil_3.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110, -120)
schlaege <- c(3, 7, 11, 9, 9, 9, 12, 17, 14, 30, 55, 78)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 3.3
plotname <- "Profil_3.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110)
schlaege <- c(6, 18, 23, 25, 15, 24, 26, 20, 31, 35, 15)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 3.4
plotname <- "Profil_3.4"

tiefe <- c(-10, -20, -30, -40)
schlaege <- c(1, 40, 40, 70)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

#Krater 4
## Profil 4.1
plotname <- "Profil_4.1"

tiefe <- c(-10, -20, -30, -40, -50)
schlaege <-c(16, 22, 21, 30, 60)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 4.2
plotname <- "Profil_4.2"

tiefe <- c(-10, -20, -30, -40, -50 ,-60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150, -160)

schlaege <- c(5, 6, 7, 6, 5, 9, 10, 12, 23, 21, 30, 37, 40, 38, 52, 65)
  
  
data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 4.3
plotname <- "Profil_4.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120)

schlaege <- c(7, 10, 20, 15, 17, 14, 18, 18, 18, 14, 22, 55)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 4.4
plotname <- "Profil_4.4"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90)

schlaege <- c(1, 9, 12, 16, 13, 15, 20, 25, 27)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

# Krater 5 mit keiner Aufnahme

# Krater 6
## Profil 6.1
plotname <- "Profil_6.1"

tiefe <- c(-10, -20, -30, -40, -50, -60)

schlaege <- c(4, 9, 17, 28, 52, 30)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## profil 6.2
plotname <- "Profil_6.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110)

schlaege <- c(2, 3, 7, 5, 3, 6, 13, 16, 22, 32, 57)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 6.3
plotname <- "Profil_6.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150)

schlaege <- c(7, 11, 8, 8, 10, 9, 10, 13, 9, 16, 18, 19, 14, 10, 30)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

# Krater 7
##Profil 7.1
plotname <- "Profil_7.1"

tiefe <- c(-10, -20, -30, -40)

schlaege <- c(5, 15, 13, 26)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 7.2
plotname <- "Profil_7.2"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70)

schlaege <- c(6, 9, 11, 7, 23 ,50, 80)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 7.3
plotname <- "Profil_7.3"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140)

schlaege <- c(4, 12, 10, 12, 23, 16, 20, 20, 23, 19, 20, 28, 18, 30)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)

## Profil 7.4
plotname <- "Profil_7.4"

tiefe <- c(-10, -20, -30, -40, -50, -60, -70, -80, -90, -100,
           -110, -120, -130, -140, -150, -160, -170, -180)

schlaege <- c(10, 14, 15, 11, 9, 6, 7, 9, 9, 10, 16, 15, 16, 15, 9, 12, 20, 15)

data <- data.frame(
  Tiefe=tiefe ,  
  Schlaege=schlaege
)

plot_profile(data = data, 
             Tiefe = Tiefe, 
             Schlaege = Schlaege, 
             filename = filename, 
             plotname = plotname)