% Filter MC samples for REscope without recursive statistical blockade

clc;
clear;
close all;

N_SAMPLE = 2000; % Continue filtering until N_SAMPLE samples have passed the classifier
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 100000; % Generate batches of BATCH_SZ samples
cl = loadCompactModel('SVM_2_1k.mat');
% prune = load('pruned_indices.mat');
idxs = 181:360;
param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];

%% SAMPLE STAGE

% Sampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
sample_data = zeros(360, N_SAMPLE);
tic
sample_count = 0;
iteration_count = 0;
while (sample_count < N_SAMPLE)
    iteration_count = iteration_count + 1;
    sample_count
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
	raw_samples = sample_gen(BATCH_SZ, false);
    batch_samples = zeros(360, BATCH_SZ);
    for j = 1:BATCH_SZ
		batch_samples(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
    end
    labels = predict(cl, batch_samples(idxs,:).'); % Run Monte Carlo samples through trained classifier
    batch_samples = batch_samples(:, labels==1); % Filter out samples
    n_hits = sum(labels); % Number of samples identified by classifier
    if (n_hits > N_SAMPLE-sample_count) % If more samples than required to fill sample_data array
        sample_data(:,sample_count+1:end) = batch_samples(:, 1:N_SAMPLE-sample_count);
    else
        sample_data(:,sample_count+1:sample_count+n_hits) = batch_samples;
    end
    sample_count = sample_count + sum(labels);
end
%% Reshape and Write Parameters
reshaped_data = zeros(60*N_SAMPLE, 6);
for j = 1:N_SAMPLE
    reshaped_data(60*(j-1)+1:60*j,:) = reshape(sample_data(:,j), 60, 6);
end
write_params(param_names, reshaped_data, N_SAMPLE);

toc

