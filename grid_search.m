num_tiles=[[8 8];[16 16]];
nbins=[128 256 512];
distribution=["uniform","rayleigh","exponential"];
avg_filter_size=[[5 5];[9 9];[15 15]];
binarization_threshold=[0.005,0.01,0.02,0.03];
areaopen_size=[20,50,100,150,200];
morphological_op=["majority","clean"];
[tile,bin,dist,fsize,bthresh,aopensize,morph,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity] = deal(0,0,0,0,0,0,0,0,0,0,0,0);
t_final = table(tile,bin,dist,fsize,bthresh,aopensize,morph,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity );
for tile=1:length(num_tiles)
    for bin=1:length(nbins)
        for dist=1:length(distribution)
            for fsize=1:length(avg_filter_size)
                for bthresh=1:length(binarization_threshold)
                    for aopensize=1:length(areaopen_size)
                        for morph=1:length(morphological_op)
                            %try
                            [mean_acc, mean_dice, mean_jaccard, mean_sensitivity, mean_specificity] = test(num_tiles(tile,:),nbins(bin),distribution(dist),avg_filter_size(fsize,:), binarization_threshold(bthresh),areaopen_size(aopensize),morphological_op(morph));
                            %catch
                            %disp(avg_filter_size(fsize,:));
                            %end
                            t = table(tile,bin,dist,fsize,bthresh,aopensize,morph,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity);
                            t_final = [t_final; t];
                        end
                    end
                end
            end
        end
    end
end

disp(t_final)


