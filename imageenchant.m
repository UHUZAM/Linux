load('cutten16bit.mat')
A=(I2c16(:,:,1:3));
googlearth=imread('googleearth.png');
B=uint8(A/16);  
J3 = imadjust(B,[],[],0.2);
figure;
imshow(J3)
Ref=imread('highres.tif');
C= imhistmatch(B,rgb2gray(googlearth));
figure;
imshow(C)
figure;
imhist(rgb2gray(C))


redMF5 = medfilt2(C(:,:,1), [5 5]);
greenMF5 = medfilt2(C(:,:,2), [5 5]);
blueMF5 = medfilt2(C(:,:,3), [5 5]);

% Reconstruct the noise free RGB image
rgbFixed5 = cat(3, redMF5, greenMF5, blueMF5);
figure;
imshow(rgbFixed5)
title('Restored Image5')

J = adapthisteq(rgbFixed5(:,:,1));
J2 = adapthisteq(rgbFixed5(:,:,2));
J3 = adapthisteq(rgbFixed5(:,:,3));

rgbFixed6 = cat(3, J, J2, J3);
figure;
imshow(rgbFixed6)
figure;
imhist(rgb2gray(rgbFixed6))
title('Adaptive Histeq Image5')