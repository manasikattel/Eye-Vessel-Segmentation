%% Reading the input image and plotting it.
image= imread('images/21_training.tif');
mask= imread('mask/21_training_mask.gif');
figure;
imshow(image);
title('Input Image');
%% Resizing the image and enhancing contrast
resized_image = imresize(image, [584 565]);
SE = strel('disk', 3);
mask = imerode(mask, SE);
mask = mask/255;
green= resized_image(:,:,2);
gray_image = mask.*green;
figure;
imshow(gray_image);
title('Gray Image');

double_depth_image = im2double(gray_image);

double_depth_image = adapthisteq(double_depth_image,'numTiles',[8 8],'nBins',256);
double_depth_image= double_depth_image.^2;
figure;
imshow(double_depth_image);
%%
final_image1= imsubtract(double_depth_image, imopen(double_depth_image,strel('disk',3)));
final_image2= imclose(final_image1,strel('disk',3));
final_image3= imsubtract(double_depth_image,imopen(double_depth_image,strel('disk',3)));
final_image4= imsubtract(final_image2, final_image3);
%%
figure;
imshow(final_image4);
%%
figure;
imshow(imbinarize(final_image4,0.02))
%%  Doing the opening in 12 different directions and getting the maximum response. 
tetha= linspace(0,180,13);
tetha(end)=[];
structuring_element= strel('line',7,tetha(1));
final_opening= imopen(double_depth_image,structuring_element);
for i= 2:numel(tetha)
    structuring_element= strel('line',7,tetha(i));
    temporal_opening= imopen(double_depth_image, structuring_element);
    %A= final_opening;
    %A(temporal_opening>A)= temporal_opening(temporal_opening>A);
    final_opening= max(final_opening, temporal_opening);
end 
%% Reconstructing the image. 
smoothed_image= imreconstruct(final_opening,double_depth_image);
figure;
imshow(smoothed_image);
%% Smoothing the image. 
average_filter= fspecial('average',[15 15]);
smoothed_image2= imfilter(final_opening, average_filter);
figure;
imshow(smoothed_image2);
%% Border detection.
final_image= imsubtract(smoothed_image2, smoothed_image);
figure;
imshow(final_image);

final_image = final_image.*double(mask);
imshow(final_image);
%% Binarizing the image border detected image 
%t= isodata(final_image);
final_image= imbinarize(final_image,0.02);
figure;
imshow(final_image);
%% Filling empty spaces
opened_image= bwareaopen(final_image,200);
figure;
imshow(opened_image);
%%
bridge = bwmorph(opened_image,'majority');
figure;
imshow(bridge);
%%
[Accuracy, Sensitivity, Fmeasure, Precision, MCC, Dice, Jaccard, Specitivity] = EvaluateImageSegmentationScores(imread('1st_manual/21_manual1.gif'),bridge);
