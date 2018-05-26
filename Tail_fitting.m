clc;
clear all;
close all;
load 5_25_results.mat
%calculating the mean and variance of output delays
mean_out_delay=mean(td);
sigma=(var(td))^(1/2);
%6 sigma
thresh6=mean_out_delay+6*sigma;

%fitting parameters for GPD
paramEsts = gpfit(td(td>thresh6)-thresh6);
kHat      = paramEsts(1)   % Tail index parameter
sigmaHat  = paramEsts(2)   % Scale parameter
x = linspace(0,100,1000);
fit6sigma = gppdf(x,kHat,sigmaHat,0);

%plotting the fit
delay6thresh = td(td>thresh6);
[nelements,centres] = hist(delay6thresh,100);
figure
plot(centres,nelements/length(td),'o')
hold on
plot(x/1e13+thresh6,fit6sigma/length(td)*length(td(td>thresh6)),'-')
legend('Sample points','GPD Fitting Curve')
hold off
xlabel('Delay (s)')
ylabel('Probability')
