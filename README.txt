ADASYN.m - Function for running the ADASYN algorithm
classify.m - Use classifier to filter samples
cross_validate.m - Cross validation of trained classifier
presample.m - Generate and simulate presamples
presample_recursive.m - Recursive Statistical Blockade
presample_recursive_ADASYN.m - Recursive Statistical Blockade w/ ADASYN
sample_gen.m - Function for generating presamples
pruning.m - Parameter pruning with ReliefF
simulate.m - Function for simulating samples
Tail_fitting.m - Perform tail fitting on results
train.m - Train an SVM classifier
write_params.m - Function for writing sampled parameters to HSPICE data file

REscope:
(1) presample.m
(2) pruning.m
(3) train.m
(4) classify.m
(5) simulate.m
(6) Tail_fitting.m

REscope w/ Recursive Statistical Blockade:
(1) presample_recursive.m (or presample_recursive_ADASYN.m)
(1.5)* simulate.m
(2) Tail_fitting.m

Utilities:
ADASYN.m
cross_validate.m
sample_gen.m
write_params.m

*Note: Because of difficulties with the EEAPPS server, presample_recursive.m cannot be run on EEAPPS. The script was run on our personal computers. Using breakpoints, we ran only the simulate line on the EEAPPS servers.