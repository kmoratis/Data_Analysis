% Moratis Konstantinos
% Alexandros Tsingilis

% k-degree polynomial regression, non-linear regression

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;
names = string(headers);
n = length(data);

names = string(headers);

for i = 2:12
    % exclude FG and TN as independent (Y)
    if i==10 || i==11
        continue;
    end
    
    [index, m] = Group39Exe7Fun1(data(:,i), data(:,10), names(i));
    if (index<4)
        fprintf("Independent index: %s, best model: %d -degree polynomial, adj R^2 = %f\n", names(i), index, m);
    elseif (index==4)
        fprintf("Independent index: %s, best model: y = a*exp(b*x), adj R^2 = %f\n", names(i), m);
    elseif (index==5)
        fprintf("Independent index: %s, best model: y = a*(x^b), adj R^2 = %f\n", names(i), m);
    elseif (index==6)
        fprintf("Independent index: %s, best model: y = a + b*log(x), adj R^2 = %f\n", names(i), m);
    elseif (index==7)
        fprintf("Independent index: %s, best model: y = α + β*(1/x), adj R^2 = %f\n", names(i), m);
    end
        
end

%% Results Analysis
%{
    According to the results, index RA can best describe the dependent
    varable (FG), with the use of 2-degree polynomial regression, with
    adj_R2 = 0.349.

    Second best choise is independent T, with y = a*(x^b) non-linear model,
    which gives  adj_R2 = 0.2538.

%}
