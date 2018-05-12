import numpy as np

def relieff(x, N):
	data = x[:]
	m,n = data.shape
	weights = np.zeros(m-1, dtype='float')
	for i in range(N):
		R = randInt(0, n)
		# Euclidean distances... this scales with O(n^2) so 10000 is out of the question