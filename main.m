N_PRESAMPLE = 1000;
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 100; % N_PRESAMPLE should be divisible by BATCH_SZ
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE

% Presampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
presample_data = zeros(360, N_PRESAMPLE); 
labels = zeros(1, N_PRESAMLE);

for i = 1:(N_PRESAMPLE/BATCH_SZ)
	% Sample_Gen output is organized in vertically stacked 60 x 6 blocks
	% We reshape each block to be a 360 x 1 column of the presample_data matrix
	% Reshape stacks each of the six 60x1 columns of the original sample
	raw_samples = sample_gen(BATCH_SZ);
	for j = 1:BATCH_SZ
		presample_data(:,BATCH_SZ*(i-1)+j) = reshape(raw_samples(60*(j-1)+1:60*(j-1)+60,:), 360, 1);
	end
	
	% Run HSPICE Simulation
	[~,~] = dos([hspice_path, ' -i path_new.sp -o mc_out.lis']);
    file1 = fopen('path_new.log', 'r');
	
	% Parse HSPICE Output
	idx = 1;
	while(idx <= BATCH_SZ)
		line = fgetl(file1);
		if(~ischar(line))
		  break;
		end
		if(contains(line,'td='))
			result = regexp(line, '(?<=td=) \d+\w', 'match');
			result = regexprep(result, 'p', 'e-12');
			result = regexprep(result, 'n', 'e-09');
			result = regexprep(result, 'f', 'e-15');
			if str2double(result) < CLASS_THR
				labels(BATCH_SZ*(i-1)+idx) = 0;
			else
				labels(BATCH_SZ*(i-1)+idx) = 1;
			end
			idx = idx + 1;
		end
	end
	
    fclose(file1);
end