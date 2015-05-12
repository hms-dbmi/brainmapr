# Tests for travis
# Basic tests
plotProjectionXray(vol3D, t=8)
s <- 15 # slice
s2 <- round(s/dim(gannot3D)[3]*dim(vol3D)[3]) # convert
plotSliceXray(vol3D, s2, t=8)
ids <- getIds(structureID, 'brain')
cids <- getStructureIds(structureID, 'midbrain')
sect3D <- structurePlot(cids, vol3D, annot3D, plot=F)
plotProjectionXray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(sect3D, t=8, add=T)
plotSliceXray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(sect3D, s2, t=8, add=T)
gp3D <- genePlot('Dcx', mat, gannot3D, plot=F)
plotProjectionXray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gp3D, t=1, add=T)
plotSliceXray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gp3D, s, t=1, add=T)
gpsect3D <- structurePlot(cids, gp3D, gannot3D, plot=F)
plotProjectionXray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotProjection(gpsect3D, t=1, add=T)
plotSliceXray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plotSlice(gpsect3D, s, t=1, add=T)

# Incorrect usage tests
