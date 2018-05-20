clc;
clear;
close all;

N_SAMPLE = 50;
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 100000;
% load 'SVM_200k.mat'
cl = loadCompactModel('SVM_200k.mat');
param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];

%% SAMPLE STAGE

% Sampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
sample_data = zeros(360, N_SAMPLE);
tic
sample_count = 0;
while (sample_count < N_SAMPLE)
    sample_count
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
	raw_samples = sample_gen(BATCH_SZ, false);
    batch_samples = zeros(360, BATCH_SZ);
    for j = 1:BATCH_SZ
		batch_samples(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
    end
    labels = predict(cl, batch_samples.'); % Run Monte Carlo samples through trained classifier
    batch_samples = batch_samples(:, labels==1); % Filter out samples
    n_hits = sum(labels); % Number of samples identified by classifier
    if (n_hits > N_SAMPLE-sample_count) % If more samples than required to fill sample_data array
        sample_data(:,sample_count+1:end) = batch_samples(:, 1:N_SAMPLE-sample_count);
    else
        sample_data(:,sample_count+1:sample_count+n_hits) = batch_samples;
    end
    sample_count = sample_count + sum(labels);
end

write_params(param_names, reshape(sample_data, 60*N_SAMPLE, 6), N_SAMPLE);

toc

