import random
import numpy as np

def sample_gen(N):
	# Columns: toxe, xl, xw, vth, u0, voff
	param_names = ["toxe", "x1", "xw", "vth", "u0", "voff"]
	# Rows: mean(pmos), std(pmos), mean(nmos), std(nmos)
	params = np.array(
	[[2.7e-9, 5.1e-9, 1.8e-8, -3.96e-1, 8.807e-3, -1.5e-1], 
	[3.376e-20, 4.277e-21, 5.687e-20, 1.15e-2, 4.196e-5, 1.797e-3],
	[2.37e-9, 5.8e-9, 1.7e-8, 3.29e-1, 2.605e-2, -1.54e-1], 
	[3.602e-22, 4.681e-20, 1.156e-19, 1.094e-2, 5.942e-6, 1.367e-2]])


	# Sample array will be organized as [nand1,...,nand10, inv1,...,inv10]
	# Each gate's columns will be split as the following:
	# nand: q1 (pmos), q2 (pmos), q3 (nmos), q4 (nmos)
	# inv: q1 (pmos), q2 (nmos)

	# Generate NAND Samples
	nand_samples = np.zeros((N, 240), dtype="float")
	for gate in range(10):
		for q in range(4):
			for p in range(6):
				if (q < 2):
					nand_samples[:,gate*24+q*6+p] = np.random.normal(params[0, p], params[1, p], size=N)
				else:
					nand_samples[:,gate*24+q*6+p] = np.random.normal(params[2, p], params[3, p], size=N)

	# Generate Inverter Samples
	inv_samples = np.zeros((N, 120), dtype="float")
	for gate in range(10):
		for q in range(2):
			for p in range(6):
				inv_samples[:, gate*12+q*6+p] = np.random.normal(params[2*q, p], params[2*q+1, p], N)
				
	samples = np.concatenate((nand_samples, inv_samples), axis=1)
	
	# Construct file header
	# Example header: nand1_q1_toxe
	head = ".DATA data\n"
	for gate in range(10):
		for q in range(4):
			for p in range(6):
				head += "nand%d_q%d_%s " % (gate, q, param_names[p])
				
	for gate in range(10):
		for q in range(2):
			for p in range(6):
				head += "inv%d_q%d_%s " % (gate, q, param_names[p])
	
	np.savetxt("samples.txt", samples, delimiter='\t', header=head, footer=".ENDDATA", comments='')
	return samples
	
if __name__ == '__main__': # Test
	print(sample_gen(5))