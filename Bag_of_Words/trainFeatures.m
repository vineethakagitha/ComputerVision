function feat_extr = trainFeatures()
img_path = '../train/';
class_num = 30;
img_per_class = 55;
img_num = class_num .* img_per_class;
label = zeros(img_num,1);
folder_dir = dir(img_path);
feat_dim = size(feature_extraction(imread('../train/Flag/461030.JPG')),2);
feat = zeros(img_num,feat_dim);
disp(length(folder_dir));

for i = 1:length(folder_dir)-2
    
    img_dir = dir([img_path,folder_dir(i+2).name,'/*.JPG']);
    if isempty(img_dir)
        img_dir = dir([img_path,folder_dir(i+2).name,'/*.BMP']);
    end
    disp(i);
    label((i-1)*img_per_class+1:i*img_per_class) = i;
    
    for j = 1:length(img_dir)        
        img = imread([img_path,folder_dir(i+2).name,'/',img_dir(j).name]);
        feat((i-1)*img_per_class+j,:) = feature_extraction(img);
    end
    
end
%[idx,C] = kmeans(feat,30);
%feat_extr = C;
feat_extr = feat;
end
