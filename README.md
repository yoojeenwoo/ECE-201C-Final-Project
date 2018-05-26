# ECE-201C-Final-Project

### Design Flow
1. Presample (`presample.m`)

Run Monte Carlo and simulate the results in batches. Outputs parameters and labels.

2. Parameter Pruning (`pruning.m`)

Prunes parameters with RELIEFF and returns the indices of only the significant parameters.

2. Recursive Statistical Blockade (`presample_recursive.m`)

Run RELIEFF on presample data to prune parameters. Recursively sample and simulate data, train the classifier, and use classifier to filter out consecutive data.

3. Tail Fitting (`Tail_fitting.m`)

Construct model of tail using Generalized Pareto Distribution

### Utilities
- Monte Carlo (`sample_gen.m`)

Generates batch of sampled parameters using Monte Carlo.

- Simulation (`simulate.m`)

Simulates a batch of sampled parameters using HSPICE. Parses output file and labels data according to given threshold.

- Write HSPICE Parameter File (`write_params.m`)

Writes batch of sampled parameters to text file in HSPICE data format.

- Concatenate (`concat.m`)

Concatenates data from multiple presample runs together. Used after step 1.

- Train Classifier (`train.m`)

Trains classifier with optional 10-fold cross validation.


### Useful Commands
1. Must be run before using HSPICE. Switch to `csh` first.

```source /w/apps3/Synopsys/HSPICE/vG-2012.06/SETUP```

2. Path for 2016a edition of MATLAB

```/w/apps3/Matlab/R2016a/bin/matlab```

3. Runs MATLAB script with no hangup directly from command line. MATLAB console output is printed to `nohup.out`.

```nohup /w/apps3/Matlab/R2016a/bin/matlab -r -nodisplay -nodesktop "run('presample.m')" &```
or use
```nohup /w/apps3/Matlab/R2016a/bin/matlab -r -nodisplay -nodesktop "run('presample.m')" >& "presampleout.out"```


4. Simulate the filtered samples.

```simulate(1.38e-10, 50, 'sim_results.mat', false, true);```
