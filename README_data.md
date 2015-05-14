# Available Package Data

Full datasets are too big to include in the package. A small expressed set from embryonic 11.5 day mice (E11.5) has been provided as an example. Full datasets can be downloaded from the [Kharchenko lab website](http://pklab.med.harvard.edu/jean/brainmapr/data-raw/) due to file size limitations on GitHub.

## Generating sample data  

```
load("data-raw/Rdata/E11.5.annot.RData")
load("data-raw/Rdata/E11.5.energy.RData")
load("data-raw/Rdata/sids.RData")

gl <- c("Dcx", "Sox11", "Cited2", "Plxna2", "Neurod6", "Tubb3", "Slc17a6", "Sstr2", "Cxcl12", "Hes6", "Eomes", "Neurog2", "Insm1", "Lrp8", "Mgat5b", "Lrrn3", "Nrn1", "Myt1", "Neurod1", "Sox9", "Fstl1", "Ednrb", "Arx", "Sfrp2", "Mfge8", "Ttyh1", "Dab1", "Fstl1", "Notch2", "Slc1a3", "Sox3", "Sox21", "Ttyh1", "Gli3", "Fgfr3", "Ttyh1", "Notch3", "Igfbp5")
mat <- mat[gl,]

devtools::use_data(structureID, mat, annot3D, gannot3D, vol3D)
```

---

# Processed Data

Processed data are available for all developing mouse stages under `data-raw/RData/`:  
- `E11.5.*.RData` - data for embryonic 11.5 day old mouse  
- `E13.5.*.RData` - data for embryonic 13.5 day old mouse  
- `E15.5.*.RData` - data for embryonic 15.5 day old mouse  
- `E18.5.*.RData` - data for embryonic 18.5 day old mouse  
- `P4.*.RData` - data for post-natal 4 day old mouse  
- `P14.*.RData` - data for post-natal 14 day old mouse  
- `P28.*.RData` - data for post-natal 28 day old mouse  
- `P56.*.RData` - data for post-natal 56 day old mouse 

Each `RData` file contains:
- `annot3D` - 3D array containing structure annotations for each pixel  
- `vol3D` - 3D array containing stain per pixel for whole mouse  
- `gannot3D` - 3D array containg structure annotations for each voxel  
- `mat` - matrix where each row corresponds to the average energy per voxel for a gene  

`sids.RData` contains:
- `structure.id` - nested list of structure names to IDs; same for every developing mouse stage

See `data-raw/scripts/to_RData.R` for more information.

---

# Raw Data 

Raw data are too big to included in the package. The following steps were used to download and process data stored in `data-raw/`. Raw data folders have been zipped to save space. All raw data are publicly available for download through [the Allen Brain Atlas website](http://www.brain-map.org/). 

## Source

This directory is comprised of developing mouse brain ISH data from [the Allen Brain Atlas](http://developingmouse.brain-map.org/). For more information, please consult the [Allen Developing Mouse Brain Atlas technical white apper](http://help.brain-map.org/download/attachments/4325389/DevMouse_Overview.pdf).

## Date

This data was downloaded in March 2014. 

## Additional resources

[Interactive Atlas Viewer](http://atlas.brain-map.org/atlas#atlas=1) - Useful for figuring out what are the comparable regions at different development time points

[Gene Search](http://developingmouse.brain-map.org/search/index) - Useful for searching for gene names to see if they have expression data for that gene

## Downloading Gene Expression Data

[Official Tutorial](http://help.brain-map.org/display/api/Downloading+3-D+Expression+Grid+Data)

### Step 1
Get all gene IDs for all genes by age group. Remove num_row limit by using some really large number.

ex. Embryonic 11.5 days mouse data. Must be non-failed in-situ hybridization experiment. Show gene name and other info just for sanity check:
```
http://api.brain-map.org/api/v2/data/query.xml?criteria=model::SectionDataSet,rma::criteria,[failed$eq%27false%27],products[abbreviation$eq%27DevMouse%27],treatments[name$eq'ISH'],specimen(donor(age[name$eq'E11.5'])),rma::include,genes,specimen(donor(age))&num_rows=5000000000
```
Results are saved as XML files under `data-raw/xmlQuery/*.xml`

### Step 2
Parse for gene IDs from XML. See get_data.sh for more info. Results are saved under `data-raw/xmlQuery/ids/*`

### Step 3
Getting the gene expression for each gene requires using the Allen Brain Atlas api. For example, for gene ID 100072942: 
```
http://api.brain-map.org/grid_data/download/100072942?include=energy,intensity,density
```

Accessing the URL returns a zipped file. Unzip to get:  
- `energy.raw` - A raw uncompressed float (32-bit) little-endian volume representing average expression energy per voxel. A value of "-1" represents no data. This file is returned by default if the volumes parameter is null.  
- `density.raw` - A raw uncompressed float (32-bit) little-endian volume representing average expression density per voxel. A value of "-1" represents no data.  
- `injection.raw` - A raw uncompressed float (32-bit) little-endian volume representing the proportion of pixels within each voxel that were within the manually annotated injection site.  
- and corresponding mhd files with grid size information  

Use `wget` to get gene expression file for each gene ID. Results are stored under   `data-raw/geneExpression/`

### Downloading Annotations

[Official Tutorial](http://help.brain-map.org/display/devmouse/API#API-Expression3DGrids)

- `atlasVolume`: uchar (8bit) grayscale Nissl or Feulgen-HP yellow volume of the reconstructed brain.  
- `annotation`: uint (32bit) structural annotation volume matching the atlasVolume. The value represents the ID of the finest level structure annotated for the voxel. Note: the 3-D mask for any structure is composed of all voxels annotated for that structure and all of its descendents in the structure hierarchy.  
- `gridAnnotation`: uint (32bit) structural annotation volume at grid resolution.  

Download directly from site or use `wget`. See `data-raw/csvQuery/*.csv` for more details.

Results are stored under `data-raw/atlasVolume/`, `data-raw/atlasAnnotation/`, and `data-raw/gridAnnotation/` respectively.

### Structure IDs

Grid annotation values refer to structure IDs. Get structure IDs from [the Atlas Ontologies](http://help.brain-map.org/display/api/Atlas+Drawings+and+Ontologies)
```
wget http://api.brain-map.org/api/v2/structure_graph_download/17.json
```

Results are stored under `data-raw/structureGraph/`

