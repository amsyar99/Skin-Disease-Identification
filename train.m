clc;
clear all;
close all;
%Load current directory

yourFolder = 'C:\Users\Amsyar\Documents\cs230\part5\FYPSystem\Dataset\Eczema\Testing_Eczema';

xlData = cell(10, 5);

for k = 1:10
  jpgFilename = sprintf('%d.jpg', k);
  fullFileName = fullfile(yourFolder, jpgFilename);
  if exist(fullFileName, 'file')
    imageData = imread(fullFileName );
  else
    warningMessage = sprintf('Warning: image file does not exist:\n%s', fullFileName);
    uiwait(warndlg(warningMessage));
  end

imgInput = imageData;

I= im2double(imgInput);
im2= imadjust(I,[.2 .3 0; .6 .7 1],[]);
imgInput=im2;
I = imgInput;
gray = rgb2gray(I);
I_eq= adapthisteq(gray);
bw= imbinarize(I_eq, graythresh(I_eq));
bw3 = imopen(bw, ones(3,3));
bw4 = bwareaopen(bw3, 20);
bw4_perim = bwperim(bw4);
overlay1 = imoverlay(I_eq, bw4_perim, [.3 1 .3]);
mask_em = imregionalmax(~bw4); %fgm
fgm = labeloverlay(I,mask_em);
mask_em = imclose(mask_em, ones(3,3));
mask_em = imerode(mask_em, ones(3,3));
mask_em = bwareaopen(mask_em, 30);
overlay2 = imoverlay(I_eq, bw4_perim | mask_em, [.3 1 .3])
D = bwdist(mask_em);
DL = watershed(D);
bgm = DL == 0;
gmag=imgradient(gray);
gmag2 = imimposemin(gmag, bgm | mask_em);
L = watershed(gmag2);
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*mask_em;
I4 = labeloverlay(gray,labels);
label = imdilate(L==0,ones(3,3)) + 2*mask_em;
bb= imbinarize(label, graythresh(label));
Lrgb = label2rgb(L,'jet','w','shuffle');
I = mask_em;


I=double(I);
I = reshape(I.',1,[]);
e=entropy(I);
gg=graycomatrix(I);
contrast=gg(1,1);
core=gg(1,8);
energy=gg(8,1);



features = [e, contrast, core, energy]
    xlData{k, 1} = e;
    xlData{k, 2} = contrast;
    xlData{k, 3} = core;
    xlData{k, 4} = energy;
    

end

filename = 'EczemaTesting.xlsx';
writecell(xlData, filename);