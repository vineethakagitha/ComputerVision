function feat = feature_extraction(img)
% Output should be a fixed length vector [1*dimension] for a single image. 
% Please do NOT change the interface.
%feat = rand([1,100]); % dummy, replace this with your algorithm
grimg = rgb2gray(img);
points = detectSURFFeatures(grimg);
pts = points.selectStrongest(30);
feat_extr = extractFeatures(grimg,pts);
%feat_extr = reshape(feat_extr,1,[]);
%disp(size(feat_extr,2));
%extra = ((30*64)-size(feat_extr,2));
%disp(extra); 
%if pts.Count<100
 %feat_extr = [feat_extr zeros(1,extra)];
%end
mn = mean(feat_extr);
%y=find((feat_extr-mn)<(0.5*mn)); %Finding indices of all elements whose difference with the value specified is 0.5. (Here my error tolerance is 0.5)
%feat=feat_extr;
feat = mn;
end