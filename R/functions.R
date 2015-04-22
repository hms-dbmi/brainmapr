#####
## ID and name parsing related functions
#####

#' A recursive way to get structure IDs and names of structure given a name substring
#'
#' @param nested.list A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param name Brain structure name substring
#' @return ids A dictionary of structure names that contain the name substring with their structure IDs
#'
#' @example
#' ids <- get.ids(structure.id, 'pallium')
#' subpallium    pallium
#'      15751      15903
#'
get.ids <- function(nested.list, name) {
  ids <- {}
  ## recursive component
  get.ids.helper <- function(nested.list, name) {
    for(x in nested.list) {
      ## check if structure name contains substring
      ## recur to go down nested children list
      if(length(x$children)>0) {
        if(grepl(name, x$name)) { ids[x$name] <<- x$id }
        else { get.ids.helper(x$children, name) }
      }
      else{
        # last node
        if(grepl(name, x$name)) { ids[x$name] <<- x$id }
        else { }
      }
    }
  }
  get.ids.helper(nested.list, name)
  return(ids)
}

#' A recursive way to get structure IDs and names of structure given an exact name string
#'
#' @param nested.list A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param name Brain structure name
#' @return cids The structure ID
#'
#' @example
#' id <- get.id(structure.id, 'pallium')
#' 15903
#'
get.id <- function(nested.list, name) {
  cids <- "not found"
  get.id.helper <- function(nested.list, name, cids) {
    for(x in nested.list) {
      if(length(x$children)>0) {
        if(x$name==name) { cids <<- x$id }
        else { get.id.helper(x$children, name, cids) }
      }
      else{
        ## last node
        if(x$name==name) { cids <<- x$id }
      }
    }
  }
  get.id.helper(nested.list, name, cids)
  return(cids)
}

#' A recursive way to get the name of a structure given its ID
#'
#' @param nested.list A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param sid id The structure ID
#' @return n Brain structure name
#'
#' @example
#' name <- get.name(structure.id, 15903)
#' "pallium"
#'
get.name <- function(nested.list, sid) {
  n <- "not found"
  get.name.helper <- function(nested.list, sid, n) {
    for(x in nested.list) {
      if(length(x$children)>0) {
        if(x$id==sid) { n <<- x$name }
        else { get.name.helper(x$children, sid, n) }
      }
      else{
        ## last node
        if(x$id==sid) { n <<- x$name }
      }
    }
  }
  get.name.helper(nested.list, sid, n)
  return(n)
}

#' A recursive way to get all the children of a structure given its ID
#' Needed due to the way Allen Brain atlas annotates its structures
#' A structure's full volumn is its own annotation plus that of its children
#'
#' @param nested.list A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param sid The structure ID
#' @return cids The children's IDs
#'
#' @example
#' cids <- get.children(structure.id, 15903)
#'
get.children <- function(nested.list, sid) {
  cids <- c()
  get.children.helper <- function(nested.list, sid) {
    for(x in nested.list) {
      if(x$id==sid) {
        ## found, just get children's ids
        get.children.ids(x$children)
      }
      else { get.children.helper(x$children, sid) } ## keep going
    }
  }
  get.children.ids <- function(nested.list) {
    for(x in nested.list) {
      ## append children's ids to list
      cids <<- c(cids, x$id)
      get.children.ids(x$children)
    }
  }
  get.children.helper(nested.list, sid)
  return(cids)
}

#' Get IDs associated with structure name
#'
#' @param nested.list A JSON derived nested list of structure relationships from Allen Brain Atlas's structure graph
#' @param name Brain structure name
#' @return cids The structure ID and all its children's IDs
#'
get.structure.ids <- function(nested.list, name) {
  sid <- get.id(nested.list, name)
  cids <- c(sid, get.children(nested.list, sid))
  return(cids)
}


#####
## Plotting functions
#####


#' Plot slice of 3D volume
#'
#' @param mat3D 3D volume
#' @param direction Direction of slice = c('axial', 'sagital', 'coronal')
#' @param slice Index of slice; limited to dimensions of mat3D
#' @param col Color
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @example
#' plot.slice.xray(vol3D, 75, t=8)
#'
plot.slice <- function(mat3D, slice, col=colorRampPalette(c("white","black","red","yellow"),space="Lab")(100), t=0, add=F) {
  mat.t <- mat3D[,,slice]
  image(mat.t, col=col, zlim=c(t, max(mat.t, na.rm=T)), asp=1, add=add)  # fix aspect ratio
}
#' Set the colors to look more like an x-ray
plot.slice.xray <- function(mat3D, slice, col=colorRampPalette(c("white", "black"),space="Lab")(100), t=0, add=F) {
  plot.slice(mat3D, slice, col, t=t, add=add)
}
#' Compare 2 regions
plot.slice.comp <- function(mat3D, slice, col=colorRampPalette(c("green","blue", "black","red","yellow"),space="Lab")(100), add=F) {
  mat.t <- mat3D[,,slice]
  image(mat.t, col=col, zlim=c(min(mat.t, na.rm=T), max(mat.t, na.rm=T)), asp=1, add=add)  # fix aspect ratio
}

#' Plot flat projection of a 3D volume
#'
#' @param mat3D 3D volume
#' @param col Color
#' @param t Threshold used to remove noise
#' @param add Boolean whether to overlay onto existing plot
#'
#' @example
#' plot.projection.xray(vol3D, t=8)
#'
plot.projection <- function(mat3D, col=colorRampPalette(c("white","black","red","yellow"),space="Lab")(100), t=0, add=F) {
  # threshold to get rid of noise
  mat3D[mat3D <= t] <- 0
  projmat <- apply(mat3D, 2, rowSums, na.rm=T)
  image(projmat, col=col, zlim=c(t, max(projmat, na.rm=T)), asp=1, add=add)
}
#' Set the colors to look more like an x-ray
plot.projection.xray <- function(mat3D, col=colorRampPalette(c("white", "black"),space="Lab")(100), t=0, add=F) {
  plot.projection(mat3D, col, t=t, add=add)
}


#' Plot the volume or expression of a single gene in a structure
#'
#' @param cids Structure ids
#' @param vol 3D volume of expression values
#' @param annot 3D annotation of volume with structure IDs
#' @param plot Boolean of whether to make 3D plot
#' @return tvol 3D volume restricted to just structure of interest
#'
#' @example
#' For whole structure
#'   structure.plot(cids, vol3D, annot3D, plot=T)
#' For a particular gene
#'   structure.plot(cids, array(mat[gene,], dim=dim(gannot3D)), gannot3D, plot=T)
#'
structure.plot <- function(cids, vol, annot, plot=F) {
  ## remove structures not in cids
  vol[!(annot %in% cids)] <- NA
  if(plot) {
    plot.energy(vol, dim(annot)[1], dim(annot)[2], dim(annot)[3])
  }
  return(vol)
}


#' Helper function for 3D plotting
#'
#' @param exp vector representation of volume
#' @param x x-dimension of volume
#' @param y y-dimension of volume
#' @param z z-dimension of volume
#'
plot.energy <- function(exp, x, y, z) {
  eyv <- as.data.frame(as.table(exp))
  col <- colorRampPalette(c("white","black","red","yellow"),space="Lab")(100)
  # normalize
  vi <- eyv[,4]>0;
  pc <- col[pmax(1,round(eyv[,4]/max(eyv[,4])*length(col)))]
  # 3D plot
  rgl::plot3d(
    as.integer(eyv[vi,1]),
    as.integer(eyv[vi,2]),
    as.integer(eyv[vi,3]),
    col=pc[vi],
    alpha=eyv[vi,4]/max(eyv[vi,4]),
    xlim=c(0,x),
    ylim=c(0,y),
    zlim=c(0,z)
  )
}

#' Plot weighted total expression of a set of genes
#'
#' @param gl Gene list
#' @param weights List of weights corresponding to gene list
#' @param expmat 3D volume of expression
#' @param gannot 3D annotation of volume with structure IDs
#' @param plot Boolean of whether to make 3D plot
#' @return exp3D 3D volume restricted to weighted gene expression of interest
#'
gene.plot <- function(gl, expmat, gannot, t=0, weights=rep(1, length(gl)), plot=F) {

  # see what genes we have ISH data available
  gl.have <- gl[gl %in% rownames(expmat)]
  gl.nothave <- gl[!(gl %in% rownames(expmat))]
  weights.have <- weights[gl %in% rownames(expmat)]
  if(length(gl.have)==0) {
    print('No genes available')
    return(NA)
  } else {
    print('Genes available:')
    print(gl.have)
    print('Genes not available:')
    print(gl.nothave)
  }

  # restrict to what we have
  exp <- expmat[gl.have,]
  # threshold to get rid of noise
  exp[exp < t] <- 0
  exp <- exp * weights.have
  if(length(gl.have) > 1) {
    exp.int <- colSums(exp, na.rm=T)
    #exp.int <- colMeans(exp, na.rm=T)
  } else {
    exp.int <- exp
  }

  exp3D <- array(exp.int, dim=dim(gannot))
  if(plot) {
    plot.energy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}


#####
## DEVELOPMENT ZONE
#####

#####
## Analysis functions; UNDER DEVELOPMENT
#####

#' Helper function to estimate the contrast of an image as a the standard error
get.contrast <- function(mat3D, t=1) {
  mat3D.t <- mat3D
  ## threshold to get rid of noise
  mat3D.t[mat3D <= t] <- 0
  projmat <- apply(mat3D.t, 2, rowSums)
  projmat[projmat <= 0] <- NA
  #mean(projmat, na.rm=T)
  sd(projmat, na.rm=T)/sqrt(sum(!is.na(projmat)))
}

#' Helper function to simulate non-parametric background distribution by permutation
get.contrast.background <- function(mat, gannot, cids, t=1, n=100, size=5, plot=T) {
  set.seed(0)
  d <- sapply(seq(along=1:n), function(i) {
    print(i)
    gl <- sample(rownames(mat), size)
    gp <- gene.plot(gl, mat, gannot, plot=F)
    if (sum(is.na(cids)) == 0) {
      gpsect <- structure.plot(cids, gp, gannot, plot=F)
    }
    else {
      gpsect <- gp
    }
    get.contrast(gpsect, t=t)
  })
  if (plot == T) {
      hist(d)
  }
  d
}

#' Get permutation p-value
get.contrast.sig <- function(gl, mat, gannot, cids=NA, t=1, n=100, plot=F) {
  # Get score for gene list
  size <- sum(gl %in% rownames(mat))
  gp <- gene.plot(gl, mat, gannot, plot=F)
  if (sum(is.na(cids)) == 0) {
    gpsect <- structure.plot(cids, gp, gannot, plot=F)
  }
  else {
    gpsect <- gp
  }
  gl.contrast <- get.contrast(gpsect, t=t)
  print(gl.contrast)

  # Simulate background
  d <- get.contrast.background(mat, gannot, cids, t, n, size, plot)
  # Count number of observations at least as extreme
  b <- sum(d >= gl.contrast)
  # Add 1 to both numerator and denominator to protect against p-value = 0
  # Based off of recommendations from:
  # Statistical Applications in Genetics and Molecular Biology 9 (2010), No. 1, Article 39
  (b+1)/(n+1)
}

#####
## Comparison functions; UNDER DEVELOPMENT
#####

#' Relative expression of two groups
gene.plot.weighted.comp <- function(gl1, weights1, gl2, weights2, expmat, gannot, plot=F) {
  gl <- c(gl1, gl2)
  weights <- c(weights1, -weights2)

  gl.have <- gl[gl %in% rownames(expmat)]
  weights.have <- weights[gl %in% rownames(expmat)]
  print(gl.have)
  print(weights.have)
  if(length(gl.have)==0) {
    print('No genes available')
    return(NA)
  }

  exp <- expmat[gl.have,]
  # row normalize in case one gene just has higher detection due to better probes
  #exp <- t(t(exp) / rowMeans(exp))
  exp <- exp * weights.have
  if(length(gl.have) > 1) {
    #exp.int <- colSums(exp, na.rm=T)
    exp.int <- colMeans(exp, na.rm=T)
  } else {
    exp.int <- exp
  }

  exp3D <- array(exp.int, dim=dim(gannot))
  if(plot) {
    plot.energy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}

#' Relative expression of two groups
gene.plot.weighted.comp2 <- function(gl1, weights1, gl2, weights2, expmat, gannot, plot=F) {

  gl1.have <- gl1[gl1 %in% rownames(expmat)]
  weights1.have <- weights1[gl1 %in% rownames(expmat)]
  exp1 <- expmat[gl1.have,]
  exp1 <- exp1 * weights1.have
  exp1[exp1 < 0] = 0
  exp1.int <- colMeans(exp1, na.rm=T)
  #exp1.int <- exp1.int/(max(exp1.int, na.rm=T)+1e-10)  # normalize to be comparable

  gl2.have <- gl2[gl2 %in% rownames(expmat)]
  weights2.have <- weights2[gl2 %in% rownames(expmat)]
  exp2 <- expmat[gl2.have,]
  exp2 <- exp2 * weights2.have
  exp2[exp2 < 0] = 0
  exp2.int <- colMeans(exp2, na.rm=T)
  #exp2.int <- exp2.int/(max(exp2.int, na.rm=T)+1e-10)  # normalize to be comparable

  # fold change
  exp1.fold <- log(exp1.int/exp2.int)
  exp2.fold <- log(exp2.int/exp1.int)

  #range01 <- function(x) {
  #  (x - quantile(x, 0.25, na.rm=T))/(quantile(x, 0.75, na.rm=T) - quantile(x, 0.25, na.rm=T))
  #}
  #exp1.fold <- range01(exp1.fold)
  #exp2.fold <- range01(exp2.fold)

  # cube root to emphasize values more near 0
  exp.int <- exp1.fold - exp2.fold

  exp3D <- array(exp.int, dim=dim(gannot))
  if(plot) {
    plot.energy(exp3D, dim(gannot)[1], dim(gannot)[2], dim(gannot)[3])
  }
  return(exp3D)
}
