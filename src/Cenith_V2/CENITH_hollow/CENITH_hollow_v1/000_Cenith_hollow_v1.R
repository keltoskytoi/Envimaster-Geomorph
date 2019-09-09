#' Mandatory: Cenith Hollow Segmentation
#'
#' @description Optional: Segmentation for Sink only models (som), merges intersecting polygons.
#' not useful for tree segementation on a chm
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: som - a sink only model
#' @param Mandatory if function: a, b - parameters for the moving window
#' @param Mandatory if function: h - minimum height to detect Objects
#' @param Mandatory if function: min - minimum area for a polygon
#' @param Mandatory if function: max - maximum area for a polygon
#' @param Mandatory if function: f - optional mean filter for som with f*f

#Note v1: uses cleaned sf and added merging intersection polygons, clipping min and max polygons


cenith_hollow <- function(som,a,b,h,min,max,f=1){
  #filter som
  if (f>1){
    cat(paste0("### Cenith computes som with mean filter ",as.factor(f)," ###",sep = "\n"))
    chm <- raster::focal(som,w=matrix(1/(f*f),nrow=f,ncol=f),fun=mean)
  } else {som = som}   ### filter function seperate

    cat       (" ",sep="\n")
    cat("### Cenith computes hollow positions ###",sep = "\n")



    tpos = sf_ft_vwf_clean(som, 
                            winFun = function(x){x * a + b}, 
                            minHeight = h, 
                            verbose = TRUE)
    cat("### Cenith computes hollow segmentation ###",sep = "\n")
    seg <- sf_chmseg_clean(chm = som,
                     treepos = tpos,
                     format = "polygons",
                     minTreeAlt = h,
                     verbose = TRUE)
    #########################
    #load function for merging
    clusterSF <- function(sfpolys){
      dmat = st_distance(sfpolys)
      hc = hclust(as.dist(dmat), method="single")
      groups = cutree(hc, h=0.5)
      d = st_sf(
        geom = do.call(c,
                       lapply(1:max(groups), function(g){
                         st_union(sfpolys[groups==g,])
                       })
        )
      )
      d$group = 1:nrow(d)
      d
    }
    #################################
    # convert sp to sf
    poly_sf <- st_as_sf(seg)
    #run merging
    merc_seg_sf <- clusterSF(poly_sf)
    #convert sf to sp
    merc_sp <- sf:::as_Spatial(merc_seg_sf)
    
    ########################
    for (s in 1:length(merc_sp)){
    merc_sp[s,2] <- gArea(merc_sp[s,])
    }
    
    names(merc_sp) <- c("ID","area")
    
    merc_sp
    merc_min <- merc_sp[merc_sp$area>min,]
    merc_min
    
    merc_seg <- merc_sp[merc_min$area<max,]
    merc_seg
    
    
    
    
    ######################## results
    cat(paste0("### Cenith computed ",as.factor(length(seg))," Polygons in total ###",sep = "\n"))
    cat(paste0("### after merging ",as.factor(length(merc_sp))," Polygons left ###",sep = "\n"))
    cat(paste0("### Cenith detected ",as.factor(length(merc_seg))," Objects after clipping to min and max ###",sep = "\n"))
    cat(" ",sep = "\n")
    cat       ("################################",sep="\n")
    cat       ("   CC EEEE N   N  I TTTTT H   H ",sep="\n")
    cat       ("  C   E    NN  N  I   T   H   H ",sep="\n")
    cat       (" C    EE   N N N  I   T   HHHHH ",sep="\n")
    cat       ("  C   E    N  NN  I   T   H   H ",sep="\n")
    cat       ("   CC EEEE N   N  I   T   H   H ",sep="\n")
    cat       ("                              ",sep="\n")
    cat       ("Finished hollow segmentation           ",sep="\n")
    return(merc_seg)
  } 
  


