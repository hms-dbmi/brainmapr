# Tests for travis
library(brainmapr)

data(vol3D)
data(structureID)
data(gannot3D)
data(annot3D)
data(mat)

#####
## Basic tests
#####

# get IDs for a structure
ids <- getIds(structureID, 'brain')
id <- getId(structureID, 'midbrain')
name <- getName(structureID, id)
children <- getChildren(structureID, id)
cids <- getStructureIds(structureID, 'midbrain')
# plot a projection
plotProjectionXray(vol3D, t=8)
plotProjection(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
# plot a slice
s <- 15 # slice
s2 <- round(s/dim(gannot3D)[3]*dim(vol3D)[3]) # convert
plotSliceXray(vol3D, s2, t=8)
plotSlice(vol3D, s2, t=8)
# plot a section
sect3D <- structurePlot(cids, vol3D, annot3D)
plotProjection(sect3D, t=8)
plotSlice(sect3D, s2, t=8)
# plot a gene
gp3D <- genePlot('Dcx', mat, gannot3D)
plotProjection(gp3D, t=1)
plotSlice(gp3D, s, t=1)
# plot a gene in a section
gpsect3D <- structurePlot(cids, gp3D, gannot3D)
plotProjection(gpsect3D, t=1)
plotSlice(gpsect3D, s, t=1)
# compare
gp3D <- genePlotWeightedComp('Dcx', 1, 'Sox11', 2, mat, gannot3D)
gp3D <- genePlotWeightedComp2('Dcx', 1, 'Sox11', 2, mat, gannot3D)

# Incorrect usage tests
