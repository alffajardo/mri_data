#!/usr/bin/Rscript

args <- commandArgs(T)

dataset <- as.character(args[1])
roi <- as.character(args[2])
output <- as.character(args[3])
library(magrittr)
library(oro.nifti)
library(neurobase)

## read data
func <- RNifti::readNifti(dataset)
roi <- readNIfTI(roi,reorient = FALSE)
d <- dim(func)

### creat mask
func_mask <- niftiarr(img= roi, arr = 0)
func_mask@.Data <- func[,,,1]
func_mask[func_mask !=0] <- 1

### time series
ts <- matrix(func[roi!=0],ncol = d[4]) %>%
      colMeans()
## linearize data and compute correlation matrix
rvalues <- matrix(func[func_mask !=0],ncol=d[4]) %>%
          apply(.,1,cor,ts)
          
### reshape computed data to create whole brain map
rmap <- func_mask
rmap[rmap !=0] <- rvalues

### write output in nifti format
write_nifti(rmap,output)
