clc; clear all; close all;
sam_mat=["presamples_1" "presamples_2" "presamples_3" "presamples_4" ...
    "presamples_5" "presamples_6" "presamples_7" "presamples_8" "presamples_9"]; 
labels_new=[];
presample_data_new=[];
for i=1:9
i
load(sam_mat(i));
labels_new=[labels_new labels];
presample_data_new=[presample_data_new presample_data];
end
save('concat_presamples.mat','presample_data_new','labels_new','-v7.3');