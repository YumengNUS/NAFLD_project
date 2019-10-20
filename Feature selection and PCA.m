%% feature selection and pca
mdl = fscnca(data,label); % create feature selection parameters
[num, val]=sort(mdl.FeatureWeights); % resort the feature weights
pos = val(end-9:end); % select the most important 10
[~,width]=size(data);
inmodel=zeros(1,width); % create location files for features
for n=1:10
    inmodel(pos(n)) = 1;
end
inmodel = logical(inmodel); % change from double to logical values

[trainc,Train_score] = pca(data(:,inmodel)); % PCA on selected features only

DATA = Train_score(:,1:8);