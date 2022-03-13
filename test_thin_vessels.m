%%
image = imread("images/21_training.tif");
im_mask = imread("mask/21_training_mask.gif");
resized_image = imresize(image, [584 565]);
SE = strel('disk', 3);
im_mask = imerode(im_mask, SE);
im_mask = im_mask/255;
green = resized_image(:,:,2); 
gray_image = im_mask.*green;

im_mask = double(im_mask);
figure;
imshow(gray_image);
double_depth_image = im2double(gray_image);
im_enh= adapthisteq(double_depth_image,'numTiles',[8 8],'nBins',256,'Distribution','uniform');
%%
im_thin_vess = MatchFilterWithGaussDerivative(im_enh, 1, 4, 12, im_mask, 2.3, 30);

%%
num_tiles = [8 8];
nbins = 512;
distribution = 'uniform';
avg_filter_size = [9 9];
binarization_threshold = 0.01;
areaopen_size = 100;
morphological_op = 'majority';
im_sel= VesselSegmentation("images/21_training.tif", "mask/21_training_mask.gif",num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op);
[im_final] = combine_thin_vessel(im_thin_vess,im_sel);
subplot(1,3,3),imshow(im_final),title('final image');
%%
[Accuracy, Sensitivity, Fmeasure, Precision, MCC, Dice, Jaccard, Specificity] = EvaluateImageSegmentationScores(imread("1st_manual/21_manual1.gif"), im_final);
%%
test