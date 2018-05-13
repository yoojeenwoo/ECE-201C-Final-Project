import random
import numpy as np

def sample_gen():
	# Columns: toxe, xl, xw, vth, u0, voff
	param_names = ["toxe", "x1", "xw", "vth", "u0", "voff"]
	# Rows: mean(pmos), std(pmos), mean(nmos), std(nmos)
	params = np.array(
	[[2.7e-9, 5.1e-9, 1.8e-8, -3.96e-1, 8.807e-3, -1.5e-1], 
	[3.376e-20, 4.277e-21, 5.687e-20, 1.15e-2, 4.196e-5, 1.797e-3],
	[2.37e-9, 5.8e-9, 1.7e-8, 3.29e-1, 2.605e-2, -1.54e-1], 
	[3.602e-22, 4.681e-20, 1.156e-19, 1.094e-2, 5.942e-6, 1.367e-2]])


	# Sample array will be organized as
	#       toxe x1 xw vth0 u0 voff
	# Gate1
	# Gate2
	# ...
	# Gate10
	# Each gate's rows include 3 pmos values and 3 nmos values
	
	samples = np.zeros((60, 6), dtype="float")
	for p in range(6):
		pmos = np.random.normal(params[0, p], params[1, p], size=30)
		nmos = np.random.normal(params[2, p], params[3, p], size=30)
		for gate in range(10):
			samples[gate*6:gate*6+3, p] = pmos[gate*3:gate*3+3]
			samples[gate*6+3:gate*6+6, p] = nmos[gate*3:gate*3+3]
	
	# Construct file header
	# Example name: toxe_p12, where p is pmos, 1 is stage, 2 is index
	head = ".DATA data\n"		
	for gate in range(10):
		for i in range(6):
			if (i < 3):
				pn = 'p'
			else:
				pn = 'n'
			for j in range(6):
				head += "%s_%s%d%d" % (param_names[j], pn, gate+1, (i%3)+1)
				if (j == 5):
					head += '\n'
				else:
					head += ' '
			
	
	np.savetxt("samples_mc.txt", samples, delimiter='\t', header=head, footer=".ENDDATA", comments='')
	return samples
	
if __name__ == '__main__': # Test
	print(sample_gen())