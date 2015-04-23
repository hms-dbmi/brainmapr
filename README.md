#brainmapr

[![Build Status](https://travis-ci.org/JEFworks/brainmapr.svg?branch=master)](https://travis-ci.org/JEFworks/brainmapr)

We developed `brainmapr` to the infer spatial location of neuronal subpopulations within the developing mouse brain by integrating single-cell RNA-seq data with in situ RNA patterns from the [Allen Developing Mouse Brain Atlas](http://mouse.brain-map.org/).

The `brainmapr` package comes pre-loaded with a small sample of ISH data for 38 genes in the embryonic 11.5 day old mouse. Additional ISH data for ~2000 genes in convenient RData formats are available for the embryonic 11.5, 13.5, 15.5, 16.5, and 18.5, and post-natal 4, 14, 28, and 56 day old mice and can be downloaded from the [Kharchenko lab website](http://pklab.med.harvard.edu/jean/brainmapr/data-raw/) due to file size limitations on GitHub. 

Please refer to the [Allen Developing Mouse Brain Atlas Documentation](http://help.brain-map.org/display/mousebrain/Documentation) for specific information on processes and procedures used to perform ISH, informatics data processing, structure annotation, and more. 

---
TODO:
- Make vignettes into PDFs, avoid rebuilding each time  
- Link to data-raw/ files on pk; organize data-raw/ files on pk
- Port to C++ for faster matrix calculations   

---

`brainmapr` visualizes and analyzes 3D ISH gene expression data from the Allen Brain Atlas. Our goal in developing `brainmapr` was to spatially place groups of neuronal cells within a region of the brain on interest based on their gene expression signatures identified from single cell RNA-seq.

## Installation
`install_github("JEFworks/brainmapr")`

## Sample images/output
Projection of an embryonic 13.5 day old mouse  
![](sample_images/mouse_projection.png)


Forebrain highlighted structure highlighted in a slice of an embryonic 13.5 day old mouse  
![](sample_images/mouse_slice_forebrain.png)


Gene expression signature for a proximal distal group of neurons within the forebrain of an embryonic 13.5 day old mouse  
![](sample_images/mouse_slice_gene_exp.png)

## Vignettes
[Getting Started with brainmapr](vignettes/brainmapr-vignette.md)  
[Practical applications of brainmapr](vignettes/pagoda-vignette.md)
