#####
## ID and name parsing related functions
#####


#' A recursive way to get IDs and names of structure given a name substring
#'
#' In the Allen Brain Atlas, a Structure represents a neuroanatomical region of interest. Structures are grouped into Ontologies and organized in a hierarchy or StructureGraph. The StructureGraph for the Developing Mouse Brain Atlas is provided here under data/structureIDRda. This function allows you to browse Structures by name and ID given a name substring.
#'
#' @param nestedList A JSON derived nested list of Structure relationships from Allen Brain Atlas's StructureGraph
#' @param name Brain structure name substring
#'
#' @return ids A dictionary of Structures that contain the name with their IDs
#'
#' @examples
#' data(structureID)
#' getIds(structureID, 'pallium')
#'
#' @keywords browse, search
#'
#' @export
getIds <- function(nestedList, name) {
  ids <- {}
  ## recursive component
  getIdsHelper <- function(nestedList, name) {
    for(x in nestedList) {
      ## check if structure name contains substring
      ## recur to go down nested children list
      if(length(x$children)>0) {
        if(grepl(name, x$name)) { ids[x$name] <<- x$id }
        else { getIdsHelper(x$children, name) }
      }
      else{
        # last node
        if(grepl(name, x$name)) { ids[x$name] <<- x$id }
        else { }
      }
    }
  }
  getIdsHelper(nestedList, name)
  return(ids)
}


#' A recursive way to get the name of a Structure given its ID
#'
#' In the Allen Brain Atlas, a Structure represents a neuroanatomical region of interest. Structures are grouped into Ontologies and organized in a hierarchy or StructureGraph. The StructureGraph for the Developing Mouse Brain Atlas is provided here under data/structureIDRda. This function allows you to retrieve the name of a Structures given its ID.
#'
#' @param nestedList A JSON derived nested list of Structure relationships from Allen Brain Atlas's StructureGraph
#' @param sid id The structure ID
#' @return n Brain structure name
#'
#' @examples
#' data(structureID)
#' getName(structureID, 15903)
#'
#' @keywords browse, search
#'
#' @export
getName <- function(nestedList, sid) {
  n <- "not found"
  getNameHelper <- function(nestedList, sid, n) {
    for(x in nestedList) {
      if(length(x$children)>0) {
        if(x$id==sid) { n <<- x$name }
        else { getNameHelper(x$children, sid, n) }
      }
      else{
        ## last node
        if(x$id==sid) { n <<- x$name }
      }
    }
  }
  getNameHelper(nestedList, sid, n)
  return(n)
}


#' A recursive way to get structure IDs and names of structure given an exact name string. Used by \code{\link{getStructureIds}}
#'
#' @param nestedList A JSON derived nested list of Structure relationships from Allen Brain Atlas's structure graph
#' @param name Structure's name
#'
#' @return cids Structure ID
#'
#' @examples
#' data(structureID)
#' getId(structureID, 'pallium')
#'
#' @keywords browse, search, helper
#'
#' @export
getId <- function(nestedList, name) {
  cids <- "not found"
  getIdHelper <- function(nestedList, name, cids) {
    for(x in nestedList) {
      if(length(x$children)>0) {
        if(x$name==name) { cids <<- x$id }
        else { getIdHelper(x$children, name, cids) }
      }
      else{
        ## last node
        if(x$name==name) { cids <<- x$id }
      }
    }
  }
  getIdHelper(nestedList, name, cids)
  return(cids)
}

#' A recursive way to get all the children of a Structure given its ID. Used by \code{\link{getStructureIds}}
#'
#' @param nestedList A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param sid The Structure's ID
#'
#' @return cids The Structure children's IDs
#'
#' @examples
#' data(structureID)
#' getChildren(structureID, 15903)
#'
#' @keywords browse, search, helper
#'
#' @export
getChildren <- function(nestedList, sid) {
  cids <- c()
  getChildrenHelper <- function(nestedList, sid) {
    for(x in nestedList) {
      if(x$id==sid) {
        ## found, just get children's ids
        getChildrenIds(x$children)
      }
      else { getChildrenHelper(x$children, sid) } ## keep going
    }
  }
  getChildrenIds <- function(nestedList) {
    for(x in nestedList) {
      ## append children's ids to list
      cids <<- c(cids, x$id)
      getChildrenIds(x$children)
    }
  }
  getChildrenHelper(nestedList, sid)
  return(cids)
}

#' Get IDs associated with a Structure given the exact Structure name
#'
#' In the Allen Brain Atlas, a Structure represents a neuroanatomical region of interest. Structures are grouped into Ontologies and organized in a hierarchy or StructureGraph. With the exception of the "root" structure, each Structure has one parent and denotes a "part-of" relationship. Due to this relationship, a Structure's total volume is denoted by both its own IDs and also that of its children's IDs. The StructureGraph for the Developing Mouse Brain Atlas is provided here under data/structureIDRda. This function allows you to obtain all IDs associated with a Structure given its exact name.
#'
#' @param nestedList A JSON derived nested list of structure relationships from Allen Brain Atlas's StructureGraph
#' @param name Structure's name
#'
#' @return cids The Structure's ID and all its children's IDs
#'
#' @examples
#' data(structureID)
#' getStructureIds(structureID, 'pallium')
#'
#' @keywords browse, search
#'
#' @export
getStructureIds <- function(nestedList, name) {
  sid <- getId(nestedList, name)
  cids <- c(sid, getChildren(nestedList, sid))
  return(cids)
}


#####
## Plotting functions
#####


#' Plot slice of 3D volume
#'
#' @param mat3D 3D volume
#' @param slice Index of slice; limited to dimensions of mat3D
#' @param col Color
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @examples
#' data(vol3D)
#' plotSlice(vol3D, 75, t=8)
#'
#' @keywords plot
#'
#' @export
plotSlice <- function(mat3D, slice, col=colorRampPalette(c("white","black","red","yellow"),space="Lab")(100), t=0, add=F) {
  matT <- mat3D[,,slice]
  image(matT, col=col, zlim=c(t, max(matT, na.rm=T)), asp=1, add=add)  # fix aspect ratio
}

#' \code{\link{plotSlice}} with colors set to look more like an x-ray
#'
#' @param mat3D 3D volume
#' @param slice Index of slice; limited to dimensions of mat3D
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @examples
#' data(vol3D)
#' plotSliceXray(vol3D, 75, t=8)
#'
#' @keywords plot, modification
#'
#' @export
plotSliceXray <- function(mat3D, slice, t=0, add=F) {
  plotSlice(mat3D, slice, col=colorRampPalette(c("white", "black"),space="Lab")(100), t=t, add=add)
}

#' Plot slice of 3D volume without thresholding and allowing for negative expression values. Used for comparing spatial expression of upregulated vs. downregulated gene sets.
#'
#' @param mat3D 3D volume
#' @param slice Index of slice; limited to dimensions of mat3D
#' @param col Color
#' @param add Boolean whether to overlay onto existing plot
#'
#' @examples
#' data(vol3D)
#' plotSliceComp(vol3D, 75)
#'
#' @keywords plot
#'
#' @export
plotSliceComp <- function(mat3D, slice, col=colorRampPalette(c("green","blue", "black","red","yellow"),space="Lab")(100), add=F) {
  matT <- mat3D[,,slice]
  image(matT, col=col, zlim=c(min(matT, na.rm=T), max(matT, na.rm=T)), asp=1, add=add)  # fix aspect ratio
}


#' Plot flat projection of a 3D volume
#'
#' @param mat3D 3D volume
#' @param col Color
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @examples
#' data(vol3D)
#' plotProjection(vol3D, t=8)
#'
#' @keywords plot
#'
#' @export
plotProjection <- function(mat3D, col=colorRampPalette(c("white","black","red","yellow"),space="Lab")(100), t=0, add=F) {
  # threshold to get rid of noise
  mat3D[mat3D <= t] <- 0
  projmat <- apply(mat3D, 2, rowSums, na.rm=T)
  image(projmat, col=col, zlim=c(t, max(projmat, na.rm=T)), asp=1, add=add)
}

#' \code{\link{plotProjection}} with colors set to look more like an x-ray
#'
#' @param mat3D 3D volume
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @keywords plot, modification
#'
#' @export
plotProjectionXray <- function(mat3D, t=0, add=F) {
  plotProjection(mat3D, col=colorRampPalette(c("white", "black"),space="Lab")(100), t=t, add=add)
}


#' Helper function for 3D plotting. Used by \code{\link{structurePlot}} and \code{\link{genePlot}}
#'
#' @param exp vector representation of volume
#' @param x x-dimension of volume
#' @param y y-dimension of volume
#' @param z z-dimension of volume
#'
#' @keywords plot, helper
#'
#' @export
plotEnergy <- function(exp, x, y, z) {
  eyv <- asDataFrame(asTable(exp))
  col <- colorRampPalette(c("white","black","red","yellow"),space="Lab")(100)
  # normalize
  vi <- eyv[,4]>0;
  pc <- col[pmax(1,round(eyv[,4]/max(eyv[,4])*length(col)))]
  # 3D plot
  rgl::plot3d(
    asInteger(eyv[vi,1]),
    asInteger(eyv[vi,2]),
    asInteger(eyv[vi,3]),
    col=pc[vi],
    alpha=eyv[vi,4]/max(eyv[vi,4]),
    xlim=c(0,x),
    ylim=c(0,y),
    zlim=c(0,z)
  )
}

#' Plot the volume or expression within a Structure
#'
#' @param cids Structure ids
#' @param vol 3D volume of expression values
#' @param annot 3D annotation of volume with structure IDs
#' @param plot Boolean of whether to make 3D plot
#'
#' @return tvol 3D volume restricted to just structure of interest
#'
#' @examples
#' data(structureID)
#' data(vol3D)
#' data(annot3D)
#' cids <- getStructureIds(structureID, 'pallium')
#' sect3D <- structurePlot(cids, vol3D, annot3D)  # For whole structure
#' gpsect3D <- structurePlot(cids, array(mat[gene,], dim=dim(gannot3D)), gannot3D)  # For a particular gene
#'
#' @keywords plot
#'
#' @export
structurePlot <- function(cids, vol, annot, plot=F) {
  ## remove structures not in cids
  vol[!(annot %in% cids)] <- NA
  if(plot) {
    plotEnergy(vol, dim(annot)[1], dim(annot)[2], dim(annot)[3])
  }
  return(vol)
}

#' Plot total expression of a set of genes
#'
#' @param gl Gene list
#' @param expmat 3D volume of expression
#' @param gannot 3D annotation of volume with structure IDs
#' @param t Threshold for removing noise; gene energy levels below this threshold will be removed
#' @param weights List of relative weights corresponding to gene list; default: weighted equally
#' @param plot Boolean of whether to make 3D plot
#'
#' @return exp3D 3D volume restricted to weighted gene expression set of interest
#'
#' @examples
#' data(mat)
#' data(gannot3D)
#' gp3D <- genePlot('Dcx', mat, gannot3D)
#'
#' @keywords plot
#'
#' @export
genePlot <- function(gl, expmat, gannot, t=0, weights=rep(1, length(gl)), plot=F) {

  # see what genes we have ISH data available
  glHave <- gl[gl %in% rownames(expmat)]
  glNothave <- gl[!(gl %in% rownames(expmat))]
  weightsHave <- weights[gl %in% rownames(expmat)]
  if(length(glHave)==0) {
    print('No genes available')
    return(NA)
  } else {
    print('Genes available:')
    print(glHave)
    print('Genes not available:')
    print(glNothave)
  }

  # restrict to what we have
  exp <- expmat[glHave,]
  # threshold to get rid of noise
  exp[exp < t] <- 0
  exp <- exp * weightsHave
  if(length(glHave) > 1) {
    expInt <- colSums(exp, na.rm=T)
    #expInt <- colMeans(exp, na.rm=T)
  } else {
    expInt <- exp
  }

  exp3D <- array(expInt, dim=dim(gannot))
  if(plot) {
    plotEnergy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}


#####
## Comparison functions
#####

#' Relative expression of two groups using absolute differences
#'
#' @param gl1 List of differentially expressed genes upregulated in cell group 1
#' @param weights1 List of weights corresponding to genes in \code{gl1}
#' @param gl2 List of differentially expressed genes upregulated in cell group 2
#' @param weights2 List of weights corresponding to genes in \code{gl2}
#' @param expmat 3D volume of expression
#' @param gannot 3D annotation of volume with structure IDs
#' @param plot Boolean of whether to make 3D plot
#'
#' @return exp3D 3D volume of weighted expression for gene lists of interest
#'
#' @keywords comparison, placement
#'
#' @export
genePlotWeightedComp <- function(gl1, weights1, gl2, weights2, expmat, gannot, plot=F) {
  gl <- c(gl1, gl2)
  weights <- c(weights1, -weights2)

  glHave <- gl[gl %in% rownames(expmat)]
  weightsHave <- weights[gl %in% rownames(expmat)]
  print(glHave)
  print(weightsHave)
  if(length(glHave)==0) {
    print('No genes available')
    return(NA)
  }

  exp <- expmat[glHave,]
  # row normalize in case one gene just has higher detection due to better probes
  #exp <- t(t(exp) / rowMeans(exp))
  exp <- exp * weightsHave
  if(length(glHave) > 1) {
    #expInt <- colSums(exp, na.rm=T)
    expInt <- colMeans(exp, na.rm=T)
  } else {
    expInt <- exp
  }

  exp3D <- array(expInt, dim=dim(gannot))
  if(plot) {
    plotEnergy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}

#' Relative expression of two groups using ratios
#'
#' @param gl1 List of differentially expressed genes upregulated in cell group 1
#' @param weights1 List of weights corresponding to genes in \code{gl1}
#' @param gl2 List of differentially expressed genes upregulated in cell group 2
#' @param weights2 List of weights corresponding to genes in \code{gl2}
#' @param expmat 3D volume of expression
#' @param gannot 3D annotation of volume with structure IDs
#' @param plot Boolean of whether to make 3D plot
#'
#' @return exp3D 3D volume of weighted expression for gene lists of interest
#'
#' @keywords comparison, placement
#'
#' @export
genePlotWeightedComp2 <- function(gl1, weights1, gl2, weights2, expmat, gannot, plot=F) {

  gl1Have <- gl1[gl1 %in% rownames(expmat)]
  weights1Have <- weights1[gl1 %in% rownames(expmat)]
  exp1 <- expmat[gl1Have,]
  exp1 <- exp1 * weights1Have
  exp1[exp1 < 0] = 0
  exp1Int <- colMeans(exp1, na.rm=T)
  #exp1Int <- exp1Int/(max(exp1Int, na.rm=T)+1e-10)  # normalize to be comparable

  gl2Have <- gl2[gl2 %in% rownames(expmat)]
  weights2Have <- weights2[gl2 %in% rownames(expmat)]
  exp2 <- expmat[gl2Have,]
  exp2 <- exp2 * weights2Have
  exp2[exp2 < 0] = 0
  exp2Int <- colMeans(exp2, na.rm=T)
  #exp2Int <- exp2Int/(max(exp2Int, na.rm=T)+1e-10)  # normalize to be comparable

  # fold change
  exp1Fold <- log(exp1Int/exp2Int)
  exp2Fold <- log(exp2Int/exp1Int)

  #range01 <- function(x) {
  #  (x - quantile(x, 025, na.rm=T))/(quantile(x, 075, na.rm=T) - quantile(x, 025, na.rm=T))
  #}
  #exp1Fold <- range01(exp1Fold)
  #exp2Fold <- range01(exp2Fold)

  # cube root to emphasize values more near 0
  expInt <- exp1Fold - exp2Fold

  exp3D <- array(expInt, dim=dim(gannot))
  if(plot) {
    plotEnergy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}



#####
## DEVELOPMENT ZONE
#####

# Helper function to estimate the contrast of an image as a the standard error
getContrast <- function(mat3D, t=1) {
  mat3DT <- mat3D
  ## threshold to get rid of noise
  mat3DT[mat3D <= t] <- 0
  projmat <- apply(mat3DT, 2, rowSums)
  projmat[projmat <= 0] <- NA
  #mean(projmat, na.rm=T)
  sd(projmat, na.rm=T)/sqrt(sum(!is.na(projmat)))
}

# Helper function to simulate non-parametric background distribution by permutation
getContrastBackground <- function(mat, gannot, cids, t=1, n=100, size=5, plot=T) {
  setSeed(0)
  d <- sapply(seq(along=1:n), function(i) {
    print(i)
    gl <- sample(rownames(mat), size)
    gp <- genePlot(gl, mat, gannot, plot=F)
    if (sum(is.na(cids)) == 0) {
      gpsect <- structurePlot(cids, gp, gannot, plot=F)
    }
    else {
      gpsect <- gp
    }
    getContrast(gpsect, t=t)
  })
  if (plot == T) {
      hist(d)
  }
  d
}

# Get permutation p-value
getContrastSig <- function(gl, mat, gannot, cids=NA, t=1, n=100, plot=F) {
  # Get score for gene list
  size <- sum(gl %in% rownames(mat))
  gp <- genePlot(gl, mat, gannot, plot=F)
  if (sum(is.na(cids)) == 0) {
    gpsect <- structurePlot(cids, gp, gannot, plot=F)
  } else {
    gpsect <- gp
  }
  glContrast <- getContrast(gpsect, t=t)
  print(glContrast)

  # Simulate background
  d <- getContrastBackground(mat, gannot, cids, t, n, size, plot)
  # Count number of observations at least as extreme
  b <- sum(d >= glContrast)
  # Add 1 to both numerator and denominator to protect against p-value = 0
  # Based off of recommendations from:
  # Statistical Applications in Genetics and Molecular Biology 9 (2010), No. 1, Article 39
  (b+1)/(n+1)
}
