% Moratis Konstantinos
% Alexandros Tsingilis

% Parametric and bootstrap null hypothesis testing for equal means

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;
n = length(data);

years = data(:,1);
names = string(headers); 

for i = 2:10
    [param_p, boot_p] = Group39Exe3Fun1(years, data(:,i));
    
    % print the results
    fprintf("For index %s, parametric p-val = %f, bootstrap p-val = %f\n", string(headers(i)), param_p, boot_p);
end

%% Results analysis
%{
    The null hypothesis that we meade was that the indexes has the same means
  at the two time periods. So, a small p-value (less than 0.05) indicates that 
  with 95% certainty we can reject the null hypothesis that we made, which
  means that the means are different. The indexes for which this is true
  are T, TM, V, RA, TS and FG. 
    Also for index PP, all the values for the first period are NaN, so we
  can't tell.
    The index FG has the smallest p-val for both types of checks, so we can
  be more certain that it's mean value changed significantly. Also, this is 
  an indicator that it's value changed the most between the two periods.
    The results from the two types of checks (parametric and bootstrap) are
  pretty simillar, but we note that if we want to be more certain about our
  decision (rejection) we can pick the biggest value of the two for each
  index, which leads to bigger safety.
%}
