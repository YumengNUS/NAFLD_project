close all;clear;clc;

sdirectory = 'C:\E\PhD\1st year\Dry lab\Imaging Test all\HE nuclei density'; % directory for extracted compound

source = 'C:\E\PhD\1st year\Dry lab\Imaging Test all\HE nuclei density binary\'; % save path

tiffiles = dir([sdirectory '\*.tiff']);% specs for collagen folder
lenTiff = length(tiffiles);


for aa = 1:lenTiff
    filename = [sdirectory '\' tiffiles(aa).name];
    I = imread(filename);
    
    %figure, imshow(I);
    T = 0.6*double(max(max(I)))/255;
    
    BW = imbinarize(I, T);
    
    imwrite(BW,[source,tiffiles(aa).name],'tif');
    
end