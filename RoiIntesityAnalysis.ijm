//-------------------------------------------------------------------
// Macro to get the intensity of regions
// Need 2 images parts, a name for the results files and a save directory.
// Option to specify .roi file for cell regions, if not included macro
// will stop and wait for user to add regions to roi manager
// by Laura Cooper, Aug 2022 
// adapted from Meghane Sittewelle's IntensityROIanalysis, Aug 2022
// ImageJ 1.53q Java 1.8.0_322
//-------------------------------------------------------------------


//Set up files and directories
#@ File    (label = "Image part 1", style = "file") part1
#@ File    (label = "Image part 2", style = "file") part2
#@ File    (label = "Cell regions (optional)", style = "file", required=false) cell_regions
#@ String  (label = "Name results file") resultsName
#@ File    (label = "Saving directory", style = "directory") dirsave
//Clear roi manager and result table
roiManager("reset"); 
run("Clear Results")
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
print(minute, second, msec)
//Open and concatenate image parts
//open(part1);
run("TIFF Virtual Stack...", "open=["+part1+"]");
stack1=getTitle()
//open(part2);
run("TIFF Virtual Stack...", "open=["+part2+"]");
stack2=getTitle()
run("Concatenate...", "open image1=["+stack1+"] image2=["+stack2+"]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=360 display=Color");
rename("original");
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
print(minute, second, msec)

if (isNaN(cell_regions)) {
	// Load ROI file
	roiManager("Open", cell_regions);
} else {
	// Ask user to draw ROIs
	run("ROI Manager...");
	waitForUser("Draw regions for analysis and add to ROI manager, then click OK");
}

//measure signal in mask selection
run("Set Measurements...", "area mean min median area_fraction stack redirect=None decimal=3");
selectWindow("original");
roiManager("Save", dirsave+File.separator+"ROI_"+resultsName+".roi");
roiManager("Multi Measure");
Table.sort("Ch1")
//Save without overwritting the result file if existing 
selectWindow("Results");
i=0;
filename= dirsave+File.separator+resultsName+".csv";
while (File.exists(filename)) {
	i=i+1;
	filename=dirsave+File.separator+resultsName+"_"+i+".csv";
}
saveAs("Results", filename);





