function [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
% Please DO NOT change the interface
% INPUT: image; model(a struct that contains your classification model, detector, template, etc.)
% OUTPUT: ID(pokemon id, 1-201); level(the position(x,y) of the white dot in the semi circle); cir_center(the position(x,y) of the center of the semi circle)

% Replace these with your code
ID = 1;
CP = 130;
HP= 26;
stardust = 000;
level = [327,165];
cir_center = [355,457];
% Load an image.
%I = rgb2gray(imread('./train/018_CP397_HP65_SD800_4411_4.jpg'));
I =  rgb2gray(img);
[m n] = size(I);
I = medfilt2(I);
I1 = imcrop(I,[0 size(I,1)/3 size(I,2) size(I,1)/4]);
textBBoxes = findHP(I1);
ocrtxt = ocr(I1, textBBoxes);
%imshow(I2);
word  = "";
hpExpr = "HP";
for i=1:size(ocrtxt,1)
    word = ocrtxt(i,1).Text;
    %disp(word);
    if isempty(strfind(word, hpExpr)) == 0
        [startI,endI] = regexp(word,"HP");
        af = extractAfter(word,endI);
        bf = extractBefore(word,startI);
        if contains(af,"\d\d")
            HP = string(regexp(af,"(\d+)",'tokens'));
            break
        else 
            HP = string(regexp(bf,"(\d+)",'tokens'));
            break
        end
    end
    if isempty(strfind(word, "/")) == 0
        [startI,endI] = regexp(word,"/");
        bf = extractBefore(word,startI);
        if contains(bf,"\d\d")
            HP = string(regexp(bf,"(\d+)",'tokens'));
            break
        end
    end
end
%figure;
%imshow(I1)   
%     try
% I3 = imcrop(I,[0 0 size(I,2) size(I,1)/4]);
%     catch
%         I3= I;
%     end
%imshow(I2)
I2 = imcrop(I,[0 0 size(I,2) size(I,1)/4]);
textBBoxes = findTexts(I2);

ocrtxt = ocr(I2, textBBoxes);
word = "";
cpExpr = "P";
for i=1:size(ocrtxt,1)
    word = ocrtxt(i,1).Text;
    %disp(word);
    if isempty(strfind(word, cpExpr)) == 0
        [StartIndex,EndIndex] = regexp(word,"P");
        af = extractAfter(word,EndIndex);
        CP = string(regexp(af,"(\d+)",'tokens'));
        break
    end
    match = string(regexp(word,"\d+",'match'));
    if size(match,1)>=1
        CP = match(1);
    end
end
%imshow(I2);
% try
% I4 = imcrop(I,[0 size(I,2) size(I,1) 2*size(I,2)/3]);
% I4 = imcrop(I4,[0 size(I4,2)/4 size(I4,1) size(I4,2)/4]);
%     catch
%         I4 = I;
%     end
%imshow(I3)

I3 = imcrop(I,[0 3*size(I,1)/4 size(I,2) size(I,1)/8]);
textBBoxes = findTexts(I3);
ocrtxt = ocr(I3, textBBoxes);
word = "";
for i=1:size(ocrtxt,1)
    word = ocrtxt(i,1).Text;
    %disp(word);
    if size(stardust,2)==0 || stardust == 000 
        stardust = string(regexp(word,"(\d+)",'match'));
        if size(stardust,1)>=1
        stardust = stardust(1);
        end
        stardust = str2double(stardust);
        break
    end
end
%imshow(I3);
if size(HP,2) == 0
    HP = 26;
end
if size(HP,2)>1
    HP = HP(1);
end
if size(stardust,2) == 0
    stardust = 600;
end
if size(stardust,2) > 1
    stardust = stardust(1);
end
if size(CP,2) == 0
    CP = 130;
end
if size(CP,2)>1
    CP = CP(1);
end
disp CP=
disp(CP)
disp HP=
disp(HP)
disp stardust=
disp(stardust)
CP = str2double(CP);
HP = str2double(HP);
I4 = imcrop(I,[0 size(I,1)/8 size(I,2) size(I,1)/3]); 
imshow(I4);
disp ID=
ID =  predict(model,feature_extraction(img));
disp(ID)

[level,cir_center] = findLevel(img);
end
