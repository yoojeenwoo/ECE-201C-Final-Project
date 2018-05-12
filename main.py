import os
import re
from sklearn.svm import svc
import numpy as np
import sample_gen as mc

N_PRESAMPLE = 1000
TAIL_THR = 1.395e-10
CLASS_THR = 1.38e-10

## PRESAMPLE STAGE

# Presampled Data will group data points by column.
# Row 0 will be the tail/non-tail result corresponding to the parameters in rows 1-360
presample_data = np.zeros((361, N_PRESAMPLE), dtype='float')

for i in range(N_PRESAMPLE):
	samples = np.reshape(mc.sample_gen(), 360) # Generate one set of samples
	# os.system("hspice -i -o sim.lis") # Simulate with SPICE
	f = open("sim.lis", 'r')
	output = f.read()
	result = re.findall("median\s+=\s+\d+\.\d+\w", output)
	result = re.sub("median\s+=\s+", '', result[0])
	result = re.sub('p', 'e-12', result)
	result = re.sub('n', 'e-09', result)
	result = re.sub('f', 'e-15', result)
	if float(result) < CLASS_THR:
		presample_data[0, i] = 0
	else
		presample_data[0, i] = 1
	presample_data[1:,i] = samples
	
## PARAMETER PRUNING, possible to tune k in this part

## CLASSIFICATION
clf = svc(C=1.0, gamma="auto", decision_function_shape="ovo")
# clf.train()