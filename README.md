# ECE-201C-Final-Project

### Useful Commands
1. Must be run before using HSPICE. Switch to `csh` first.

```source /w/apps3/Synopsys/HSPICE/vG-2012.06/SETUP```

2. Path for 2016a edition of MATLAB

```/w/apps3/Matlab/R2016a/bin/matlab```

3. Runs MATLAB script with no hangup directly from command line. MATLAB console output is printed to `nohup.out`.

```nohup /w/apps3/Matlab/R2016a/bin/matlab -r -nodisplay -nodesktop "run('presample.m')" &```

4. Simulate the filtered samples.
```simulate(1.38e-10, 50, 'sim_results.mat', false, true);```
