clc;
clear all;
close all;
N = 1000000000;
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 1000; % N_PRESAMPLE should be divisible by BATCH_SZ
N_PRESAMPLE = log(N)/log(BATCH_SZ)*BATCH_SZ;
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE
tic

n = BATCH_SZ;
% Presampled Data will group data points by column.
presample = zeros(360, n);
for j = 1:BATCH_SZ
		presample_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
end
[labels, td] = simulate(CLASS_THR, n, '', true, false);

while n < N
    n
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
    [~, I] = sort(td, 'descend');
    td_sorted = td(I);
    samples_sorted = presample_data(:,I);
    labels_sorted = labels(I);
    td = td(1:BATCH_SZ);
    presample_data = presample_data(:,1:BATCH_SZ);
    
	raw_samples = sample_gen(BATCH_SZ, true);
    for j = 1:BATCH_SZ
		presample_data(:,BATCH_SZ*(i-1)+j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
    end
	
	% Run HSPICE Simmulation and Parse Output
    [labels(BATCH_SZ*(i-1)+1:BATCH_SZ*i), td(BATCH_SZ*(i-1)+1:BATCH_SZ*i)] = simulate(CLASS_THR, BATCH_SZ, '', true, false);

end
save('presamples.mat');
toc