# Measure Intensity of ROIs
## Laura Cooper, camdu@warwick.ac.uk
Adapted from Meghane Sittewelle's IntensityROIanalysis, Aug 2022


### LabkitRoiIntensityAnalysis.ijm
This macro gets the intensity of regions classified by labkit.

It requires 2 images parts and 3 labkit classifiers (one for each channel) and a directory for saving the results.
There is an option to specify .roi file for the cell regions. If a file is not given, the macro will stop and wait for user to add regions to ROI manager

Note that the results window must be cleared between measurements so may appear empty, however the results files saved in the output directory should contain the measurments.

### RoiIntensityAnalysis.ijm
This macro measures intensity of regions selected by user

It requires 2 images parts, a name for the results files and a directory for saving the results.
There is an option to specify .roi file for the cell regions. If a file is not given, the macro will stop and wait for user to add regions to ROI manager

The measurements are sorted by channel. The Ch# column indicates which channel is being measured. Each column is a measurment with a number at the end.  Each number refers to an ROI, there are 8 columns per ROI.


### TwoStacks2Hyperstack.ijm
Creates a hyperstack from two image stacks

It requires 2 images parts

Developed and tested using ImageJ 1.53q Java 1.8.0_322
