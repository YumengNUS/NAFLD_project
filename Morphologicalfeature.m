close all;clear;clc;

sdirectory = 'C:\E\PhD\1st year\Dry lab\Imaging Test all\HE stea all'; % directory for extracted compound

source1 = 'C:\E\PhD\1st year\Dry lab\Imaging Test all\'; % save path

tiffiles = dir([sdirectory '\*.tif']);% specs for collagen folder
lenTiff = length(tiffiles);


for aa = 1:length(tiffiles)
    filename = [sdirectory '\' tiffiles(aa).name];
    Name{aa} = tiffiles(aa).name;
    BW = imread(filename);
    cc = bwconncomp(BW); 
    
    features = regionprops(cc, 'Area','Perimeter','ConvexArea','Eccentricity',...
    'EulerNumber','Extent','FilledArea','MajorAxisLength','MinorAxisLength','Orientation','Solidity'); 
    [B,L] = bwboundaries(BW, 'noholes');
    for k = 1:length(B)

      % obtain (X,Y) boundary coordinates corresponding to label 'k'
      boundary = B{k};

      % compute a simple estimate of the object's perimeter
      delta_sq = diff(boundary).^2;    
      perimeter = sum(sqrt(sum(delta_sq,2)));

      % obtain the area calculation corresponding to label 'k'
      area = features(k).Area;

      % compute the roundness metric
      C(k) = perimeter^2/area;
    end
    %Compactness
    Compactness{aa} = mean(C);
    
    %Total&Average area
    Averagea{aa} = mean(cat(1, features.Area));
    [r,~] = find(BW==0);
    T = length(r);
    Totala{aa} = sum(cat(1, features.Area))/(sum(cat(1, features.Area))+T);
   
    %Perimeter
    Perimeter{aa} = mean(cat(1, features.Perimeter));
    
    %Convexarea
    Convexarea{aa} = mean(cat(1, features.ConvexArea));
    
    %Eccentricity
    Eccentricity{aa} = mean(cat(1, features.Eccentricity));
    
    %EulerNumber
    EulerNumber{aa} = mean(cat(1, features.EulerNumber));
    
    %Extent
    Extent{aa} = mean(cat(1, features.Extent));
    
    %FilledArea
    FilledArea{aa} = mean(cat(1, features.FilledArea));
    
    %MajorAxisLength
    MajorAxisLength{aa} = mean(cat(1, features.MajorAxisLength));
    
    %MinorAxisLength
    MinorAxisLength{aa} = mean(cat(1, features.MinorAxisLength));
    
    %Orientation
    Orientation{aa} = mean(cat(1, features.Orientation));
    
    %Solidity
    Solidity{aa} = mean(cat(1, features.Solidity));
    
end
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Name',2,'A2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Compactness',2,'B2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Averagea',2,'C2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Totala',2,'D2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Perimeter',2,'E2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Convexarea',2,'F2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Eccentricity',2,'G2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',EulerNumber',2,'H2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Extent',2,'I2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',FilledArea',2,'J2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',MajorAxisLength',2,'K2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',MinorAxisLength',2,'L2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Orientation',2,'M2');
     xlswrite('C:\E\PhD\1st year\Dry lab\Imaging Test all\Mfeature.xlsx',Solidity',2,'N2');
