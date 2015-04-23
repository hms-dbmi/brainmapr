# Tests for travis

library(brainmapr)

# Basic tests
plot.projection.xray(vol3D, t=8)
s <- 15 # slice
s2 <- round(s/dim(gannot3D)[3]*dim(vol3D)[3]) # convert
plot.slice.xray(vol3D, s2, t=8)
ids <- get.ids(structureID, 'brain')
cids1 <- get.structure.ids(structureID, 'midbrain')
cids2 <- get.structure.ids(structureID, 'ventricles, midbrain')
cids3 <- get.structure.ids(structureID, 'forebrain')
cids4 <- get.structure.ids(structureID, 'ventricles, forebrain')
cids5 <- get.structure.ids(structureID, 'hindbrain')
cids6 <- get.structure.ids(structureID, 'ventricles, hindbrain')
cids <- c(cids1, cids2, cids3, cids4, cids5, cids6)
sect3D <- structure.plot(cids, vol3D, annot3D, plot=F)
plot.projection.xray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.projection(sect3D, t=8, add=T)
plot.slice.xray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.slice(sect3D, s2, t=8, add=T)
gp3D <- gene.plot('Dcx', mat, gannot3D, plot=F)
plot.projection.xray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.projection(gp3D, t=1, add=T)
plot.slice.xray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.slice(gp3D, s, t=1, add=T)
gpsect3D <- structure.plot(cids, gp3D, gannot3D, plot=F)
plot.projection.xray(vol3D, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.projection(gpsect3D, t=1, add=T)
plot.slice.xray(vol3D, s2, col=colorRampPalette(c("white", "grey"),space="Lab")(100), t=8)
plot.slice(gpsect3D, s, t=1, add=T)

# Incorrect usage tests
