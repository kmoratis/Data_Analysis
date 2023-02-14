% Moratis Konstantinos
% Alexandros Tsingilis

% Simple linear regression model, R^2

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;
n = length(data);

names = string(headers);

R_matrix = ["X \ Y" "T" "TM" "Tm" "PP" "V" "RA" "SN" "TS" "FG" "GR"];

counter_r = 1;
% dependent (Y)
for i = 2:12
    counter_r = counter_r + 1;
    % skip index (TN)
    if i == 11
        counter_r = counter_r - 1;
        continue;
    end
    % matrix of 9 plots
    fig = figure('Name',"Independent variable: " + names(i),'NumberTitle','off', 'Position', [4, 4, 1080, 720]);
    t = tiledlayout(3,4);
    t.Title.String = "Scatter plot of indexes for dependent variable " + names(i);
    t.Title.FontWeight = 'bold';
    counter_c = 1;
    for j = 2:12 % independent(X)
        counter_c = counter_c + 1;
        % skip index (TN), and index Y
        if j == 11
            counter_c = counter_c - 1;
            continue;
        end
        if j == i
            continue;
        end
        
        R = Group39Exe6Fun1(data(:,j), data(:,i), fig, names(j));
        R_matrix(counter_r,1) = headers(i);
        R_matrix(counter_r, counter_c) = R;
    end
end

% find the two best models ( independent vars) for each dependent var, according to R^2
Answer_mat = ["Dependent var (Y)"; "T"; "TM"; "Tm"; "PP"; "V";"RA"; "SN"; "TS"; "FG"; "GR"];
help_arr = NaN(10,4);
help_arr = ["Best independent(X)" "Best R_square" "Sec_Best (X)" "Sec_Best R_square"; help_arr];
Answer_mat = [Answer_mat help_arr];

for i = 2:11
    R_sorted = sortrows(R_matrix(2:11,:),i);
    counter = 0;
    % handling really small values (eg 3.3994e-06), that are sorted as the
    % biggest value)
    while (double(R_sorted(9-counter, i)) < 0.0001)
        counter = counter+1;
    end
    Answer_mat(i, 2) = R_sorted(9-counter,1); % name of independent (best)
    Answer_mat(i,3) = R_sorted(9-counter,i); % R^2 of independent (best)
    Answer_mat(i,4) = R_sorted(8-counter,1); % name of independent (second best)
    Answer_mat(i,5) = R_sorted(8-counter,i); % R^2 of independent (second best)
end

%% Results Analysis
%{
    According to the results in Answer_mat, the indexes T and TM can
    best describe each other with the use of the linear model,
    because the R^2 = 0.95475 in this case. 

    This result agrees with the scatter plot for (T, TM), where the points
    of the plot seems to have a linear relation.
%}
