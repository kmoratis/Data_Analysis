% Moratis Konstantinos
% Alexandros Tsingilis

% Exercise 10 Demo

clear;
clc;
close all;

% Load Data
data = readtable('Heathrow.xlsx');
% remove `Year` and `TN`
data = removevars(data, {'Year', 'TN'});

disp("Independent Variabe 'Tn':")
disp("===========================")

% DO ANALYSIS FOR 'TN'
% Dependent Variable
y = data{:,'FG'};
% Independent Variables
X = removevars(data, {'FG', 'GR'});
X = table2array(X);

% Fit model
[optimal_model, lasso_penalty_factor] = LASSO_reg(y, X)

disp("Independent Variabe 'GR':")
disp("===========================")

% DO ANALYSIS FOR 'GR'
% Dependent Variable
y = data{:,'GR'};

% Fit model
[optimal_model, lasso_penalty_factor] = LASSO_reg(y, X)
