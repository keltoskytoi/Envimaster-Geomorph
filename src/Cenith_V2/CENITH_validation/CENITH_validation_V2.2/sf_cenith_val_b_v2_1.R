#' Mandatory: Cenith Validation Subfunction validation for value b
#'
#' @description Optional: primary subfunction for segmentation over b and calculate statistc results
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: chm - a canopy height model
#' @param Mandatory if function: a, b - parameters for moving window
#' @param Mandatory if function: h - minimum height to detect trees
#' @param Mandatory if function: optional vp - a pointlayer (shp) with positions of Trees
#' @param Mandatory if function: min - minimum area for a polygon
#' @param Mandatory if function: max - maximum area for a polygon

#Note sf_v2_1: uses cleaned sf and added merging intersection polygons, clipping min and max polygons

#chm=som
#a=0.1
#b=0.5
#h=0.5
#vp=vp_som
#j=1
#min=0
#max=100
#result <- data.frame(matrix(nrow = 3, ncol = 11))

cenith_val4b_v2_1 <- function(chm,a,b,h,vp,min,max){
  result <- data.frame(matrix(nrow = length(b), ncol = 8)) # ncol = n information stored
  for (j in seq(1:length(b))){
    cat       (" ",sep="\n")
    
    cat(paste0("### Cenith starts loop b ",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))



    tpos = sf_ft_vwf_clean(chm, 
                            winFun = function(x){x * a + b[j]}, 
                            minHeight = h, 
                            verbose = TRUE)
    
    #cat(paste0("### Cenith computes polygon layer with b",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    seg <- sf_chmseg_clean(chm = chm,
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
    
    names(merc_sp) <- c("group","area")
    
    merc_sp
    
    merc_min <- merc_sp[merc_sp$area>min,]
    merc_min
    
    merc_seg <- merc_sp[merc_min$area<max,]
    merc_seg
    
    
    
    
    ########################
    #cat(paste0("### Cenith calculates precision ratios for b ",as.factor(j)," / ",as.factor(length(b))," ###",sep = "\n"))
    stat <- ForestTools::sp_summarise(vp, merc_seg) # compute data points in polygons
    stat[is.na(stat$TreeCount)] <- 0 # na to 0
    
    pkb <- sum(stat$TreeCount<1) # amount polygon without tree (miss)
    pb <- sum(stat$TreeCount==1) # amount polygon with exact 1 tree (hit)
    pmb <-sum(stat$TreeCount>1) # amount polygon with more than 1 tree (miss)
    
    hit = pb/length(stat$TreeCount) # calc hit ration in percent (amount of exact trees
    over = pkb/length(stat$TreeCount) #calc empty ration in percent (amount of polygon without trees)
    under = pmb/length(stat$TreeCount) # mis.rati (or jan error) miss rate in percent (amount of polygons with more than 1 Tree)
    nobj_vp = length(merc_seg)/length(vp)
    area =  sum(merc_seg$area)
    nobj = length(merc_seg)    # n polygons after clipping min and max
    org_obj = length(merc_sp)  # n polygons after merging
    org_seg = length(seg)      # seg the polygons computed by segmentation
    
    
    result[j, 1] <- a
    result[j, 2] <- b[j]
    result[j, 3] <- h
    result[j, 4] <- hit
    result[j, 7] <- nobj_vp
    result[j, 6] <- over
    result[j, 5] <- area
    result[j, 8] <- under
    result[j, 9] <- paste(nobj,"/",length(vp))
    result[j,10] <- org_obj
    result[j,11] <- org_seg
  } 
  return(result)
}

