function [labels, td] = simulate(CLASS_THR, num, filename, presample, saver)
% @param CLASS_THR: Classification Threshold (in terms of delay time)
% @param num: Simulation Batch Size
% @param filename: File to which workspace can be saved
% @param presample: If true, function will calculate labels.
% @param save: If true, function will save workspace to local drive.
    hspice_path = '/w/apps3/Synopsys/HSPICE/vG-2012.06/hspice/bin/hspice';
    td = zeros(1, num);
    labels = zeros(1, num);
    
    % Run HSPICE Simulation
    [~,~] = dos([hspice_path, ' -i path_new_1.sp -o mc_out.lis']);
    file1 = fopen('mc_out.lis', 'r');

    % Parse HSPICE Output
    idx = 1;
    while(idx <= num)
        line = fgetl(file1);
        if(~ischar(line))
          break;
        end
        if(strfind(line,'td='))
            result = regexp(line, '(?<=td=) \d+\.\d+\w', 'match');
            result = regexprep(result, 'p', 'e-12');
            result = regexprep(result, 'n', 'e-09');
            result = regexprep(result, 'f', 'e-15');
            td(idx) = str2double(result);
            if presample==true
                if str2double(result) < CLASS_THR
                    labels(idx) = 0;
                else
                    labels(idx) = 1;
                end
            end
            idx = idx + 1;
        end
    end

    fclose(file1);
    if saver==true
        save(filename);
    end
end