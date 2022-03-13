function [mean_acc, mean_dice, mean_jaccard, mean_sensitivity, mean_specificity] = test(num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op)                                                         

% Error metrics for training images

folder_images= 'dataset\training\images';
folder_mask='datsaset\training\mask';
folder_gt= 'dataset\training\1st_manual';
images= fullfile(folder_images, '*.tif');
image_files= dir(images);
mask= fullfile(folder_mask, '*.gif');
mask_files= dir(mask);
gt= fullfile(folder_gt, '*.gif');
gt_files= dir(gt);
accuracy= zeros(20,1);
dice_score= zeros(20,1);
jaccard_index= zeros(20,1);
sensitivity= zeros(20,1);
specificity= zeros(20,1);
for i=1:length(image_files)
  name_image=image_files(i).name;
  name_mask= mask_files(i).name;
  name_gt= gt_files(i).name;
  image_route= fullfile(folder_images,name_image);
  mask_route= fullfile(folder_mask, name_mask);
  gt_route= fullfile(folder_gt, name_gt);                           
  image_gt= imread(gt_route);
%   num_tiles = [8 8];
%   nbins = 512;
%   distribution = 'uniform';
%   avg_filter_size = [9 9];
%   binarization_threshold = 0.01;
%   areaopen_size = 100;
%   morphological_op = 'majority';
  result_image= VesselSegmentation(image_route, mask_route,num_tiles,nbins,distribution,avg_filter_size, binarization_threshold,areaopen_size,morphological_op);
  try
      [Accuracy, Sensitivity, Fmeasure, Precision, MCC, Dice, Jaccard, Specificity] = EvaluateImageSegmentationScores(image_gt, result_image);
  catch
      disp(class(name_gt));
      disp(class(result_image));
  end
  accuracy(i)= Accuracy;
  dice_score(i)= Dice;
  jaccard_index(i)= Jaccard;
  sensitivity(i)= Sensitivity;
  specificity(i)= Specificity;
end 
mean_acc= mean(accuracy);
mean_dice= mean(dice_score);
mean_jaccard= mean(jaccard_index);
mean_sensitivity= mean(sensitivity);
mean_specificity= mean(specificity);

end
