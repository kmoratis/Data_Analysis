% Moratis Konstantinos
% Alexandros Tsingilis

% Mutual Information Demo

clear;
clc;
close all;

% Read data
data = readmatrix("Heathrow.xlsx");

% Get two variables
x = data(:,2);
y = data(:,10);
scatter(x,y);
title("Scatter Plot of the two variables");
xlabel("x")
ylabel("y");



% Compute the Pearson Coefficient and p-values
[R,P] = corrcoef([x,y],'Rows','complete');
rho = R(2,1);
p = P(2,1);
disp(sprintf("The pearson correlation coefficent is rho = %f", rho));
disp(sprintf("The corresponding p-value is %f", p));

% Compute the Mutual Information
I = Group39Exe5Fun1(x,y);

% Print result
disp(sprintf("The Mutual Information was computed, I = %f", I));
