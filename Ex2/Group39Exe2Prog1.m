% Moratis Konstantinos
% Alexandros Tsingilis

% Parametric and bootstrap ci

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;
n = length(data);

data_before73 = data(1:10,:);
data_after73 = data(11:n,:); %including 73
for i = 2:10
    [param_ci, boot_ci] = Group39Exe2Fun1(data_after73(:,i));
    
    % calculate '49-58 mean value of the index
    mu = mean(data_before73(:,i));
    
    % print the results
    fprintf("For index %s, parametric ci = [%f %f], boot ci = [%f %f]\n", string(headers(i)), param_ci(1), param_ci(2), boot_ci(1), boot_ci(2));
    
    % check if mu exists in both ci
    if ((mu >= param_ci(1) && mu <= param_ci(2)) && (mu >= boot_ci(1) && mu <= boot_ci(2)));
        fprintf("Mean value of index in years 49-58 = %f, exists in both ci\n\n", mu);
    elseif(mu >= param_ci(1) && mu <= param_ci(2))
        fprintf("Mean value of index in years 49-58 = %f, exists only in parametric ci\n\n", mu);
    elseif(mu >= boot_ci(1) && mu <= boot_ci(2))
        fprintf("Mean value of index in years 49-58 = %f, exists only in bootstrap ci\n\n", mu);
    else
        fprintf("Mean value of index in years 49-58 = %f, does not exist in any of the ci's\n\n", mu);
    end
end

%% Results analysis
%{
    In regards to parametric and bootstrap ci being different, we noticed
  that the parametric ci's give a slighty bigger range of values, which leads to
  bigger safety for the test.
    But besides that, for most of the indeces the give similar results.
    

    The mean value of the first period has changed significantly in 
  the second period if the mean value that we calculated (for the first period) 
  does not exist in the ci for the mean value ( that we calculated for the second).
  That means that the mean value of the second period will be (with 95%
  certainty) inside the ci, so it can not be the same as the first's
  period.
  This happens for the indexes T, TM, V, RA, TS, FG, so we consider that
  these indexes mean value has changed. 
  For index PP we dont have values for the first period, so we can't tell.
%}
