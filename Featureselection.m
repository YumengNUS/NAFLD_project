%Feature selection and Principle components analysis
% create by Yumeng
% June 2018

clear; close all; clc;

%% load data: features and labelling
cd('C:\E\PhD\1st year\Dry lab\Imaging Test all')
% features
stea = xlsread('Features for steatosis.xlsx');
bal = xlsread('Features for ballooning.xlsx');
inflaM = xlsread('Features for inflammation.xlsx');
inflaT = xlsread('Features for inflammation_Textural.xlsx');
% labelling
label = xlsread('Labels for P review.xlsx');
% number for each cases
% nonNASH 32 indefiniteNASH 100 NASH 48

%% select data for specific analysis
% we use nonNASH and NASH for example
loc_nonNASH = find(label==1);
loc_Inde = find(label==2);
loc_NASH = find(label==3);

stea_nonNASH = stea(loc_nonNASH,:);
stea_Inde = stea(loc_Inde,:);
stea_NASH = stea(loc_NASH,:);

bal_nonNASH = bal(loc_nonNASH,:);
bal_Inde = bal(loc_Inde,:);
bal_NASH = bal(loc_NASH,:);

inflaM_nonNASH = inflaM(loc_nonNASH,:);
inflaM_Inde = inflaM(loc_Inde,:);
inflaM_NASH = inflaM(loc_NASH,:);

inflaT_nonNASH = inflaT(loc_nonNASH,:);
inflaT_Inde = inflaT(loc_Inde,:);
inflaT_NASH = inflaT(loc_NASH,:);

label_nonNASH = label(loc_nonNASH,:);
label_Inde = label(loc_Inde,:);
label_NASH = label(loc_NASH,:);

%% cat all the data, stea+bal, nonNASH+NASH
data_nonNASH = cat(2, stea_nonNASH, bal_nonNASH,inflaM_nonNASH,inflaT_nonNASH);
data_Inde = cat(2, stea_Inde, bal_Inde,inflaM_Inde,inflaT_Inde);
data_NASH = cat(2, stea_NASH, bal_NASH,inflaM_NASH,inflaT_NASH);

data = cat(1, data_nonNASH, data_NASH);
label = cat(1, label_nonNASH, label_NASH);
%label(label==2)=1; 
label(label==3)=2;

%% feature selection
f = @(xtrain, ytrain, xtest, ytest)...
    sum(ytest ~= predict(fitcknn(xtrain,ytrain,'NumNeighbors',5),xtest));
inmodel = sequentialfs(f,data,label,'direction','forward');

%% cross validation and KNN

N = length(label);

%   for k=[1,3,5,7,9,11,13]  %k-nearest k=5 best
    
       for c = 1:N    
            %leave one out
            [Train, Test] = crossvalind('LeaveMOut', N);

            % K-nearest neighbor classification
            mdl = fitcknn(data(Train,inmodel),label(Train),'NumNeighbors',5);  
            [l,score,cost] = predict(mdl, data(Test,inmodel));
            ground_truth(c) = label(Test);
            pre(c)=score(1);
          
          
       end
      
       auc = plot_roc(pre, ground_truth );