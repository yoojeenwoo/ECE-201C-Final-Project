clc;
clear all;
close all;
N = 1000000000;
TAIL_THR = 1.395e-10;
CLASS_THR = 0; % Will be set during recursion
BATCH_SZ = 1000;
N_PRESAMPLE = log(N)/log(BATCH_SZ)*BATCH_SZ;
param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE
tic

n = BATCH_SZ;
% Presampled Data will group data points by column.
presample_data = zeros(360, n);
raw_samples = sample_gen(n, true);
for j = 1:BATCH_SZ
		presample_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
end
[~, td] = simulate(CLASS_THR, n, '', true, false);

while n < N
    n
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
    [~, I] = sort(td, 'descend');
    td_sorted = td(I);
    td = td_sorted(1:BATCH_SZ);
    presample_sorted = presample_data(:,I);
    presample_data = presample_sorted(:,1:BATCH_SZ);
    labels_sorted = labels(I);
    labels = labels_sorted(1:BATCH_SZ);
    
    CLASS_THR = td(30); % 97th percentile
    
    cl = train(presample_data, labels, false, false);
    
    n = n*100;
    
    presample_data = zeros(360, n);
	raw_samples = sample_gen(n, false);
    for j = 1:BATCH_SZ
		presample_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
    end
    labels = predict(cl, presample_data.');
    presample_data = presample_data(:, labels==1);
    batch_size = size(presample_data, 2);
    write_params(param_names, reshape(presample_data, 60*batch_size, 6), batch_size);
	
	% Run HSPICE Simmulation and Parse Output
    [labels, td] = simulate(CLASS_THR, batch_size, '', true, false);

end
save('presamples.mat');
toc