% Moratis Konstantinos
% Alexandros Tsingilis

% Parametric and bootstrap null hypothesis testing for equal means

function [output1,output2] = Group39Exe3Fun1(inputVector1,inputVector2)
% given inputVector1 and inputVector2, it finds the first discontinuation
% point in inputVector1 data, and creates two sub-vectors by spliting
% inputVector2 at the discontinuation point. 
% After that, it calculates parametric and bootstrap h and p values for the
% null hypothjesis that the two sub-vectors have equal means
% output1 = parametric p-value, output2 = bootstrap p-value

    n = numel(inputVector1);
    found = 0;

    for i = 1:n-1
        if inputVector1(i) + 1 ~= inputVector1(i+1)
            % found discontinuation
            X_1 = inputVector2(1:i);
            X_2 = inputVector2(i+1:n);
            found = 1; 
        end
    end

    if found == 0
        fprintf("Error: Discontinuation point not found\n");
        return;
    end

    %H0: X_1, X_2 come from the same distr (normal) with mu_x = mu_y
    alpha = 0.05;

    % parametric hypothesis check
    [param_h, param_p] = ttest2(X_1,X_2,'Alpha',alpha);


    % bootstrap hypothesis check
    b_samples = 1000;

    X = [X_1; X_2]; % X == inputVector2 just for reusability
    n1 = numel(X_1);
    n2 = numel(X_2);

    B = zeros(n1+n2,b_samples); % B = (n1+n2)x1000

    % create bootstrap samples ( only for equal means hypothesis check)
    for i = 1:b_samples
        for j = 1:n1+n2
            p = round(unifrnd(1,n1+n2)); %uniformly distr numbers in range [1,n1+n2].
            B(j,i) = X(p,1);
        end
    end

    % split B to create bootstrap samples for X_1 and X_2
    B_X1 = B(1:n1,:);
    B_X2 = B(n1+1:n1+n2,:);

    B_mu_X1 = nanmean(B_X1);
    B_mu_X2 = nanmean(B_X2);

    B_mu_diff = B_mu_X1 - B_mu_X2;

    % find initial samples diff 
    mu_X1 = nanmean(X_1);
    % handle index PP 
    % (all values before 1958 are NaN, so the mean has definetly changed)
    if isnan(mu_X1)
        output1 = param_p;
        output2 = NaN;
        return;
    end;
    mu_X2 = nanmean(X_2);
    init_diff = mu_X1 - mu_X2;

    % calculate p value
    % p value is the proportion of bootstrap test statistic, that is equal or
    % more extreme that out inital sample statistic
    boot_p = sum(abs(B_mu_diff) >= abs(init_diff)) / b_samples;


    % calculate h
    B_mu_diff(1, end + 1) = init_diff;

    B_diff_sorted = sort(B_mu_diff);

    % finding rank
    k_1 = floor((b_samples + 1) * alpha/2);
    k_2 = floor((b_samples + 1) * (1 - alpha/2));
    rank = find(B_diff_sorted(1,:) == init_diff);

    % finding h
    if (rank >= k_1) && (rank <= k_2)
        boot_h = 0; % h = 0 means H0 not rejected
    else
        boot_h = 1; % h = 1 means H0 rejected
    end
    
    output1 = param_p;
    output2 = boot_p;
end
