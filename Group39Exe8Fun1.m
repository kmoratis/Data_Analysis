% Moratis Konstantinos
% Alexandros Tsingilis

function [adj_r_squared, p_value] = Group39Exe8Fun1(x, y)
    % Remove missing values
    x(isnan(y)) = [];
    y(isnan(y)) = [];
    
    % Fit an exponential model using least squares
    model = fitlm(x, log(y), 'linear');
    
    % Calculate the adjusted r-squared coefficient
    adj_r_squared = model.Rsquared.Adjusted;
    
    % Perform randomization test for adjusted r-squared coefficient
    num_permutations = 1000;
    null_r_squared = zeros(num_permutations, 1);
    for i = 1:num_permutations
        shuffled_y = y(randperm(length(y)));
        null_model = fitlm(x, shuffled_y, 'poly2');
        null_r_squared(i) = null_model.Rsquared.Adjusted;
    end
    
    % Calculate p-value as proportion of null_r_squared greater than observed
    p_value = sum(null_r_squared >= adj_r_squared) / num_permutations;
end

