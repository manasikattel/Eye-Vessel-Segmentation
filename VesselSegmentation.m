function [im_final] = VesselSegmentation(image,mask,num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op)

% Vessel Segmentation for single image

% image = imread(image);
% mask = imread(mask);
% resized_image = imresize(image, [584 565]);
% mask = imresize(mask, [584 565]);
SE = strel('disk', 4);
mask = imerode(mask, SE);
mask = mask/255;
resized_image= image;
green = resized_image(:,:,2);
gray_image= green;
    
double_depth_image = im2double(gray_image);


double_depth_image = adapthisteq(double_depth_image,'numTiles',num_tiles,'nBins',nbins,'Distribution',distribution);
im_thin_vess = MatchFilter(double_depth_image, 1, 4, 12, double(mask), 2.3, 30);
tetha = linspace(0,180,13);
tetha(end) = [];
structuring_element = strel('line',7,tetha(1));
final_opening = imopen(double_depth_image,structuring_element);
for i= 2:numel(tetha)
    structuring_element = strel('line',7,tetha(i));
    temporal_opening = imopen(double_depth_image, structuring_element);
    final_opening = max(final_opening, temporal_opening);
end 

smoothed_image= final_opening;
average_filter = fspecial('average',avg_filter_size);
smoothed_image2 = imfilter(final_opening, average_filter);
final_image = imsubtract(smoothed_image2, smoothed_image);
final_image = final_image.*double(mask);
final_image = imbinarize(final_image, binarization_threshold);

opened_image = bwareaopen(final_image, areaopen_size);
result_image = bwmorph(opened_image,morphological_op);
im_final= combine_two_methods(im_thin_vess, result_image);
end 