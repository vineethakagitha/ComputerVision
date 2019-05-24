close all;
img_path = 'image_';
for i = 3:2:9
    img_path1 = strcat(img_path , num2str(i) , '.png');  
    img_path2 = strcat(img_path , num2str(i+1) , '.png');
    img1 = imread(img_path1);
    img2 = imread(img_path2);
    grimg1 = (rgb2gray(img1));
    grimg2 = (rgb2gray(img2));
   
    fil1 = imgaussfilt(grimg1,6);
    fil2 = imgaussfilt(grimg2,2);
    fil2 = grimg2 - fil2;
    
    hyb = (fil1/2 + fil2/2);
    %{
    figure(1);
    imshow(fil1);

    figure(2);
    imshow(fil2);
    %}
    
    f = figure(floor(i/2));
    imshow(hyb);
    saveas(f,strcat('output_',num2str(floor(i/2)),'.png'));

end
