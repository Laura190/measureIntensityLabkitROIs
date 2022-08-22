//-------------------------------------------------------------------
// Macro to get the intensity of regions around max intensity
// Image must be open before running macro
// Requires number of time frames to be projected, promience value
// for find maxima and radius of regions to be measured
// by Laura Cooper, Aug 2022 
// ImageJ 1.53q Java 1.8.0_322
//-------------------------------------------------------------------

#@ int (label="Number of time frames from end to project", value=5) numFrames
#@ int (label="Prominence value", value=100) prom
#@ int (label="Radius of regions", value=100) radius

image=getTitle();
projStart = nSlices-numFrames
run("Set Measurements...", "area mean min median area_fraction stack redirect=None decimal=3");
run("Z Project...", "start="+projStart+" projection=[Max Intensity]");
run("Find Maxima...", "prominence="+prom+" output=[Point Selection]");

roiManager("reset");
getSelectionCoordinates(xpoints, ypoints);
for (i=0; i<lengthOf(xpoints); i++) {
	makeOval(xpoints[i]-radius, ypoints[i]-radius, 2*radius, 2*radius);
	roiManager("Add");
}
selectWindow(image)
roiManager("Show All");
roiManager("Multi Measure");



