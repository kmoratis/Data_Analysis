% Moratis Konstantinos
% Alexandros Tsingilis

% Correlation coefficient ci (parametric and bootstrap)
% and H0: r=0 (parametric and non-parametric: random-perm) testing.

function [output1, output2, output3, output4, output5] = Group39Exe4Fun1(inputVector1,inputVector2)
% Function takes two vectors with same size, finds the NaN el in the
% vectors and removes the particular pairs that includes each NaN el.
% Then it calculates the 95% ci for correlation coefficient with two ways
% (parametric-using Fisher transhform and with bootstrap.)
% Also it does parametric and non-parametric (random permutation) test for
% the null hypotehesis H0: r=0 (not correlated)

% output1 = length of Vectors (NaN el removed), output2 = param p-value,
% output3 = non-param p-value, outpu4 = param ci, output5 = boot ci.

    % check if input vectors have same length (not necessary) 
    if(numel(inputVector1) ~= numel(inputVector2))
        fprintf("Wrong input. The two vectors must have the same size.");
        return;
    end

    % create new vectors, with no NaN elements
    inputArr = [inputVector1 inputVector2];
    newArr = inputArr((all((~isnan(inputArr)),2)),:);

    newVector1 = newArr(:,1);
    newVector2 = newArr(:,2);

    n = numel(newVector1);
    alpha = 0.05;

    % calculate r
    r_mat = corrcoef(newVector1, newVector2);
    r_val = r_mat(1,2);

    % confidence interval using Fisher transform (tanh)
    z_val = 0.5*log((1+r_val)/(1-r_val));
    zcrit = norminv(1-alpha/2);
    zsd = sqrt(1/(n-3));

    z_lower = z_val-zcrit*zsd;
    z_upper = z_val+zcrit*zsd;
    % reverse to find r ci
    r_lower = (exp(2*z_lower)-1)/(exp(2*z_lower)+1);
    r_upper = (exp(2*z_upper)-1)/(exp(2*z_upper)+1);
    param_r_ci = [r_lower r_upper];

    % Bootstrap ci
    b_samples = 1000;
    B_1 = NaN(n,b_samples); % B = nx1000
    B_2 = NaN(n,b_samples);
    % create bootstrap samples
    for i = 1:b_samples
        for j = 1:n
            p = round(unifrnd(1,n)); %uniformly distr numbers in range [1,n].
            B_1(j,i) = newVector1(p,1);
            B_2(j,i) = newVector2(p,1);
        end
    end

    % calculate r for bootstrap samples
    r_val_b = NaN(1000,1);
    for i = 1:b_samples
        r_mat_b = corrcoef(B_1(:,i), B_2(:,i));
        r_val_b(i,1) = r_mat_b(1,2);
    end
    r_val_b_s = sort(r_val_b);
    k_1_b = floor((b_samples + 1) * alpha/2);
    k_2_b = floor((b_samples + 1) * (1 - alpha/2));
    b_rl = r_val_b_s(k_1_b);
    b_ru = r_val_b_s(k_2_b);
    b_ci = [b_rl b_ru];

    % hypothesis test for H0: r=0 using the t-statistic
    t_val = r_val.*sqrt((n-2)./(1-r_val.^2));
    tcrit = tinv(1-alpha/2,n-2);

    if abs(t_val)<tcrit
        param_h = 0;
    else 
        param_h = 1;
    end
    % find p-value for the parametric test
    param_p = 2 * (1 - tcdf(abs(t_val), n-2)); % two-tailed test

    % non-parametric test for H0: r=0
    L = 1000;

    % create 1000 pair samples (newVector1_matrix(i), newVector2), that are in
    % compliance with the H0
    newVector1_matrix = NaN(n,L);
    for i = 1:L
        newVector1_matrix(:,i) = newVector1(randperm(n));
    end

    r_vals_mat_np = NaN(L+1,1);
    % calculate r_vals for the new pair values
    for i = 1:L
        r_mat_np = corrcoef(newVector1_matrix(:,i), newVector2);
        r_vals_mat_np(i,1) = r_mat_np(1,2);
    end

    % calculate p value ( must be before adding init_val to the matrix )
    % p value is the proportion of bootstrap test statistic, that is equal or
    % more extreme that out inital sample statistic
    randperm_p = sum(abs(r_vals_mat_np) >= abs(r_val)) / L;
    
    output1 = n;
    output2 = param_p;
    output3 = randperm_p;
    output4 = param_r_ci;
    output5 = b_ci;
end

