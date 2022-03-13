function segment_and_save()

% Creates segmentation for test images and masks and dumps the output

folder_images= 'dataset\test\images';
folder_mask='dataset\test\mask';
images= fullfile(folder_images, '*.tif');
image_files= dir(images);
mask= fullfile(folder_mask, '*.gif');
mask_files= dir(mask);
num_tiles = [8 8];
nbins = 512;
distribution = 'uniform';
avg_filter_size = [9 9];
binarization_threshold = 0.01;
areaopen_size = 100;
morphological_op = 'majority';

dir_test= "test";
foldername = "predicted_" + datestr(now,"ddmmyy") + "_" + datestr(now,"hhmmss");
fullpath = dir_test + "\" + foldername ;
disp(fullpath);
[status, msg, msgID] = mkdir(fullpath);

for i=1:length(image_files)
  name_image=image_files(i).name;
  name_mask= mask_files(i).name;
  image_route= fullfile(folder_images,name_image);
  mask_route= fullfile(folder_mask, name_mask);
  result_image= VesselSegmentation(image_route, mask_route,num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op);
  imwrite(result_image, fullfile(fullpath,append(sprintf("%d",i),".png")));

end

end
