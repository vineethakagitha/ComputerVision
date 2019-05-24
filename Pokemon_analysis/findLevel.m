function [level,cir_center] = findLevel(img)
 img = imread('./val/017_CP148_HP37_SD600_6259_31.png');
level = [327,165];
cir_center = [355,457];

I = rgb2gray(img);
% I = imcrop(I,[0 size(I,1)/10 size(I,2) size(I,1)/3]);
IPrewitt = edge(I,'Prewitt');
%imshow(IPrewitt);
[H,T,R] = hough(IPrewitt,'Theta',-90); 
HPeaks = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))));
HLines = houghlines(IPrewitt,T,R,HPeaks,'FillGap',50,'MinLength',20);

xmin = 9999999;
 for line = 1:length(HLines)
    point = [HLines(line).point1; HLines(line).point2];
    if(point(1,2) < xmin && point(1,2) > 100)
      minPoint = [HLines(line).point1; HLines(line).point2];
      xmin = point(1,2);
    end
 end
%try
[IP_x IP_y] = size(IPrewitt);
I1 = imcrop(IPrewitt,[0 0 IP_x minPoint(1,2)]);
%catch
%end
%try
[I_x I_y] = size(I);
I2 = imcrop(IPrewitt,[0 0 I_x minPoint(1,2)]);
%catch
%end
%figure, imshow(IPrewitt);
regions = regionprops(I1, 'Area', 'Perimeter','Centroid','MajorAxisLength','MinorAxisLength');
area = 0;
if size(regions,1)>0
    r = regions(1);
end
for i = 1:length(regions)
   if(regions(i).Area > area)
        area = regions(i).Area;
        r = regions(i);
   end
end

cir_center =  r.Centroid;
if size(I2,2) == 0
    I2 = IPrewitt;
end
[centers,radii] = imfindcircles(I2,[8 15],'ObjectPolarity','bright','Method','TwoStage','Sensitivity',0.85);

if isempty(centers)
 level = [IP_x/2 IP_y/4];
else
 level = centers(1,:);
end
figure;
imshow(I);
hold on;
% for i = 1:length(centers)
%   plot(centers(i,1),centers(i,2),'b*')
% end
plot(level(1),level(2),'b*');
plot(cir_center(1),cir_center(2),'g^');
% disp(level);
% disp(cir_center);
end