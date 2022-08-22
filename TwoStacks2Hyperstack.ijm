//-------------------------------------------------------------------
// Macro to get the intensity of regions
//Create hyperstack from two image stacks
// by Laura Cooper, Aug 2022 
// ImageJ 1.53q Java 1.8.0_322
//-------------------------------------------------------------------


//Set up files and directories
#@ File    (label = "Image part 1", style = "file") part1
#@ File    (label = "Image part 2", style = "file") part2

//Open and concatenate image parts
run("TIFF Virtual Stack...", "open=["+part1+"]");
stack1=getTitle()
run("TIFF Virtual Stack...", "open=["+part2+"]");
stack2=getTitle()
run("Concatenate...", "open image1=["+stack1+"] image2=["+stack2+"]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=360 display=Color");
rename("original");





