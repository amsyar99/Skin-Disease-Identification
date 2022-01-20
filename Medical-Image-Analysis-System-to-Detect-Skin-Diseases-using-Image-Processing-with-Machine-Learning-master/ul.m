%%%watershed 
A = imread('C:\Users\User\Desktop\JK\ul0.jpg');
A=imresize(A, [300 300]);
I = rgb2gray(A);
figure
imshow(I)
title('Original Image')

%%%Use the active contours (snakes) method to segment the hand.

mask = false(size(I));
mask(25:end-25,25:end-25) = true;
BW = activecontour(I, mask, 300);

%%%%Read in the ground truth against which to compare the segmentation.

A2 = imread('C:\Users\User\Desktop\JK\ul1.jpg');
A2=imresize(A2, [300 300]);
I2=rgb2gray(A2);
mask2 = false(size(I2));
mask2(25:end-25,25:end-25) = true;
BW_groundTruth = activecontour(I2, mask2, 300);
%%%%%Compute the Jaccard index of this segmentation.

similarity = jaccard(BW, BW_groundTruth);

%%%%Display the masks on top of each other. Colors indicate differences in the masks.

figure
imshowpair(BW, BW_groundTruth)
title(['Jaccard Index = ' num2str(similarity)])


%%%kmeans clustering 
A = imread('C:\Users\User\Desktop\JK\ul0.jpg');
A=imresize(A, [300 300]);
I = rgb2gray(A);
figure
imshow(I)
title('Original Image')

%%%Use the active contours (snakes) method to segment the hand.

mask = false(size(I));
mask(25:end-25,25:end-25) = true;
BW = activecontour(I, mask, 300);

%%%%Read in the ground truth against which to compare the segmentation.

A2 = imread('C:\Users\User\Desktop\JK\ul32.jpg');
A2=imresize(A2, [300 300]);
I2=rgb2gray(A2);
mask2 = false(size(I2));
mask2(25:end-25,25:end-25) = true;
BW_groundTruth = activecontour(I2, mask2, 300);
%%%%%Compute the Jaccard index of this segmentation.

similarity = jaccard(BW, BW_groundTruth);

%%%%Display the masks on top of each other. Colors indicate differences in the masks.

figure
imshowpair(BW, BW_groundTruth)
title(['Jaccard Index = ' num2str(similarity)])

%%%otsu thresholding 

A = imread('C:\Users\User\Desktop\JK\ul0.jpg');
A=imresize(A, [300 300]);
I = rgb2gray(A);
figure
imshow(I)
title('Original Image')

%%%Use the active contours (snakes) method to segment the hand.

mask = false(size(I));
mask(25:end-25,25:end-25) = true;
BW = activecontour(I, mask, 300);

%%%%Read in the ground truth against which to compare the segmentation.

A2 = imread('C:\Users\User\Desktop\JK\ul2.jpg');
A2=imresize(A2, [300 300]);
I2=rgb2gray(A2);
mask2 = false(size(I2));
mask2(25:end-25,25:end-25) = true;
BW_groundTruth = activecontour(I2, mask2, 300);
%%%%%Compute the Jaccard index of this segmentation.

similarity = jaccard(BW, BW_groundTruth);

%%%%Display the masks on top of each other. Colors indicate differences in the masks.

figure
imshowpair(BW, BW_groundTruth)
title(['Jaccard Index = ' num2str(similarity)])








