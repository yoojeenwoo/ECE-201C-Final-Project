clc;
clear all;
close all;
%load data to do tail fitting
load sim_results_unpruned_c2_6.mat;

%% 
thresh=1.38;
y=(td(td*1e10>thresh)*1e10-thresh);
fit=gpfit(y);
x=1.38:0.000001:1.42;
p=gppdf(x,fit(1),fit(2),1.38);
c=gpcdf(x,fit(1),fit(2),1.38);
figure;
plot((1.38:0.000001:1.42)*1e-10,p/sum(p));
figure;
plot((1.38:0.000001:1.42)*1e-10,c);
idxs=x>1.395;

