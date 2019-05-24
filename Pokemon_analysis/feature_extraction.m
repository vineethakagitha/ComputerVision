function feat = feature_extraction(I)
I = rgb2gray(I);
img = imcrop(I,[0 size(I,1)/8 size(I,2) size(I,1)/3]);
points = detectSURFFeatures(img);
pts = points.selectStrongest(30);
feat_extr = extractFeatures(img,pts);
%lbpFeatures = extractLBPFeatures(img,'CellSize',[64 64],'Interpolation','Nearest');
feat = mean(feat_extr);
end