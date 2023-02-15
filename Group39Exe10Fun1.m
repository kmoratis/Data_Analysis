function [optimal_model, lasso_penalty_factor] = Group39Exe10Fun1(y, X)
    % Find rows with complete data
    rows_with_complete_data = all(~isnan(X), 2);
    X = X(rows_with_complete_data, :);
    y = y(rows_with_complete_data);
    
    % Calculate adjusted R-squared for all possible linear regression models
    num_variables = size(X, 2);
    num_models = 2^num_variables - 1;
    models = cell(num_models, 1);
    adj_r_squared = zeros(num_models, 1);
    for i = 1:num_models
        included_variables = logical(flip(dec2bin(i, num_variables)'-'0'));
        X_subset = X(:, included_variables);
        model = fitlm(X_subset, y);
        models{i} = model;
        adj_r_squared(i) = model.Rsquared.Adjusted;
    end
    
    % Select optimal model
    [max_adj_r_squared, optimal_index] = max(adj_r_squared);
    optimal_model = models{optimal_index};
    
    % Apply LASSO and check if optimal model is achieved
    lasso_models = lasso(X, y, 'CV', 10);
    num_penalties = size(lasso_models, 2);
    lasso_adj_r_squared = zeros(num_penalties, 1);
    for i = 1:num_penalties
        lasso_model = fitlm(X(:, lasso_models(:, i)~=0), y);
        lasso_adj_r_squared(i) = lasso_model.Rsquared.Adjusted;
    end
    [max_lasso_adj_r_squared, lasso_index] = max(lasso_adj_r_squared);
    if max_lasso_adj_r_squared >= max_adj_r_squared
        lasso_penalty_factor = lasso_models(:, lasso_index)'*lasso_models(:, lasso_index);
        optimal_model = fitlm(X(:, lasso_models(:, lasso_index)~=0), y);
    else
        lasso_penalty_factor = [];
    end
end

