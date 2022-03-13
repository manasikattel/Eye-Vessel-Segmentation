num_tiles=[[8 8];[16 16]];
nbins=[128 256 512];
distribution=["uniform","rayleigh","exponential"];
avg_filter_size=[[5 5];[9 9];[15 15]];
binarization_threshold=[0.005,0.01,0.02,0.03];
areaopen_size=[20,50,100,150,200];
morphological_op=["majority","clean"];


[a,b,c,d,e,f,g,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity] = deal([0 0],0,"a",[0 0],0,0,"a",0,0,0,0,0);
i =1;
t_final = table(a,b,c,d,e,f,g,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity);
n    = length(num_tiles) * length(nbins) * length(distribution) * length(avg_filter_size) * length(binarization_threshold) * length(areaopen_size) * length(morphological_op);
H    = waitbar(0, 'Please wait...');

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

                            a = num_tiles(tile,:);
                            b = nbins(bin);
                            c = distribution(dist);
                            d = avg_filter_size(fsize,:);
                            e = binarization_threshold(bthresh);
                            f = areaopen_size(aopensize);
                            g = morphological_op(morph);
                            t = table(a,b,c,d,e,f,g,mean_acc,mean_dice,mean_jaccard,mean_sensitivity,mean_specificity);                            
                            t_final = [t_final; t];
                            waitbar(i/n, H, sprintf('%d of %d', i, n));
                            i = i+1;

                        end
                    end
                end
            end
        end
    end
end

disp(t_final)



