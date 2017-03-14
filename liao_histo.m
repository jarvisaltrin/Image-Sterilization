% input=double(imread('Fall2.png'));
% hist(reshape(input,[],3),1:max(input(:))); %histogram creation
% colormap([1 0 0; 0 1 0; 0 0 1]); %R(1,0,0):G(0,1,0):B(0,0,1) components

I = imread('root.bmp');
Ihat = imread('final_root.bmp');

% Read the dimensions of the image.
[rows columns ~] = size(I);

% Calculate mean square error of R, G, B.   
mseRImage = (double(I(:,:,1)) - double(Ihat(:,:,1))) .^ 2;
mseGImage = (double(I(:,:,2)) - double(Ihat(:,:,2))) .^ 2;
mseBImage = (double(I(:,:,3)) - double(Ihat(:,:,3))) .^ 2;

mseR = sum(sum(mseRImage)) / (rows * columns);
mseG = sum(sum(mseGImage)) / (rows * columns);
mseB = sum(sum(mseBImage)) / (rows * columns);

% Average mean square error of R, G, B.
mse = (mseR + mseG + mseB)/3;

% Calculate PSNR (Peak Signal to noise ratio).
PSNR_Value = 10 * log10( 255^2 / mse);