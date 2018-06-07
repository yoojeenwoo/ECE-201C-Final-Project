
function [samples] = sample_gen(batch_size, saver)
% @param batch_size: Integer size of the batch of samples to generate
% @param saver: Boolean value indicating whether to save the generated
% samples in a .mat file
% @return samples: The generated (60*batch_size x 6) sample matrix

	% Columns: toxe, xl, xw, vth, u0, voff
	param_names = ['toxe'; 'xl  '; 'xw  '; 'vth0'; 'u0  '; 'voff'];
	% Rows: mean(pmos), std(pmos), mean(nmos), std(nmos)
	params = [[2.7e-9, 5.1e-9, 1.8e-8, -3.96e-1, 8.807e-3, -1.5e-1] 
	[3.376e-20, 4.277e-21, 5.687e-20, 1.15e-2, 4.196e-5, 1.797e-3]
	[2.37e-9, 5.8e-9, 1.7e-8, 3.29e-1, 2.605e-2, -1.54e-1] 
	[3.602e-22, 4.681e-20, 1.156e-19, 1.094e-2, 5.942e-6, 1.367e-2]];
	
	% Sample array will be organized as
	%		toxe xl xw vth0 u0 voff
	% Gate1
	% Gate2
	% ...
	% Gate10
	% Each gate's rows include 3 pmos values and 3 nmos values
    
	rng('shuffle'); % Seed RNG with current time
	samples = zeros(60*batch_size, 6);
%     for b = 0:batch_size-1
%         for p = 1:6
% 			pmos = normrnd(params(1, p), params(2, p), 30);
% 			nmos = normrnd(params(3, p), params(4, p), 30);
% 			for gate = 0:9
% 				samples(b*60+gate*6+1:b*60+gate*6+3, p) = pmos(gate*3+1:gate*3+3);
% 				samples(b*60+gate*6+4:b*60+gate*6+6, p) = nmos(gate*3+1:gate*3+3);
%             end
%         end
%     end
    for p = 1:6
        pmos = normrnd(params(1, p), params(2, p), 30*batch_size, 1);
        nmos = normrnd(params(3, p), params(4, p), 30*batch_size, 1);
        for gate = 0:(10*batch_size-1)
            samples(gate*6+1:gate*6+3, p) = pmos(gate*3+1:gate*3+3);
            samples(gate*6+4:gate*6+6, p) = nmos(gate*3+1:gate*3+3);
        end
    end
	
    if saver==true
        write_params(param_names, samples, batch_size);
    end
end


