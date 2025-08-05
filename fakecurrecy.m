%here are some of the codes.am i using the right codes?
%are there any other codes i can use?
clc;
clear all;
close all;
Ireal = imread('/MATLAB Drive/500_image.jpg'); % Real
Iscaned = imread('/MATLAB Drive/500_image.jpg'); % scaned
%%//Pre-analysis
hsvImageReal = rgb2hsv(Ireal);
hsvImagescaned = rgb2hsv(Iscaned);
figure;
subplot(1,3,1), imshow(hsvImageReal(:,:,1), []), title('Hue - Real');
subplot(1,3,2), imshow(hsvImageReal(:,:,2), []), title('Saturation - Real');
subplot(1,3,3), imshow(hsvImageReal(:,:,3), []), title('Value - Real');
figure;
subplot(1,3,1), imshow(hsvImagescaned(:,:,1), []), title('Hue - Scanned');
subplot(1,3,2), imshow(hsvImagescaned(:,:,2), []), title('Saturation - Scanned');
subplot(1,3,3), imshow(hsvImagescaned(:,:,3), []), title('Value - Scanned');
%%//Initial segmentation
% Assuming both should be cropped over columns 90 to 95
croppedImageReal = hsvImageReal(:,90:95,:);
croppedImagescaned = hsvImagescaned(:,90:95,:);
satThresh = 0.4;
valThresh = 0.3;
BWImageReal = (croppedImageReal(:,:,2) > satThresh & croppedImageReal(:,:,3) < valThresh);
figure;
subplot(1,2,1);
imshow(BWImageReal);
title('Real initial segment');
BWImagescaned = (croppedImagescaned(:,:,2) > satThresh & croppedImagescaned(:,:,3) < valThresh);
subplot(1,2,2);
imshow(BWImagescaned);
title('Scaned initial segment');
% Post-processing with morphological closing
se = strel('line', 6, 90);
% Ensure the binary images before applying imclose
BWImageReal = logical(BWImageReal);  % Convert to logical if not already
BWImagescaned = logical(BWImagescaned);  % Convert to logical if not already
% Perform morphological closing
BWImageCloseReal = imclose(BWImageReal, se);
BWImageClosescaned = imclose(BWImagescaned, se);
% Display the results
figure;
subplot(1,2,1);
imshow(BWImageCloseReal);
title('Real post process');
subplot(1,2,2);
imshow(BWImageClosescaned);
title('Scanned post process');
% Area opening
figure;
areaopenReal = bwareaopen(BWImageCloseReal, 15);
subplot(1,2,1);
imshow(areaopenReal);
title('Real area open image');
areaopenscaned = bwareaopen(BWImageClosescaned, 15);
subplot(1,2,2);
imshow(areaopenscaned);
title('Scanned area open image');
% Count how many objects there are using bwlabel
[~, countReal] = bwlabel(areaopenReal);
[~, countScanned] = bwlabel(areaopenscaned);
% Convert to grayscale
grt = rgb2gray(Ireal);
grs = rgb2gray(Iscaned);
% Contrast enhancement to emphasize dark lines on a lighter background
grt = imadjust(grt);
grs = imadjust(grs);
% Morphological closing with a larger kernel (to remove dark lines)
k = 7;
se = strel('rectangle', [k, k]);  % Use a rectangular structuring element
Irealcl = imclose(grt, se);  % Close the grayscale real image
Iscanedcl = imclose(grs, se);  % Close the grayscale scanned image
% Compute the difference between closed grayscale and contrast-enhanced grayscale
difft = Irealcl - grt;  % Difference for the real image
diffs = Iscanedcl - grs;  % Difference for the scanned image
% Take the projection of the difference by summing over rows (vertical projection)
pt = sum(difft, 2);  % Sum along the 2nd dimension (rows)
pf = sum(diffs, 2);
% Smooth the projection using convolution
ptfilt = conv(pt, ones(1, k) / k, 'same');
pffilt = conv(pf, ones(1, k) / k, 'same');
% Threshold the smoothed projection for segmentation
tht = ptfilt > graythresh(ptfilt) * max(ptfilt);  % Threshold for real image projection
thf = pffilt > graythresh(pffilt) * max(pffilt);  % Threshold for scanned image projection
% Get the number of segments (black lines) using bwlabel on the thresholded signal
[lblt, nt] = bwlabel(tht);  % Ensure binary input to bwlabel
[lblf, nf] = bwlabel(thf);
% Display results
disp(['Number of black lines for the Real note: ' num2str(nt)]);
disp(['Number of black lines for the Scanned note: ' num2str(nf)]);
% Visualize the difference images
figure;
subplot(2, 1, 1);
imshow(mat2gray(difft), []);  % Normalize and display the difference image for Real
title('Difference Image for Real Image Line');
subplot(2, 1, 2);
imshow(mat2gray(diffs), []);  % Normalize and display the difference image for Scanned
title('Difference Image for Scanned Image Line');
% Plot the projections, smoothed projections, and thresholded signals
figure;
subplot(2, 1, 1);
plot(1:length(pt), pt, 'b', 1:length(pt), ptfilt, 'r', 1:length(pt), tht, 'g');
title('Original Image Analysis');
legend('Projection', 'Smoothed', 'Thresholded', 'Location', 'eastoutside');
xlabel('Row Index');
ylabel('Projection Value');
subplot(2, 1, 2);
plot(1:length(pf), pf, 'b', 1:length(pf), pffilt, 'r', 1:length(pf), thf, 'g');
title('Scanned Image Analysis');
legend('Projection', 'Smoothed', 'Thresholded', 'Location', 'eastoutside');
xlabel('Row Index');
ylabel('Projection Value');
% Check the size of both images
realSize = size(Ireal);
scanedSize = size(Iscaned);
% Display the sizes of the images for debugging
disp(['Size of Ireal: ' num2str(realSize)]);
disp(['Size of Iscaned: ' num2str(scanedSize)]);
% Extract the black strip from both images, assuming they have at least 200 columns
if realSize(2) >= 200 && scanedSize(2) >= 200
    blackStripReal = Ireal(:,200:end,:);  % Extract black strip from real image
    blackStripscaned = Iscaned(:,200:end,:);  % Extract black strip from scanned image
else
    error('One or both images have less than 200 columns. Cannot extract the black strip.');
end
% Display the black strips
figure;
subplot(1,2,1);  % Adjust to 2 subplots
imshow(blackStripReal);
title('Real black strip');
subplot(1,2,2);  % Adjust to 2 subplots
imshow(blackStripscaned);
title('Scanned black strip');
% Convert the black strip images to grayscale
blackStripRealGray = rgb2gray(blackStripReal);
blackStripscanedGray = rgb2gray(blackStripscaned);
% Display the grayscale images
figure;
subplot(1,2,1);  % Adjust to 2 subplots
imshow(blackStripRealGray);
title('Real black strip (grayscale)');
subplot(1,2,2);  % Adjust to 2 subplots
imshow(blackStripscanedGray);
title('Scanned black strip (grayscale)');

if nt > nf
    disp('The currency is likely real based on black lines.');
else
    disp('The currency is likely fake based on black lines.');
end

