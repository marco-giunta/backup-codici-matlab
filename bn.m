clear
close all
I = imread('c.png');
imshow(I)
C=rgb2gray(I);
BW = im2bw(I);
figure
imshow(BW)
dim = size(BW)
col = round(dim(2)/2)-90;
row = min(find(BW(:,col)))
boundary = bwtraceboundary(BW,[row, col],'N');
imshow(I)
figure
hold on
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
BW_filled = imfill(BW,'holes');
boundaries = bwboundaries(BW_filled);
for k=1:10
b = boundaries{k};
plot(b(:,2),b(:,1),'g','LineWidth',3);
end
imshow(BW)

figure%questa la parte importante
D = pic2points(C,0,1);
scatter(D(:,1), D(:,2),'.');