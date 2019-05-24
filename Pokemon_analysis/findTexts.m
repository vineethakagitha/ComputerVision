function textBBoxes = findTexts(I,rio)

[mserRegions, mserConnComp] = detectMSERFeatures(I,'RegionAreaRange',[200 8000],'ThresholdDelta',4);
%disp mserRegions;
%disp(mserRegions);
% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');
%disp mserStats;
%disp(mserStats);
%disp(size(mserStats,1));
% Compute the aspect ratio using bounding box data.
bbox = vertcat(mserStats.BoundingBox);
if size(bbox,1) == 0
    [mserRegions, mserConnComp] = detectMSERFeatures(I,'RegionAreaRange',[100 10000],'ThresholdDelta',2);

    % Use regionprops to measure MSER properties
    mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');
    % Compute the aspect ratio using bounding box data.
    bbox = vertcat(mserStats.BoundingBox);
end
%{
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;
% Threshold the data to determine which regions to remove. These thresholds
% may need to be tuned for other images.
filterIdx = aspectRatio' > 1.5; 
filterIdx = filterIdx | [mserStats.Eccentricity] > .89 ;
filterIdx = filterIdx | [mserStats.Solidity] < .5;
filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.7;
filterIdx = filterIdx | [mserStats.EulerNumber] < -4;
%disp filteridx;
%disp(filterIdx);
%disp(size(filterIdx,2))
% Remove regions
if size(mserStats,1) > size(filterIdx,2)
    mserStats(filterIdx) = [];
end
if size(mserRegions,1) > size(filterIdx,2)
    mserRegions(filterIdx) = [];
end
%disp mserStats-Size;
%disp(size(mserStats,1));
regionImage = mserStats(size(mserStats,1)).Image;
regionImage = padarray(regionImage, [1 1]);

% Compute the stroke width image.
distanceImage = bwdist(~regionImage); 
skeletonImage = bwmorph(regionImage, 'thin', inf);

strokeWidthImage = distanceImage;
strokeWidthImage(~skeletonImage) = 0;
% Compute the stroke width variation metric 
strokeWidthValues = distanceImage(skeletonImage);   
strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);
% Threshold the stroke width variation metric
strokeWidthThreshold = 0.4;
strokeWidthFilterIdx = strokeWidthMetric > strokeWidthThreshold;
% Process the remaining regions
for j = 1:numel(mserStats)
    
    regionImage = mserStats(j).Image;
    regionImage = padarray(regionImage, [1 1], 0);
    
    distanceImage = bwdist(~regionImage);
    skeletonImage = bwmorph(regionImage, 'thin', inf);
    
    strokeWidthValues = distanceImage(skeletonImage);
    
    strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);
    
    strokeWidthFilterIdx(j) = strokeWidthMetric > strokeWidthThreshold;
    
end

% Remove regions based on the stroke width variation
if size(mserRegions,1) > 1 
mserRegions(strokeWidthFilterIdx) = [];
end
if  size(mserStats,1) > 1
mserStats(strokeWidthFilterIdx) = [];
end
%}

% Get bounding boxes for all the regions
bboxes = vertcat(mserStats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience

xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Expand the bounding boxes by a small amount.
expansionAmount = 0.02;
xmin = (1-expansionAmount) * xmin;
ymin = (1-expansionAmount) * ymin;
xmax = (1+expansionAmount) * xmax;
ymax = (1+expansionAmount) * ymax;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);
% Merge the boxes based on the minimum and maximum dimensions.
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
% Remove bounding boxes that only contain one text region
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup == 1, :) = [];

%imshow(I);

end