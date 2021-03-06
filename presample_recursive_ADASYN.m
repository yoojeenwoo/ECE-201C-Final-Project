clc;
clear all;
close all;
N = 10000000;
TAIL_THR = 1.395e-10;
CLASS_THR = 0; % Will be set during recursion
BATCH_SZ = 1000;
N_PRESAMPLE = log(N)/log(BATCH_SZ)*BATCH_SZ;
param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE
tic
pruned = load('pruned_indices.mat');
idxs = pruned.idxs;
idxs = idxs(idxs>180);
% idxs = 181:360;
% n = BATCH_SZ;
n = 1000;
% presample_data = zeros(360, n);
% raw_samples = sample_gen(n, true);
% for j = 1:BATCH_SZ
% 		presample_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
% end
% [~, td] = simulate(CLASS_THR, n, '', false, false);

%load the presample data
data = load('presamples_2.mat');
presample_data = data.presample_data(:,1:n);
td = data.td(1:n);

%%
while n < N
    n
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
    
    % Select the worst delay times out of the simulation
    [~, I] = sort(td, 'descend');
    td = td(I);
    td = td(1:BATCH_SZ);
    presample_data = presample_data(:,I);
    presample_data = presample_data(:,1:BATCH_SZ);
    
    CLASS_THR = td(30); % Reset classification threshold to 97th percentile
    
    
    % Generating the synthetic Samples
    labels=td>CLASS_THR;
    adasyn_features = transpose(presample_data);
    adasyn_labels = transpose(labels);
    adasyn_beta                     = [];   %let ADASYN choose default
    adasyn_kDensity                 = [];   %let ADASYN choose default
    adasyn_kSMOTE                   = [];   %let ADASYN choose default
    adasyn_featuresAreNormalized    = false;    %false lets ADASYN handle normalization

    [adasyn_featuresSyn, adasyn_labelsSyn] = ADASYN(adasyn_features, ...
    adasyn_labels, adasyn_beta, adasyn_kDensity, adasyn_kSMOTE, adasyn_featuresAreNormalized);
    presample_data=[presample_data transpose(adasyn_featuresSyn)];
    labels=[labels transpose(adasyn_labelsSyn)];
    cl = adasyn_train_func(presample_data, labels, idxs, false);
    
    n = n*100;
    
    % Run Monte Carlo and filter out samples with trained classifier
    presample_data = [];
    for i=1:n/1000
        disp(i);
        raw_samples = sample_gen(1000, false);
        temp_data = zeros(360, 1000);
        for j = 1:BATCH_SZ
            temp_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
        end
        labels = predict(cl, temp_data(idxs,:).');
        presample_data = [presample_data temp_data(:, labels==1)];
    end
    
    batch_size = size(presample_data, 2);
    reshaped_data = zeros(60*batch_size, 6);
    for j = 1:batch_size
        reshaped_data(60*(j-1)+1:60*j,:) = reshape(presample_data(:,j), 60, 6);
    end
    write_params(param_names, reshaped_data, batch_size);
	
	%% Run HSPICE Simmulation and Parse Output
    [~, td] = simulate(CLASS_THR, batch_size, '', true, false);

end
save('filtered_samples.mat', 'presample_data', 'td');
toc