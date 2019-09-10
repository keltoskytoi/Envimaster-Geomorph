#' Mandatory: Legion DEM
#' 
#' @description Optional: CComputes several artificially raster layers from a single DEM and uses
#' several sum filters.Returns a single RasterStack.
#' @name Mandatory LEGION  
#' @export Mandatory LEGION

#' @param Mandatory if function: dem - a digital elevation model in tif format
#' @param Mandatory if function: output - the path where the som and filled_dem to be saved
#' predefinition in var is recommended
#' @param Mandatory if function: tmp - a folder to save several rasterlayers (can be deleted later)
#' @param Mandatory if function: proj - desired projection for output data, predefinition in var is recommended
#' @param Mandatory if function: radius - The maximum search radius for skyview [map units]
#' @param Mandatory if function: units - the unit for slope and aspect,0=radians 1=degree, default is 0
#' @param Mandatory if function: filter - a vector of at least 2 values for sum filter in f*f for the input dem.
#' @param Mandatory if function: method - default 9 parameter 2nd order polynom (Zevenbergen & Thorne 1987) 
#' for others see http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_0.html

#Note sf: Subfunction to avoid list problem with lapply
LEGION_dem_v2 <- function(dem,tmp,method=6,units=0,radius=100,proj,filter){
  ls <-sf_LEGION_dem(dem,tmp,method,units,radius,proj,filter)
  
   stk <-stack(ls[[1]])
 for (i in 2:length(filter)){
   stk <-stack(stk,ls[[i]])
   return(stk)
 }
}



