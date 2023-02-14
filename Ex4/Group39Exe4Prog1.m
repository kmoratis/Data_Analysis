% Moratis Konstantinos

% Correlation coefficient ci (parametric and bootstrap)
% and H0: r=0 (parametric and non-parametric: random-perm) testing.

clc;
clear;
close all;

data_structure = importdata('Heathrow.xlsx');
data = data_structure.data.Sheet1;
headers = data_structure.colheaders.Sheet1;
n = length(data);

names = string(headers);
cor_pairs = ["Index1" "Index2" "Param p-val" "Random-per p-val" "Param ci low" "Param ci up" "Boot ci low" "Boot ci up"];

for i=2:9
    for j = i+1:10
        [n, param_p, rp_p, param_ci, boot_ci] = Group39Exe4Fun1(data(:,i), data(:,j));
        
        % test for each metric
        % h = 0  means cannot reject H0: r = 0
        % h = 1 means i can reject H0 with 95% confidence
        param_ci_h = ~(param_ci(1) <= 0 && param_ci(2) >= 0);
            
        boot_ci_h = ~(boot_ci(1) <= 0 && boot_ci(2) >= 0);
        
        param_p_h = param_p <= 0.05;
        
        randperm_p_h = rp_p <= 0.05;
        
        % if at least one of the h is zero write the pair on the list
        if( ~param_ci_h || ~boot_ci_h || ~param_p_h || ~randperm_p_h )
            pair = [names(i) names(j) string(param_p) string(rp_p) string(param_ci) string(boot_ci)];
            cor_pairs = [cor_pairs; pair];
        end
    end
end

% print list with indexes pairs, that are linear correlated with
% 0.05 significance level
fprintf("Indexes pairs that are linear correlated according to the specific approach:\n");
for i=2:length(cor_pairs)
    fprintf("%s\t%s : ", cor_pairs(i,1), cor_pairs(i,2));
    % param p-val
    if(str2double(cor_pairs(i,3)) >= 0.05)
        fprintf(" param test,");
    end
    if(str2double(cor_pairs(i,4)) >= 0.05)
        fprintf(" rand perm test,");
    end
    if(str2double(cor_pairs(i,5)) < 0 && str2double(cor_pairs(i,6)) > 0)
        fprintf(" param ci,");
    end
    if(str2double(cor_pairs(i,7)) < 0 && str2double(cor_pairs(i,8)) > 0)
        fprintf(" boot ci\n");
    else
        fprintf("\n");
    end
end
fprintf("\n");

% print the 3 pairs with the most significant correlation according to the
% two tests
param_test_pvals = str2double(cor_pairs(2:length(cor_pairs),3));
[~, sortedInds] = sort(param_test_pvals(:),'descend');
top3 = sortedInds(1:3) + [1;1;1];
fprintf("Indexes with the most significant correlation according to:\n");
fprintf("Parametric test: ");
for i=1:3
    fprintf("%s %s, ", cor_pairs(top3(i),1), cor_pairs(top3(i),2));
end
fprintf("\n");

rand_test_pvals = str2double(cor_pairs(2:length(cor_pairs),4));
[~, sortedInds] = sort(rand_test_pvals(:),'descend');
top3 = sortedInds(1:3) + [1;1;1];
fprintf("Random permutation test: ");
for i=1:3
    fprintf("%s %s, ", cor_pairs(top3(i),1), cor_pairs(top3(i),2));
end
fprintf("\n");

%%  Results Analysis:
%{ 
    The results of the 4 approaches are in comply with each other for the
    most of the cases.
 
    Also, the two tests (parametric and random-permutation) are in
    compliance about the three pairs with the most significant correlation.    
%}