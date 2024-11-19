# Folder description

This directory contains the (i) input image/dataset, (ii) output image results when applying the combination of invariant and clustering algorithms, and (iii) a spreadsheet with summary statistics to compare the performance of image segmentation when applying combinations of invariant and clustering algorithms.


## Folder data

Experiment input data. It contains two types of images, one with metallic pieces (image) and another one created from a transformation of the first one used to evaluate the segmentation results (groundtruth). 
For each one of these images, a so-called groundtruth image has been created. This image represents the ideal result that would
be obtained through the image segmentation method if applied perfectly.
The ideal image is encoded in black and white (B/W), where white pixels
correspond to areas of the metallic piece, and black pixels to everything else.



## Folder results
Contains the images resulting from the experimentation. The file name includes the name of the algorithms used and a number with the result of the evaluation. The number refers to the percentage of matching pixels of the result image when compared to the ground_truth image.

The following file naming convention is used:
-imageName__algorithmInvariant.jpg
-Image__algorithmGrouping_numberOfCentres_c_certain_%.jpg
-imageName__algorithmInvariant_algorithmGrouping_numberOfCentres_c_certain_%.jpg


## Spreedsheet file

Statistical summary of the evaluation data when applying the combination of illumination invariant and clustering algorithms using 2 and 3 groups/centres on the whole set of input images(data).
