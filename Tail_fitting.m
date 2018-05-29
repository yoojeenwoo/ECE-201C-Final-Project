clc;
clear all;
close all;
load filtered_samples_5_26.mat;
td_new=td;
load filtered_samples_5_27.mat;
td_new=[td_new td];
load filtered_samples_5_28.mat;
td_new=[td_new td];

%% 
td_new=td_new*1e10;
thresh=1.38;
y=(td_new(td_new>thresh)-thresh);
fit=gpfit(y);
x=1.39:0.000001:1.42;
p=gppdf(x,fit(1),fit(2),1.39);
plot((1.39:0.000001:1.42)*1e-10,p/length(td_new));