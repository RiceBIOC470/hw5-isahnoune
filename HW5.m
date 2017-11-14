%HW5
%GB comments:
1a 70 question asks to output a file in the repository of the mask image. No image provided
1b 100 need to invert the image. Could have benefited from cleaning up the image some more by removing the spectled areas using bwareaopen. 
1c 70 same issue has 1a. 
1d 100
2yeast: 100
2worm: 90 Mask here is pretty messy. The edge space of the image are not properly removed and there is a lot of speckled small masks that litter the image. This should be removed from the image.  
2bacteria: 90 bacteria could use significant improvement in the segmentation. Currently most mask objects are connected. This could be reduced with a simple line of code using imerode. Alternatively, you could use some more complex like watershed. 
2phase: 100 
Overall: 90

% Note. You can use the code readIlastikFile.m provided in the repository to read the output from
% ilastik into MATLAB.

%% Problem 1. Starting with Ilastik

% Part 1. Use Ilastik to perform a segmentation of the image stemcells.tif
% in this folder. Be conservative about what you call background - i.e.
% don't mark something as background unless you are sure it is background.
% Output your mask into your repository. What is the main problem with your segmentation?  

%Many of the cells overlap and are not well defined

% Part 2. Read you segmentation mask from Part 1 into MATLAB and use
% whatever methods you can to try to improve it. 

data_segment = h5read('Segmentation (Label 1).h5', '/exported_data');
data_segment = squeeze(data_segment);
imshow(data_segment, [])

radius = 4;
sigma = 2;
smbgsub = smoothingbackground(data_segment, radius, sigma);
imshow(smbgsub, []);
img_bw = auto_threshold(data_segment);

mask = binarymask(smbgsub);
cleaned = cleanedmask(mask, 1);

% Part 3. Redo part 1 but now be more aggresive in defining the background.
% Try your best to use ilastik to separate cells that are touching. Output
% the resulting mask into the repository. What is the problem now?

%The cells, while more defined, appear more eroded

% Part 4. Read your mask from Part 3 into MATLAB and try to improve
% it as best you can.

data_segmenting = h5read('Segmentation2(Label 1).h5', '/exported_data');
data_segmenting = squeeze(data_segmenting);
imshow(data_segmenting, [])

radius = 4;
sigma = 2;

smbgsub = smoothingbackground(data_segmenting, radius, sigma);
imshow(smbgsub, []);

img_bw = auto_threshold(data_segmenting);

%% Problem 2. Segmentation problems.

% The folder segmentationData has 4 very different images. Use
% whatever tools you like to try to segement the objects the best you can. Put your code and
% output masks in the repository. If you use Ilastik as an intermediate
% step put the output from ilastik in your repository as well as an .h5
% file. Put code here that will allow for viewing of each image together
% with your final segmentation. 

bacteria = h5read('Bacteria(Label 1).h5', '/exported_data');
bacteria = squeeze(bacteria);
imshow(bacteria, [])
radius = 4;
sigma = 2;
smbgsub = smoothingbackground(bacteria, radius, sigma);
imshow(smbgsub, []);

worms = h5read('Worms(Label 1).h5', '/exported_data');
worms = squeeze(worms);
imshow(worms, [])
radius = 4;
sigma = 2;
smbgsub = smoothingbackground(worms, radius, sigma);
imshow(smbgsub, []);

yeast = imread('./segmentationData/yeast.tif');
yeast = yeast > 55;
imshow(yeast,[]);
yeast = imdilate(yeast,strel('disk',5));
yeast2 = imfill(yeast,'holes');
imshow(yeast2,[]);
yeast = imsubtract(yeast2,yeast);
imshow(yeast,[]);

figure;
image = imread('./segmentationData/cellPhaseContrast.png');
imshow(image, []);
mask = image < 120;
imshow(mask, []);
CC = bwconncomp(mask);
stats = regionprops(CC, 'Area');
area = (stats.Area);
s = round(1.2*sqrt(mean(area))/pi);
eroded = imerode(mask, strel('disk',s));
outside = ~imdilate(mask, strel('disk',1));
basin = imcomplement(bwdist(outside));
basin = imimposemin(basin,eroded|outside);
L = watershed(basin);
L = L > 2;
imshow(L, [])
