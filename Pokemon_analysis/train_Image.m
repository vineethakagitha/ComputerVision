function train_Image()

img_path = './train/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
ID = zeros(img_num,1);
feat_dim = size(feature_extraction(imread('./train/001_CP14_HP10_SD200_3670_12.jpg')),2);
feat = zeros(img_num,feat_dim);
for i = 1:img_num
% for i = 11
    i
    close all;
    img = imread([img_path,img_dir(i).name]);
    % get ground truth annotation from image name
    name = img_dir(i).name;
    ul_idx = findstr(name,'_'); 
    ID(i) = str2num(name(1:ul_idx(1)-1));
%     destdirectory = './'+string(ID(i));
%     mkdir(destdirectory);   %create the directory
%     thisimage = name;
%     fulldestination = fullfile(destdirectory, thisimage);  %name file relative to that directory
%     imwrite(img, fulldestination);
    feat(i,:) = feature_extraction(img);
end
model = fitcknn(feat,ID,'NumNeighbors',5,'Standardize',1);
save('model.mat','model');
end