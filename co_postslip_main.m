%% LogSIM
% The Toolbox LogSIM for joint invertion of coseismic and postseismic slip 
% from multi_InSAR datasets (unwrapped interferograms) 
% 
%% CITATION
% We request LogSIM users to cite our publication of LogSIM:
% Liu, X., & Xu, W. (2019), JGR, https://doi.org/10.1029/2019JB017953.

clc;clear;close all
addpath('mfiles');
load ./matdir/data

X = nlfitsolver(simdata,los);
save X X
%plot the results
plot_spatio_temporal_slip(X,'slip_residuals')
error_calculation_propagation(X,'X')
%% iter step of step5
%%iter inversion by constrian patches where occur big covariance
X = nlfitsolver1(simdata,los);
save X1 X
% plot the results
error_calculation_propagation(X,'X1')
plot_spatio_temporal_slip(X,'slip_residuals1')


