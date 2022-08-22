//-------------------------------------------------------------------
// Macro to get the intensity of regions classified by labkit
// Need 2 images parts and 3 labkit classifiers (one for each channel
// and must enter save directory.
// Option to specify .roi file for cell regions, if not include macro
// will stop and wait for user to add regions to roi manager
// by Laura Cooper, Aug 2022 
// adapted from Meghane Sittewelle's IntensityROIanalysis, Aug 2022
// ImageJ 1.53q Java 1.8.0_322
//-------------------------------------------------------------------


//Set up files and directories
#@ File    (label = "Image part 1", style = "file") part1
#@ File    (label = "Image part 2", style = "file") part2
#@ File    (label = "Labkit Classifier - Channel 1", style = "file") Classifier1
#@ File    (label = "Labkit Classifier - Channel 2", style = "file") Classifier2
#@ File    (label = "Labkit Classifier - Channel 3", style = "file") Classifier3
#@ File    (label = "Cell regions (optional)", style = "file", required=false) cell_regions
#@ File    (label = "Saving directory", style = "directory") dirsave
//Clear roi manager and result table
roiManager("reset"); 
run("Clear Results")

//Open and concatenate image parts
open(part1);
stack1=getTitle()
open(part2);
stack2=getTitle()
run("Concatenate...", "open image1=["+stack1+"] image2=["+stack2+"]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=360 display=Color");

if (isNaN(cell_regions)) {
	// Load ROI file
	roiManager("Open", cell_regions);
} else {
	// Ask user to draw ROIs
	waitForUser("Draw regions for analysis and add to ROI manager, then click OK");
	roiManager("Save", dirsave+File.separator+"Cell_Regions.roi");
}

// Crop regions and Separate channels
n=roiManager("count");
for(j=0;j <n; j++){
    roiManager("select",j);
    run("Duplicate...", "title=Cell_"+j+" duplicate");
    totalCells = j+1;
}
roiManager("reset");
for(k=0;k <totalCells; k++){
    selectWindow("Cell_"+k);
    run("Split Channels");
    // Segment image with Labkit classifiers
    selectWindow("C1-Cell_"+k);
    run("Segment Image With Labkit", "segmenter_file=[" + Classifier1 + "] use_gpu=false");
    saveAs("Tiff", dirsave + File.separator + "C1-Cell_" +k+ "_segmentation" + ".tif");
    mask_and_measure("C1-Cell_" +k+ "_segmentation" + ".tif", "C1-Cell_"+k);
    run("Clear Results");
    selectWindow("C2-Cell_"+k);
    run("Segment Image With Labkit", "segmenter_file=[" + Classifier2 + "] use_gpu=false");
    saveAs("Tiff", dirsave + File.separator + "C2-Cell_" +k+ "_segmentation" + ".tif");
    mask_and_measure("C2-Cell_" +k+ "_segmentation" + ".tif", "C2-Cell_"+k);
    run("Clear Results");
    selectWindow("C3-Cell_"+k);
    run("Segment Image With Labkit", "segmenter_file=[" + Classifier3 + "] use_gpu=false");
    saveAs("Tiff", dirsave + File.separator + "C3-Cell_" +k+ "_segmentation" + ".tif");
    mask_and_measure("C3-Cell_" +k+ "_segmentation" + ".tif", "C3-Cell_"+k);
    run("Clear Results");
}
close("*");

// Make measurements from masked regions
function mask_and_measure(mask, original) {
	//mask - name of mask window
	//original - name of original image window
selectWindow(mask);
maskName = File.getNameWithoutExtension(mask);
//Create ROI for each frame
setThreshold(1, 255);
run("Create Selection");
for (i = 1; i <= nSlices; i++) {
	setSlice(i);
	run("Create Selection");
    Roi.setPosition(i);
    roiManager("Add");
}

// Save ROI
roiManager("Save", dirsave+File.separator+File.separator+"ROI_"+maskName+".roi");

//measure signal in mask selection
run("Set Measurements...", "area mean min median area_fraction stack redirect=None decimal=3");

selectWindow(original);
for (i = 1; i <= nSlices; i++) {
	setSlice(i);
    roiManager("Select", i-1);
    run("Measure");
}

//Save without overwritting the result file if existing 
selectWindow("Results");

i=0;
filename= dirsave+File.separator+"Results_"+maskName+".csv";
while (File.exists(filename)) {
	i=i+1;
	filename=dirsave+File.separator+"Results_"+maskName+"_"+i+".csv";
}
saveAs("Results", filename);
}





