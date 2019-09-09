#' Mandatory: Cenith subfunction cleaned segmentation
#'
#' @description Optional: Segmentation Alogrithm for a elevation modell 
#' @name Mandatory Cenith  
#' @export Mandatory Cenith



#note identical to FORESTTOOLS mcws but deleted cat spellings

sf_ft_mcws_clean <- function (treetops, CHM, minHeight = 0, format = "raster", OSGeoPath = NULL, 
                              verbose = FALSE) 
{
  if (verbose) 
    if (!toupper(format) %in% c("RASTER", "POLYGONS", "POLYGON", 
                                "POLY")) {
      stop("'format' must be set to either 'raster' or 'polygons'")
    }
  if (verbose) 
    CHM.max <- suppressWarnings(raster::cellStats(CHM, "max"))
  if (is.infinite(CHM.max)) {
    stop("Input CHM does not contain any usable values.")
  }
  if (minHeight > CHM.max) {
    stop("'minHeight' is set higher than the highest cell value in 'CHM'")
  }
  raster::crs(CHM) <- raster::crs(treetops)
  treetopsHgts <- raster::extract(CHM, treetops)
  treetops <- treetops[!is.na(treetopsHgts) & treetopsHgts >= 
                         minHeight, ]
  if (length(treetops) == 0) {
    stop("No usable treetops. Treetops are either outside of CHM's extent, or are located elow the 'minHeight' value")
  }
  if (!"treeID" %in% names(treetops)) {
    warning("No 'treeID' found for input treetops. New 'treeID' identifiers will be added to segments")
    treetops[["treeID"]] <- 1:length(treetops)
  }
  else {
    if (any(treetops[["treeID"]] == 0)) 
      stop("'treeID' cannot be equal to 0")
    if (any(duplicated(treetops[["treeID"]]))) 
      warning("Duplicate 'treeID' identifiers detected")
  }
  if (verbose) 
    CHM.mask <- is.na(CHM) | CHM < minHeight
  CHM[CHM.mask] <- 0
  if (verbose) 
    ttops.ras <- raster::rasterize(treetops, CHM, "treeID", background = 0)
  CHM.img <- imager::as.cimg(raster::as.matrix(CHM))
  ttops.img <- imager::as.cimg(raster::as.matrix(ttops.ras))
  if (verbose) 
    ws.img <- imager::watershed(ttops.img, CHM.img)
  ws.ras <- raster::raster(vals = ws.img[, , 1, 1], nrows = nrow(CHM), 
                           ncols = ncol(CHM), ext = raster::extent(CHM), crs = raster::crs(CHM))
  ws.ras[CHM.mask] <- NA
  if (toupper(format) %in% c("POLYGONS", "POLYGON", "POLY")) {
    if (verbose) 
      if (is.null(OSGeoPath)) {
        polys <- raster::rasterToPolygons(ws.ras)
        polys <- rgeos::gUnaryUnion(polys, id = polys[["layer"]])
        polys <- sp::disaggregate(polys)
      }
    else {
      polys <- APfun::APpolygonize(ws.ras, OSGeoPath = OSGeoPath)
    }
    if (verbose) 
      polys.over <- sp::over(polys, treetops)
    polys.out <- sp::SpatialPolygonsDataFrame(polys, subset(polys.over, 
                                                            select = which(names(polys.over) != "treeID")))
    polys.out <- polys.out[match(treetops[["treeID"]], polys.over[, 
                                                                  "treeID"]), ]
    if (verbose) 
      if ("crownArea" %in% names(polys.out)) {
        i <- 1
        while (paste0("crownArea", i) %in% names(polys.out)) i <- i + 
            1
        crownArea <- paste0("crownArea", i)
        warning("Input data already has a 'crownArea' field. Writing new crown area values to the 'crownArea", 
                i, "' field")
      }
    else {
      crownArea <- "crownArea"
    }
    polys.out[[crownArea]] <- rgeos::gArea(polys.out, byid = TRUE)
    if (verbose) 
      return(polys.out)
  }
  else {
    if (verbose) 
      cat("..Returning crown outlines as a raster\n\nFinished at:", 
          format(Sys.time(), "%Y-%m-%d, %X"), "\n")
    return(ws.ras)
  }
}
