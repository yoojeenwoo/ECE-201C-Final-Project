N_PRESAMPLE = 1000;
TAIL_THR = 1.395e-10;
CLASS_THR = 1.38e-10;
BATCH_SZ = 1;
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE

% Presampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
presample_data = zeros(360*BATCH_SZ, N_PRESAMPLE); 
labels = zeros(1, N_PRESAMLE);

for i = 1:N_PRESAMPLE
	for j = 1:BATCH_SZ
		presample_data(:,j) = reshape(sample_gen(BATCH_SZ), 360, 1);
	end
	presample_data(:,i) = samples;
	[~,~] = dos([hspice_path, ' -i path_new.sp -o mc_out.lis']);

    file1 = fopen('path_new.log', 'r');
	idx = 1;
	while(1)
		line = fgetl(file1);
		if(~ischar(line))
		  break;
		end
		if(contains(line,'td='))
			result = regexp(line, '(?<=td=) \d+\w', 'match');
			break
		end
	end
	result = regexprep(result, 'p', 'e-12');
	result = regexprep(result, 'n', 'e-09');
	result = regexprep(result, 'f', 'e-15');
	if str2double(result) < CLASS_THR
		labels(i) = 0;
	else
		labels(i) = 1;
    end
    fclose(file1);
end