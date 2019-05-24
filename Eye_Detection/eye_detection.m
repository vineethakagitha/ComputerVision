% Please edit this function only, and submit this Matlab file in a zip file
% along with your PDF report

function [left_x, right_x, left_y, right_y] = eye_detection(img)
% INPUT: RGB image
% OUTPUT: x and y coordinates of left and right eye.
% Please rewrite this function, and submit this file in Canvas (in a zip file with the report). 
left_x = 100;
right_x = 300;
left_y = 50;
right_y = 50;
grimg = rgb2gray(img);
grimg = imsharpen(grimg);
grimg = localcontrast(grimg,0.7,0.5);
%grimg = edge(grimg,'zerocross',0.020);
%[centers,radii] = imfindcircles(grimg,[2,25],'Sensitivity',0.80)
%rp=regionprops(grimg,grimg>200,'WeightedCentroid')
%centers = rp.WeightedCentroid;
%plot(centers,'r*');
%hBright = viscircles(centers(1:2,:), radii(1:2,:),'Color','b');
points = detectBRISKFeatures(grimg,'MinContrast',0.7);
pts = points.selectStrongest(5);
n = size(pts,1);
if isempty(pts) || n<5
    grimg = localcontrast(grimg,0.5,0.3);
    points = detectBRISKFeatures(grimg,'MinContrast',0.7);
    pts = points.selectStrongest(5);
    if isempty(pts)
        return
    end
end
point1 = pts.Location(1,:);
left_x = point1(1);
left_y = point1(2);
i = 2
if n>1
    point2= pts.Location(2,:);
    dist = sqrt( (pts.Location(1,1)-pts.Location(i,1)).^2 + (pts.Location(1,2)-pts.Location(i,2)).^2 );
    while i<n && dist<90 
        i = i+1
        dist=sqrt( (pts.Location(1,1)-pts.Location(i,1)).^2 + (pts.Location(1,2)-pts.Location(i,2)).^2 );
        point2 = pts.Location(i,:);
    end
    if point1(1) < point2(1)
        left_x = point1(1);
        left_y = point1(2);
        right_x = point2(1);
        right_y = point2(2);
    else
        left_x = point2(1);
        left_y = point2(2);
        right_x = point1(1);
        right_y = point1(2);
    end
end
end