clc;
clear;
close all;
N = 10e6;
TAIL_THR = 1.395e-10;
CLASS_THR = 0; % Will be set during recursion
BATCH_SZ = 1000;
param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE
tic
pruned = load('pruned_indices.mat');
idxs = 1:360;
% idxs = pruned.idxs(pruned.idxs > 180);
n = 1000;
% presample_data = zeros(360, n);
% raw_samples = sample_gen(n, true);
% for j = 1:BATCH_SZ
% 		presample_data(:,j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
% end
% [~, td] = simulate(CLASS_THR, n, '', false, false);
data = load('Presamples_100k\presamples_2_withtd.mat');
presample_data = data.presample_data(:,1:BATCH_SZ);
td = data.td(1:BATCH_SZ);

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
    
    cl = train(presample_data, td, idxs, CLASS_THR, false);
    
    n = n*100;
    
    % Run Monte Carlo and filter out samples with trained classifier
    presample_data = [];
    for i=1:n/BATCH_SZ
        disp(i);
        raw_samples = sample_gen(BATCH_SZ, false);
        temp_data = zeros(360, BATCH_SZ);
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
	
	%% Run HSPICE Simulation and Parse Output
%     [~, td] = simulate(CLASS_THR, batch_size, '', true, false);

end
save('filtered_samples.mat', 'presample_data', 'td');
toc