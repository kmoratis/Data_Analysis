% Moratis Konstantinos
% Alexandros Tsingilis

% X_square test and Data visualization (histogram, bar graph) 

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;

% array for saving p_vals for every index
p_vals = NaN(11,3);
for i = 2:12
    name = headers(1,i);
    vector = data(:,i);
    [p_vals(i-1,1), p_vals(i-1,2), p_vals(i-1,3)] = Group39Exe1Fun1(vector, name);
end

output_arr = string(NaN(11,2)); 
names = string(headers).';
names = names(2:12);
output_arr = [names output_arr];
output_arr = ["Name" "Type" "Distribution"; output_arr];
%output_arr = 12x3

for i = 1:11
    name = string(headers(1,i+1));
    %p_vals(i,3) == 1 if index_i data continuous
    if p_vals(i,3) % continuous data
        output_arr(i+1,2) = "continuous";
        if p_vals(i,1) >= 0.05
            output_arr(i+1,3) = "normal";
            fprintf("Index %s handled as continuous, follows normal distribution\n", name);
        elseif p_vals(i,2) >= 0.05
            output_arr(i+1,3) = "uniform";
            fprintf("Index %s handled as continuous, follows uniform distribution\n", name);
        else
            output_arr(i+1,3) = "none";
            fprintf("Index %s handled as continuous, follows none of the two\n", name);
        end
        
    else % discrete data
        output_arr(i+1,2) = "discrete";
        if p_vals(i,1) >= 0.05
            output_arr(i+1,3) = "binomial";
            fprintf("Index %s handled as discrete, follows binomial distribution\n", name);
        elseif p_vals(i,2) >= 0.05
            output_arr(i+1,3) = "discrete uniform";
            fprintf("Index %s handled as discrete, follows discrete uniform distribution\n", name);
        else
            output_arr(i+1,3) = "none";
            fprintf("Index %s handled as discrete, follows none of the two\n", name);
        end
    end
end
