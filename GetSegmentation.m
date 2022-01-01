function [segmented_image] = GetSegmentation(input_image,mask)
    
  num_tiles = [8 8];
  nbins = 512;
  distribution = 'uniform';
  avg_filter_size = [9 9];
  binarization_threshold = 0.01;
  areaopen_size = 100;
  morphological_op = 'majority';
  segmented_image=VesselSegmentation(input_image,mask,num_tiles,nbins,distribution,avg_filter_size,binarization_threshold,areaopen_size,morphological_op);
end