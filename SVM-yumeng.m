% Classification model, Support vector machine 
% Feature selection & PCA
% create by Yumeng
% June 2018

clear; close all; clc;

%% load data: features and labelling
cd('E:\Dropbox\Hanry Projects\Yu Yang-NAFLD\Result all\');
% features
stea = xlsread('Features for steatosis.xlsx');
bal = xlsread('Features for ballooning.xlsx');
inflaM = xlsread('Features for inflammation.xlsx');
inflaT = xlsread('Features for inflammation_Textural.xlsx');
fib = xlsread('Features for fibrosis.xlsx');
% labelling
label = xlsread('Labels for P review.xlsx');
% number for each cases
% nonNASH 102 indefiniteNASH 100 NASH 106

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

fib_nonNASH = fib(loc_nonNASH,:);
fib_Inde = fib(loc_Inde,:);
fib_NASH = fib(loc_NASH,:);

label_nonNASH = label(loc_nonNASH,:);
label_Inde = label(loc_Inde,:);
label_NASH = label(loc_NASH,:);

%% cat all the data, stea+bal, nonNASH+NASH
% you can change it accordingly
%data_nonNASH =  cat(2, stea_nonNASH, bal_nonNASH,inflaM_nonNASH,inflaT_nonNASH,fib_nonNASH); %,fib_nonNASH
%data_Inde = cat(2, stea_Inde, bal_Inde,inflaM_Inde,inflaT_Inde, fib_Inde);%, fib_Inde
%data_NASH =  cat(2, stea_NASH, bal_NASH,inflaM_NASH,inflaT_NASH,fib_NASH);%,fib_NASH
data_nonNASH =  cat(2, inflaM_nonNASH,inflaT_nonNASH); %,fib_nonNASH
data_Inde = cat(2, inflaM_Inde,inflaT_Inde);%, fib_Inde
data_NASH =  cat(2, inflaM_NASH,inflaT_NASH);%,fib_NASH

data = cat(1, data_Inde, data_NASH);
label_t = cat(1, label_Inde, label_NASH);
% label(label==2)=1; 
% label(label==3)=2; 

%% feature selection & PCA

f = @(xtrain, ytrain, xtest, ytest)...
    sum(ytest ~= predict(fitcsvm(xtrain,ytrain),xtest));
inmodel = sequentialfs(f,data,label_t,'nfeatures', 15,'direction','forward');

[trainc,Train_score] = pca(data(:,inmodel));
DATA = Train_score(:,1:8);


%% cross validation and SVM
N = length(label_t);

 
for c = 1:N    
            %leave one out
			c
            [Train, Test] = crossvalind('LeaveMOut',N,1);
            % SVM
            mdl = fitcsvm(DATA(Train,:),label_t(Train));  
            ScoreSVMModel = fitSVMPosterior(mdl); %Change SVM model to score model
            [l,score] = predict(ScoreSVMModel, DATA(Test,:));
            ground_truth(c) = label_t(Test);
            pre2(c) = score(1);
end

% ROC Calculating
[X1,Y1,T1,AUC2] = perfcurve(label_t,pre2,1);
AUC2

% plot curve
p=plot(X1,Y1,'r')
set(p,'LineWidth',2)
 legend('(AUROC=0.XXX)','Location','southeast')
xlabel('1-Specificity')
ylabel('Sensitivity')
% title('XXX')
hold off

% change the figure name accordingly
figname = ['test IndN vs Nash InflaM+T features'];
% title(figname);
sd = 'E:\Dropbox\Hanry Projects\Yu Yang-NAFLD\Result all\Classification results\';
print('-r300','-djpeg', fullfile(sd,figname))
