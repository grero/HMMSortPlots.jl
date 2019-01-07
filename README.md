# HMMSortPlots.jl
An attempt at a GUI for viewing the results of HMM based spike sorting.

## Usage
To view the sorting resutls contained in the file hmmsort.mat, using highpass data from the file highpassdata.mat

```julia
using HMMSortPlots
scene = plot_sorting("highpassdata.mat", "hmmsort.mat")
```
Note that the structures in highpassdata.mat and hmmsort.mat should conform to the following

```julia
julia> names(HDF5.h5open("hmmsort.mat"))
5-element Array{String,1}:
 "cinv"
 "ll"
 "mlseq"
 "samplingRate"
 "spikeForms"
 
 julia> HDF5.h5open("highpassdata.mat") do ff
 names(ff["rh/data"])
 end
 5-element Array{String,1}:
 "analogData"
 "analogInfo"
 "analogTime"
 "timeStamps"
 "trialIndices"
```
