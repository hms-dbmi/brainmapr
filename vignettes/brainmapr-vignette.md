---
title: "Getting Started with brainmapr"
author: "Jean Fan"
date: '2015-05-20'
output: pdf_document
vignette: |
  %\VignetteIndexEntry{Vignette Title} \usepackage[utf8]{inputenc}
---

`brainmapr` visualizes 3D ISH gene expression data from the Allen Brain Atlas. Our goal is to spatially place a group of neuronal cells within a region of the brain based on their gene expression signature. 

## Getting Started


```r
library(brainmapr)
## included datasets
invisible(structureID)
invisible(vol3D)
invisible(annot3D)
invisible(gannot3D)
invisible(mat)
```

## Plotting

Plot an x-ray of the whole mouse. Note the mouse is upside-down on the slide.


```r
plotProjectionXray(vol3D, t=8)
s <- 15 # slice
s2 <- round(s/dim(gannot3D)[3]*dim(vol3D)[3]) # convert
plotSliceXray(vol3D, s2, t=8)
```

![plot of chunk whole mouse plot](figures/brainmapr-whole mouse plot-1.png) ![plot of chunk whole mouse plot](figures/brainmapr-whole mouse plot-2.png) 

Browse for structures of interest.


```r
getIds(structureID, 'brain')
```

```
##                                                               forebrain 
##                                                                   15566 
##                                                                midbrain 
##                                                                   16649 
##                                                               hindbrain 
##                                                                   16808 
## mesencephalic trigeminal tract (across m1, m2 and prepontine hindbrain) 
##                                                                   17740 
##                                                   ventricles, forebrain 
##                                                               126651562 
##                                                    ventricles, midbrain 
##                                                               126651722 
##                                                   ventricles, hindbrain 
##                                                               126651782
```

Browse for genes of interest.

```r
head(rownames(mat))
```

```
## [1] "Dcx"     "Sox11"   "Cited2"  "Plxna2"  "Neurod6" "Tubb3"
```

Plot an x-ray of just the brain component of interest.


```r
cids1 <- getStructureIds(structureID, 'midbrain')
cids2 <- getStructureIds(structureID, 'ventricles, midbrain')
cids3 <- getStructureIds(structureID, 'forebrain')
cids4 <- getStructureIds(structureID, 'ventricles, forebrain')
cids5 <- getStructureIds(structureID, 'hindbrain')
cids6 <- getStructureIds(structureID, 'ventricles, hindbrain')
cids <- c(cids1, cids2, cids3, cids4, cids5, cids6)
sect3D <- structurePlot(cids, vol3D, annot3D, plot=F)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(sect3D, t=8, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(sect3D, s2, t=8, add=T)
```

![plot of chunk structure plot](figures/brainmapr-structure plot-1.png) ![plot of chunk structure plot](figures/brainmapr-structure plot-2.png) 

Plot expression of `Dcx` gene.


```r
gp3D <- genePlot('Dcx', mat, gannot3D, plot=F)
```

```
## [1] "Genes available:"
## [1] "Dcx"
## [1] "Genes not available:"
## character(0)
```

```r
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gp3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gp3D, s, t=1, add=T)
```

![plot of chunk gene1 plot](figures/brainmapr-gene1 plot-1.png) ![plot of chunk gene1 plot](figures/brainmapr-gene1 plot-2.png) 

Plot expression of `Dcx` gene within brain structure of interest.


```r
gpsect3D <- structurePlot(cids, gp3D, gannot3D, plot=F)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gpsect3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gpsect3D, s, t=1, add=T)
```

![plot of chunk gene1 structure plot](figures/brainmapr-gene1 structure plot-1.png) ![plot of chunk gene1 structure plot](figures/brainmapr-gene1 structure plot-2.png) 

Repeat for `Sox11` gene.


```r
gp3D <- genePlot('Sox11', mat, gannot3D, plot=F)
```

```
## [1] "Genes available:"
## [1] "Sox11"
## [1] "Genes not available:"
## character(0)
```

```r
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gp3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gp3D, s, t=1, add=T)
```

![plot of chunk gene2 plot](figures/brainmapr-gene2 plot-1.png) ![plot of chunk gene2 plot](figures/brainmapr-gene2 plot-2.png) 

```r
gpsect3D <- structurePlot(cids, gp3D, gannot3D, plot=F)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gpsect3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gpsect3D, s, t=1, add=T)
```

![plot of chunk gene2 structure plot](figures/brainmapr-gene2 structure plot-1.png) ![plot of chunk gene2 structure plot](figures/brainmapr-gene2 structure plot-2.png) 

Plot expression of a group of genes within the structure of interest. Weigh expressions equally by default.


```r
gl <- c("Dcx", "Sox11", "FAKEGENE")
gp3D <- genePlot(gl, mat, gannot3D, t=1, plot=F)
```

```
## [1] "Genes available:"
## [1] "Dcx"   "Sox11"
## [1] "Genes not available:"
## [1] "FAKEGENE"
```

```r
gpsect3D <- structurePlot(cids, gp3D, gannot3D, plot=F)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gpsect3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gpsect3D, s, t=1, add=T)
```

![plot of chunk group gene plot](figures/brainmapr-group gene plot-1.png) ![plot of chunk group gene plot](figures/brainmapr-group gene plot-2.png) 

Weigh unequally. Weights are relatively. 


```r
gl <- c("Dcx", "Sox11", "FAKEGENE")
weights <- c(1, 0.01, 1)
gp3D <- genePlot(gl, mat, gannot3D, t=1, plot=F, weights=weights)
```

```
## [1] "Genes available:"
## [1] "Dcx"   "Sox11"
## [1] "Genes not available:"
## [1] "FAKEGENE"
```

```r
gpsect3D <- structurePlot(cids, gp3D, gannot3D, plot=F)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gpsect3D, t=1, add=T)
plotSlice(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gpsect3D, s, t=1, add=T)
```

![plot of chunk group gene weighted plot](figures/brainmapr-group gene weighted plot-1.png) ![plot of chunk group gene weighted plot](figures/brainmapr-group gene weighted plot-2.png) 
