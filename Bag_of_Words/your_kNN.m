function predict_label = your_kNN(feat)
% Output should be a fixed length vector [num of img, 1]. 
% Please do NOT change the interface.
%predict_label = zeros(size(feat,1),1); %dummy. replace it with your own code
categories = ["Balloon"; "Beach" ;"Bird"; "Bobsled" ;"Bonsai" ;"Building" ;"Bus" ;"Butterfly";"Car"; "Cat" ;"Cougar"; "Dessert"; "Dog"; "Eagle" ;"Elephant" ;"Firework"; "Fitness";"Flag"; "Foliage";"Fox"; "Goat"; "Horse"; "Indoordecorate"; "Jewelry"; "Lion"; "Model"; "Mountain"; "Mushroom";"Owl"; "Penguin" ];
cats = [];
class_num = 30;
img_per_class = 5;
img_num = class_num .* img_per_class;
%class label Y
for i = 1:length(categories)
    for j=1:55
          cats((i-1)*55+j,:) = i;
    end
    
    %cats(i,:) = i;
end
%cats = reshape(cats,[],1);

% Extracted features of all trained images into train_feat
train_feat = trainFeatures();

%Feed Data 'train_feat' and class label 'cats' to KNN classifier
mb = fitcknn(train_feat,cats,'NumNeighbors',20,'Standardize',1);
%predict the category of each input image based on trained data.
predict_label = predict(mb,feat);
%{
IDX = knnsearch(train_feat,feat, 'k', 30*64, 'Distance', 'euclidean');
for i=1:150
    predict_label(i,:) = mode(floor((IDX(i,:)/55))+1);
end

for i=1:size(feat,1)
    predict_label(i,:) = findMatchedFeatures(train_feat,feat(i,:));
end
%}
end