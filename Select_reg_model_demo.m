% Moratis Konstantinos
% Alexandros Tsingilis

% Exercise 8 Demo

clear;
clc;
close all;

% Load Data
data = readtable('Heathrow.xlsx');
data = removevars(data,{'Year','TN'});
% Set the dependend variable to be the FG indicator
y = data{:,'FG'};
% Set the independet variable to be every indicator except the TN indicator;
data = removevars(data,{'FG'});
x_names = data.Properties.VariableNames;

% Fit Models
adj_r_sq = [];
p_values = [];
for i=1:length(x_names)
    fprintf("Fitting Quadratic Model for indicator '%s'.\n",x_names{i});
    x = table2array( data(:,i) );
    [adj_r_sq(i), p_values(i)] = Select_reg_model(x,y);
    fprintf("The adj-r-square coeffcient is %f.\n\n",adj_r_sq(i));
end
