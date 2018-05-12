N_PRESAMPLE = 1000
TAIL_THR = 1.395e-10
CLASS_THR = 1.38e-10
hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';

%% PRESAMPLE STAGE

% Presampled Data will group data points by column.
% Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
presample_data = zeros(360, N_PRESAMPLE);
labels = zeros(N_PRESAMPLE);

for i in 1:N_PRESAMPLE
	samples = reshape(sample_gen(), 360);
	[~,~] = dos([hspice_path, ' -i path_new.sp -o mc_out.lis']);


	output = fopen('mc_out.lis', 'r');;
	result = regexp(output, 'median\s+=\s+\d+\.\d+\w', 'match');
	result = regexprep(result, 'median\s+=\s+', '');
	result = regexprep(result, 'p', 'e-12');
	result = regexprep(result, 'n', 'e-09');
	result = regexprep(result, 'f', 'e-15');
	if str2double(result) < CLASS_THR
		labels(i) = 0
	else
		labels(i) = 1
	presample_data(:,i) = samples
end