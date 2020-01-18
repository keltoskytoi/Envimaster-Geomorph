################################PREPARATIONS####################################
rm(list=ls())
#rm(list_ls(())
############################load libraries######################################
devtools::install_github("environmentalinformatics-marburg/satelliteTools", 
                         ref = "master", dependencies = TRUE, force= TRUE)
devtools::install_github("gisma/link2GI", ref = "master", dependencies = TRUE, force = TRUE)
devtools::install_github("gisma/uavRst", ref = "master", dependencies = TRUE, force = TRUE)
devtools::install_github("jannes-m/RQGIS", force = TRUE)
source("/home/keltoskytoi/R_Projekte/CAA2019/caa_2019/libraries.R")
##########################Creating a folder structure###########################
projRootDir <- "/home/keltoskytoi/R_Projekte/CAA2019/REPOSITORY"

paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = c("data/", "output/","run/", "models/5_classes","models/6_classes", 
                                         "derivatives/", "predictors/", "GRASS/", "predictions/5_classes", 
                                         "models/2_classes", "predictions/2_classes", "predictions/6_classes", "shps/", "saga/", "LiVT/") ,
                         global = TRUE,
                         path_prefix = "path_")
setwd(path_predictors)
################################load predictors#################################
LRM_1 <- raster(paste0(path_predictors, "1_LRM.tif"))
SLOPE_2 <- raster(paste0(path_predictors, "2_Slope.tif"))
ASPECT_3 <- raster(paste0(path_predictors, "3_Aspect.tif"))
CURVATURE_4 <- raster(paste0(path_predictors, "4_Curvature.tif"))
TPI_5 <- raster(paste0(path_predictors, "9_TPI.tif"))
TRI_6 <- raster(paste0(path_predictors, "10_TRI.tif"))
FLOWDIR_7 <- raster(paste0(path_predictors, "12_Flowdir.tif"))
ON_8 <- raster(paste0(path_predictors, "14_OPEN-NEG_R5_D32.tif"))
OP_9 <- raster(paste0(path_predictors, "15_OPEN-POS_R5_D32.tif"))
PCA_10 <- raster(paste0(path_predictors, "16_PCA_D16_H10.tif"))
SVF_11 <- raster(paste0(path_predictors, "17_SVF-R5_D32_A315.tif"))
LD_12 <- raster(paste0(path_predictors, "18_LD_R_M10_20.tif"))
######################################stack predictors##########################
bricked_predictors_S<- brick(LRM_1, SLOPE_2, ASPECT_3, CURVATURE_4, TPI_5,
                             TRI_6, FLOWDIR_7, ON_8, OP_9, PCA_10, SVF_11, LD_12)
DUE_BR_PRED_S <- raster(paste0(path_predictors,"Duens_bricked_predictors_S.tif"))
##################################load & manipulate the data tables###################################
############################loading the training polygons (5 classes, 12 predictors) #######################
#the polygons take bigger space than the sites themselves
Lammert_train<-readOGR("/home/keltoskytoi/R_Projekte/CAA2019/REPOSITORY/shps/Lammert_classes.shp")
summary(Lammert_train)  
Lammert_train@data
Lammert_train@data$CLASS
str(Lammert_train@data$CLASS)
Lammert_train

#reset the mfrow parameter
dev.off()
#par(mfrow=c(1,1))
plot(DUE_BR_PRED_S)
plot(Lammert_train, add =TRUE)

############################CONVERTING THE TRAINING SHAPE (5 classes, 12 predictors) #######################
#to train the raster data, we need to convert the training data to raster 
#(transfer the values of the shapefile to raster cells)
#converting the training data to raster data: assigning codes to the raster 
#cells where they overlap
classes <- rasterize(Lammert_train, bricked_predictors_S, field="CLASS")
cols <- c("yellow4", "orangered4", "black", "navajowhite4", "seagreen")
plot(classes, col=cols, legend=FALSE)
legend("topright", legend=c("enclosure", "burial mound", "road", "fields", "forest"), fill=cols, bg="white")

#creating a raster with a version of our rasterbrick only representing the training pixels
predictors_training_5_12 <- mask(bricked_predictors_S, classes)
plot(predictors_training_5_12)
#combine the rasterbrick with the classes layer = input training dataset
names(classes) <-"class"
plot(classes)
classes
predictors_training_bricked_5_12 <- addLayer(predictors_training_5_12, classes)
plot(predictors_training_bricked_5_12)

#creating a dataframe, containing all training data: extracting all values into a matrix
# = the training data as a data.frame
valuetable_S_5_12 <- getValues(predictors_training_bricked_5_12)
summary(valuetable_S_5_12)
#lots of NAs in the waluetable, because all values were taken; let's get rid of these
#-> omiting the NA values
cleaned_valuetable_5_12 <- na.omit(valuetable_S_5_12)
cleaned_valuetable_endversion_5_12 <- as.data.frame(cleaned_valuetable_5_12)
#inspecting the valuetable 
names(cleaned_valuetable_endversion_5_12)
head(cleaned_valuetable_endversion_5_12, n= 50)
tail(cleaned_valuetable_endversion_5_12, n=20)

#converting the class column into a FACTOR -> values as integers have no meaning = our training dataset
# = we have a reference table which contains for each 5 classes all known values for all predictors
setwd(path_data)
cleaned_valuetable_endversion_5_12$class <- factor(cleaned_valuetable_endversion_5_12$class, levels = c(1:5))
names(cleaned_valuetable_endversion_5_12)
head(cleaned_valuetable_endversion_5_12)
#plot(cleaned_valuetable_endversion)
write.csv(cleaned_valuetable_endversion_5_12, file="valuetable_S_5_12.csv")
