%Input Image
image= imread('images/21_training.tif');
mask= imread('mask/21_training_mask.gif');
figure;
imshow(image);
title('Input Image');
%%
resized_image= imresize(image, [584 565]);
double_depth_image = im2double(resized_image);
gray_image= rgb2gray(double_depth_image);
gray_image= adapthisteq(gray_image,'numTiles',[8 8],'nBins',512);
figure;
imshow(gray_image);
title('Gray Image');
%%
gray_imag2= rgb2gray(image);
[red, green , ~]= imsplit(image);
if gray_imag2== green
    disp('Yes');
else
    disp('No');
end 
%%
tetha= linspace(0,180,13);
tetha(end)=[];
structuring_element= strel('line',7,tetha(1));
final_opening= imopen(gray_image,structuring_element);
for i= 2:numel(tetha)
    structuring_element= strel('line',7,tetha(i));
    temporal_opening= imopen(gray_image, structuring_element);
    A= final_opening;
    A(temporal_opening>A)= temporal_opening(temporal_opening>A);
    final_opening= max(final_opening, temporal_opening);
end 
%%
smoothed_image= imreconstruct(final_opening,gray_image);
figure;
imshow(smoothed_image);
%%
average_filter= fspecial('average',[9 9]);
smoothed_image2= imfilter(smoothed_image, average_filter);
figure;
imshow(smoothed_image2);
%%
%border detection
final_image= imsubtract(smoothed_image2, smoothed_image);
figure;
imshow(final_image);
final_image= imbinarize(final_image,0.02);
imshow(final_image);
%%

%%
final_image= medfilt2(final_image);
figure;
imshow(final_image);
%%
figure;
final_image= imbinarize(final_image,0.04);
imshow(final_image);
final_image= medfilt2(final_image);
%%
final_image= contraharmonic_filter(final_image,-2,1);
figure;
imshow(final_image);
%%
opened_image= bwareaopen(final_image, 25);
figure;
imshow(opened_image);
se = strel('disk', 2);
closed = imclose(opened_image, se);
figure;
imshow(closed);
%%
figure;
imhist(final_image);
%%
figure;
imshow(imbinarize(final_image,0.02));
figure;
imshow(imbinarize(final_image,0.04));
%%
final_image= imbinarize(final_image,0.02);
% figure;
% imshow(final_image);
opened_image= bwareaopen(final_image, 25);
% figure;
% imshow(opened_image);
se = strel('disk', 2);
closed = imclose(opened_image, se);
figure;
imshow(closed);
%%
final_image= medfilt2(closed);
figure;
imshow(final_image);
%%
imagen_final= contraharmonic_filter(final_image,-3,1);
%%

imshow(gray_image);
figure;
imshow(final_image);
opened_image= bwareaopen(final_image, 25);
se= strel('disk',2);
closed= imclose(final_image, se);
figure;
imshow(closed);

%%
Image_top_transform=0;
for i = 1:numel(tetha)
   structuring_element= strel('line',7,tetha(i));
   Image_top_transform= Image_top_transform + imtophat(closed, structuring_element);
end 
%%
subplot(1,2,1);
imshow(closed);
subplot(1,2,2);
imshow(Image_top_transform);
%%
figure;
imshow(Image_top_transform);
title('Top transformed image');
%%
figure;
imshow(gray_image);
figure;
new_image= medfilt2(Image_top_transform);
imshow(new_image);
%%
Gaussian_filtered_image= imgaussfilt(new_image, 7/4);
figure;
imshow(Gaussian_filtered_image);
title('Gaussian filtered image')