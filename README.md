# Eye Vessel Segmentation

Morphology of vessels is an important indicator for the detection and evaluation of various diseases such as Diabetic Retinopathy, Glaucoma, Hypertension.

This project is a part of coursework Image processing in first semester of [Masters in Medical Imaging and Applications (MAIA)] (https://maiamaster.udg.edu/). The objective of the project is to Segment the eye vessels using morphological methods and classical image processing techniques. 


## Instructions for use

### Download dataset 

Download the dataset from [DRIVE Grand Challenge] (https://drive.grand-challenge.org/)

### To run the GUI 

1. Open `gui.mlapp`.
2. Run
3. Upload Eye image and Mask
4. Choose if you want to use uploaded mask or use automatic mask


### To run grid search

1. Open `grid_search.m`
2. Add the parameters you want to perform the search on.
3. Run the grid search file 

 ## Algorithm

* Green Channel extraction
* Contrast Enhancement
* Matched Filter
* Morphological Method
* Combine two methods

<p align=center>
<img src="https://github.com/manasikattel/-Eye-Vessel-Segmentation/blob/master/figures/main_algorithm.png">
</p>

### Morphological Method

<p align=center>
<img src="https://github.com/manasikattel/-Eye-Vessel-Segmentation/blob/master/figures/morphological.png">
</p>

### Matched Filter Method


<p align=center>
<img src="https://github.com/manasikattel/-Eye-Vessel-Segmentation/blob/master/figures/matched_filter.png">
</p>


## Results
Our Dice Scores for the 20 test images:

<p align=center>
<img src="https://github.com/manasikattel/-Eye-Vessel-Segmentation/blob/master/figures/results.png">
</p>