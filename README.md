# Measure Intensity of Labkit ROIs
## Laura Cooper, camdu@warwick.ac.uk
Adapted from Meghane Sittewelle's IntensityROIanalysis, Aug 2022

This macro gets the intensity of regions classified by labkit.

It requires 2 images parts and 3 labkit classifiers (one for each channel) and a directory for saving the results.
There is an option to specify .roi file for the cell regions. If a file is not given, the macro will stop and wait for user to add regions to ROI manager

Note that the results window must be cleared between measurements so may appear empty, however the results files saved in the output directory should contain the measurments.

Developed and tested using ImageJ 1.53q Java 1.8.0_322
