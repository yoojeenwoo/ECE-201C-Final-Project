%Parameter Pruning using ReliefF
clc; clear all; close all;
%%
load('concat_presamples.mat');

%% Presampling for pruning
index=find(labels_new);
labels=ones(1,length(index));
presample_data=presample_data_new(:,index);
presample_data=[presample_data presample_data_new(:,1:10000)];
labels=[labels labels_new(1,1:10000)];

%%   
[ranks,weights]=relieff(transpose(presample_data),transpose(labels),100);
plot(1:360,weights);
