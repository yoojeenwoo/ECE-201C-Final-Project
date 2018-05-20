function [] = write_params(param_names, samples, num)
% @param param_names: 1x6 character array of parameter names
% @param samples: 60*num x 6 array of samples
% @param num: Number of Samples


% Construct file header
% Example name: toxe_p12, where p is pmos, 1 is stage, 2 is index
fid1 = fopen('sweep_data_mc','w');
fprintf(fid1, '.DATA data\n');
for gate = 1:10
    for i = 0:5
        if (i < 3)
            pn = 'p';
        else
            pn = 'n';
        end
        for j = 1:6
            fprintf(fid1, '%s_%s%d%d', deblank(param_names(j,:)), pn, gate, mod(i,3)+1);
            if (j == 6)
                fprintf(fid1, '\n');
            else
                fprintf(fid1, ' ');
            end
        end
    end
end

for i=1:60*num
    for j=1:6
        fprintf(fid1, '%e', samples(i, j));
        if (j == 6)
            fprintf(fid1, '\n');
        else
            fprintf(fid1, '\t');
        end
    end
end
fprintf(fid1, '.ENDDATA');

end