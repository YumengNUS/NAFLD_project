clc; clear; close all

sdirectory1 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\Ballooning\MT ballooning'; % directory for extracted compound
sdirectory2 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)'; % directory for original image
source1 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\Ballooning\Overlay\'; % save path

tiffiles1 = dir([sdirectory1 '\*.tif']);% specs for collagen folder
lenTiff1 = length(tiffiles1);
tiffiles2 = dir([sdirectory2 '\*.tif']);% specs for tissue folder
lenTiff2 = length(tiffiles2);


for aa = 1:lenTiff1
    
    filename1 = [sdirectory1 '\' tiffiles1(aa).name];
    filename2 = [sdirectory2 '\' tiffiles2(aa).name];
    fprintf('Processing image %i of %i: %s ...\n',...
            aa, length(tiffiles1), tiffiles1(aa).name) % Print out the process
    I=imread(filename2);
    original=I(:,:,1:3);
    ballooning=imread(filename1);
   
    [B,~] = bwboundaries(ballooning,'noholes');
    
    figure,imshow(original)
    hold on
    for k=1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 0.1)
    end
  
    
    saveas(gcf,[source1,tiffiles2(aa).name],'tiff');

end


