clc; clear all; close all;
mydir = 'Presamples_100k\';
DIS = dir([mydir, '*.mat']);
n = length(DIS);
labels_new=[];
presample_data_new=[];

for i=1:n
    data = load([mydir, DIS(i).name]);
    labels_new=[labels_new data.labels];
    presample_data_new=[presample_data_new data.presample_data];
end
save('concat_presamples.mat','presample_data_new','labels_new','-v7.3');