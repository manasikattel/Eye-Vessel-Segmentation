function [result_image] = VesselSegmentation(image,mask,num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op)

image = imread(image);
mask = imread(mask);
resized_image = imresize(image, [584 565]);
SE = strel('disk', 3);
mask = imerode(mask, SE);
mask = mask/255;
green = resized_image(:,:,2);
gray_image = mask.*green;
    
double_depth_image = im2double(gray_image);

%try
double_depth_image = adapthisteq(double_depth_image,'numTiles',num_tiles,'nBins',nbins,'Distribution',distribution);
%catch
%    display(num_tiles)
%end
double_depth_image = double_depth_image.^2;

tetha = linspace(0,180,13);
tetha(end) = [];
structuring_element = strel('line',7,tetha(1));
final_opening = imopen(double_depth_image,structuring_element);
for i= 2:numel(tetha)
    structuring_element = strel('line',7,tetha(i));
    temporal_opening = imopen(double_depth_image, structuring_element);
    final_opening = max(final_opening, temporal_opening);
end 

smoothed_image = imreconstruct(final_opening,double_depth_image);

average_filter = fspecial('average',avg_filter_size);
smoothed_image2 = imfilter(final_opening, average_filter);

final_image = imsubtract(smoothed_image2, smoothed_image);
final_image = final_image.*double(mask);

final_image = imbinarize(final_image, binarization_threshold);

opened_image = bwareaopen(final_image, areaopen_size);
result_image = bwmorph(opened_image,morphological_op);


end 