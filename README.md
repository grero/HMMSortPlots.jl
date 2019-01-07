# HMMSortPlots.jl
An attempt at a GUI for viewing the results of HMM based spike sorting.

## Usage
To view the sorting resutls contained in the file hmmsort.mat, using highpass data from the file highpassdata.mat

```julia
using HMMSortPlots
scene = HMMSortPlots.plot_sorting("highpassdata.mat", "hmmsort.mat")
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
There are two sliders for the plot; the right-hand slider (labeled t0) sets the first time point of the point and the left slider sets the window, i.e. how much time after t0 to include. One can pan the plot either by dragging the t0 slider, or by left-clicking anywhere in the plot itself. Doing so will set the clicked point as the new t0. For panning backwards in time, use right-click instead. This will move t0 to the clicked point minus the value of the window slider. 
For zoomin, one can use the window slider to decrease the amount of time plotted (zoom in) or increase it (zoom out).
