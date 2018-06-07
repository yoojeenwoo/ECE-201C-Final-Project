clc;
clear all;
close all;
N_PRESAMPLE = 100000; % Total number of samples to generate and simulate
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 1000; % N_PRESAMPLE should be divisible by BATCH_SZ
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE

% Presampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
presample_data = zeros(360, N_PRESAMPLE); 
labels = zeros(1, N_PRESAMPLE);
td = zeros(1, N_PRESAMPLE);
tic
for i = 1:(N_PRESAMPLE/BATCH_SZ)
    i
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
	raw_samples = sample_gen(BATCH_SZ, true);
	for j = 1:BATCH_SZ
		presample_data(:,BATCH_SZ*(i-1)+j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
    end
	
	% Run HSPICE Simmulation and Parse Output
    [labels(BATCH_SZ*(i-1)+1:BATCH_SZ*i), td(BATCH_SZ*(i-1)+1:BATCH_SZ*i)] = simulate(CLASS_THR, BATCH_SZ, '', true, false);

end
save('presamples.mat', 'labels', 'presample_data');
toc