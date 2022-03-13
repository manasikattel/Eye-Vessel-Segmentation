% Adapted from https://github.com/farkoo/Retinal-Vessel-Segmentation
% Retinal vessel extraction by matched filter with first-order derivative of Gaussian
% 
% Inputs: 
%       img = input image
%       sigma = scale value 
%       yLength = length of neighborhood along y-axis 
%       numOfDirections = number of orientations
%       mask = image mask 
%       c_value = c value
%       t = threshold value of region props
% Output:
%       vess = vessels extracted
function [vess] = MatchFilter(img, sigma, yLength, numOfDirections, mask, c_value, t)

    if isa(img,'double')~=1 
        img = double(img);
    end
    [rows,cols] = size(img);
    MatchFilterRes(rows,cols,numOfDirections) = 0;
    GaussDerivativeRes(rows,cols,numOfDirections) = 0;

    for i = 0:numOfDirections-1
        matchFilterKernel = MatchFilterAndGaussDerKernel(sigma,yLength, pi/numOfDirections*i, 0);
        gaussDerivativeFilterKernel = MatchFilterAndGaussDerKernel(sigma, yLength, pi/numOfDirections*i, 1);
        MatchFilterRes(:,:,i+1) = conv2(img,matchFilterKernel,'same');
        GaussDerivativeRes(:,:,i+1) = (conv2(img,gaussDerivativeFilterKernel,'same')); 
    end
    matchfilter_maxres = max(MatchFilterRes,[],3);
    gaussderivative_maxres = max(GaussDerivativeRes,[],3);

    D = gaussderivative_maxres;
    W = fspecial('average', 31);
    Dm = imfilter(D, W);

    %Normalization
    Dm = Dm - min(Dm(:));
    Dm = Dm/max(Dm(:));
    
    %muH = mean value of response image H 
    H = matchfilter_maxres;
    c = c_value;
    muH = mean(H(:));
    Tc= c*muH;
    
    T = (1 + Dm) * Tc;  
    
    %Thresholded_image 
    Mh = (H >= T);
    vess = Mh & mask;
    se = strel('square',3);
    vess = imclose(vess,se);
    vess = bwmorph(vess,'close');
    
    %Connected components
    [L, num] = bwlabel(vess, 8);

    
    prop = regionprops(L, 'Area');
    
    % Finding regions greater than 30 pixels 
    idx = find([prop.Area] > t);
    
    vess = ismember(L,idx);

end