%% lipid segementation for NAFLD NASH project-clinical data
% created by Yumeng
% date Feb 2019
% comments: larger roundness, larger upper-threshold of large lipid

close all
clc
clear

%% setting up directory
sdirectory = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\';
tifffiles = dir([sdirectory '\*.tif']);
lenTiff = length(tifffiles);
source1 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\Ballooning\MT ballooning\'; % all 
source2 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\Ballooning\MT binary\'; %processed binary
source3 = 'C:\E\PhD\NAFLD project\Dry lab\Clinical data(3 images)\Steatosis\MT stea all\'; %steatosis
steafigs = dir([source3 '\*.tif']);
	
%% loading and processing images
for nn=1:lenTiff
	fprintf('Processing images %i of %i \n', nn, lenTiff) % Print out the process
    filename = [sdirectory '\' tifffiles(nn).name];
    I= imread(filename);% whole image
    I1 = I(:,:,1:3);
	gray=rgb2gray(I1);
	level1=graythresh(gray); %[0.764705882352941,0.780392156862745,0.784313725490196]
    level=level1-0.1;
	BW1=imbinarize(gray, level);
	steafile = [source3 '\' steafigs(nn).name];
    S = imread(steafile);
    S = double(S);
    BW1 = BW1-S;
    %figure, imshow(S);
    %figure, imshow(BW1);
    se = strel('disk', 2);
	BW2 = imopen(BW1, se);

	

	% find labeled parts (portal and background)
	[L, num]= bwlabel(BW2);
	[m n] = size(L);
	pm = regionprops(L, 'perimeter');
	perimeter = cat (1, pm.Perimeter);

	% create empty matrix
	M = zeros(num,2);
	T = zeros(m,n);
	
	N = 0;


	%% loop to extract small droplets and large droplets (in macrosteatosis)
	for a = 1:num
		
		
		I3 = (L==a);
		
		C = bwarea(I3);		
		roundness = (4*pi*C)/perimeter(a,:)^2;
		
		M(a,1) = a;
		M(a,2) = C;
		
		if  (C <1500 && C >20 && roundness<=0.7)
			T = T+I3;
			%N = N+1;
		end 
		
    end
	
    
    
    
    
    
	imwrite(T,[source1,'all-',tifffiles(nn).name],'tif');
	imwrite(BW2,[source2,'binary-',tifffiles(nn).name],'tif');
		
end

		

