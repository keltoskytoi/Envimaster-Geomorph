#' Mandatory: Cenith subfunction cleaned treepos
#'
#' @description Optional: Segmentation Alogrithm for a elevation modell 
#' @name Mandatory Cenith  
#' @export Mandatory Cenith



#note identical to Forsettools vwf but deleted cat spellings

sf_ft_vwf_clean <-function (CHM, winFun, minHeight = NULL, maxWinDiameter = 99, 
                            minWinNeib = "queen", verbose = FALSE) 
{
  if (verbose) 
    if (!minWinNeib %in% c("queen", "rook")) 
      stop("Invalid input for 'minWinNeib'. Set to 'queen' or 'rook'")
  CHM.crs <- as.character(raster::crs(CHM))
  CHM.prj <- regmatches(CHM.crs, regexpr("(?<=proj=).*?(?=\\s)", 
                                         CHM.crs, perl = TRUE))
  if (length(CHM.prj) > 0 && CHM.prj %in% c(c("latlong", "latlon", 
                                              "longlat", "lonlat"))) {
    warning("'CHM' map units are in degrees. Ensure that 'winFun' outputs values in this unit.")
  }
  roundRes <- round(raster::res(CHM), 5)
  if (roundRes[1] != roundRes[2]) 
    stop("Input 'CHM' does not have square cells")
  if (roundRes[1] == 0) 
    stop("The map units of the 'CHM' are too small")
  if (!is.null(minHeight) && minHeight <= 0) 
    stop("Minimum canopy height must be set to a positive value.")
  CHM.rng <- suppressWarnings(raster::cellStats(CHM, range))
  names(CHM.rng) <- c("min", "max")
  if (is.infinite(CHM.rng["max"]) | is.infinite(CHM.rng["min"])) {
    stop("Input 'CHM' does not contain any usable values. Check input data.")
  }
  if (!is.null(minHeight)) {
    if (minHeight >= CHM.rng["max"]) 
      stop("'minHeight' is set to a value higher than the highest cell value in 'CHM'")
    if (minHeight > CHM.rng["min"]) {
      CHM[CHM < minHeight] <- NA
      CHM.rng["min"] <- minHeight
    }
  }
  if (verbose) 
    radii <- seq(floor(winFun(CHM.rng["min"])), ceiling(winFun(CHM.rng["max"])), 
                 by = roundRes[1])
  radii <- radii[radii >= roundRes[1]]
  if (length(radii) == 0) {
    warning("The maximum window radius computed with 'winFun' is smaller than the CHM's resolution", 
            "\nA 3x3 cell search window will be uniformly applied", 
            "\nUse a higher resolution 'CHM' or adjust 'winFun' to produce wider dynamic windows")
    radii <- roundRes[1]
  }
  maxDimension <- (max(radii)/roundRes[1]) * 2 + 1
  if (!is.null(maxWinDiameter) && maxDimension > maxWinDiameter) {
    stop("Input function for 'winFun' yields a window diameter of ", 
         maxDimension, " cells, which is wider than the maximum allowable value in 'maxWinDiameter'.", 
         "\nChange the 'winFun' function or set 'maxWinDiameter' to a higher value (or to NULL).")
  }
  windows <- lapply(radii, function(radius) {
    win.mat <- raster::focalWeight(raster::raster(resolution = roundRes), 
                                   radius, type = "circle")
    if (nrow(win.mat) == 3 && minWinNeib == "queen") 
      win.mat[] <- 1
    win.pad <- raster::extend(raster::raster(win.mat), (maxDimension - 
                                                          ncol(win.mat))/2, value = 0)
    win.vec <- as.vector(win.pad != 0)
    return(win.vec)
  })
  names(windows) <- radii
  .vwMax <- function(x, ...) {
    centralValue <- x[length(x)/2 + 0.5]
    if (is.na(centralValue)) {
      return(NA)
    }
    else {
      radius <- winFun(centralValue)
      window <- windows[[which.min(abs(as.numeric(names(windows)) - 
                                         radius))]]
      return(if (max(x[window], na.rm = TRUE) == centralValue) 1 else 0)
    }
  }
  lm.pts <- raster::rasterToPoints(raster::focal(CHM, w = matrix(1, 
                                                                 maxDimension, maxDimension), fun = .vwMax, pad = TRUE, 
                                                 padValue = NA), fun = function(x) x == 1, spatial = TRUE)
  lm.pts[["height"]] <- raster::extract(CHM, lm.pts)
  lm.pts[["winRadius"]] <- winFun(lm.pts[["height"]])
  lm.pts[["treeID"]] <- 1:length(lm.pts)
  return(lm.pts)
}
