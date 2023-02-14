% Moratis Konstantinos
% Alexandros Tsingilis

% Parametric and bootstrap ci

function [output1,output2] = Group39Exe2Fun1(inputVector)
% given inputVector as input, it calculates 95% parametric ci and bootstrap
% ci for mean value
% output1 = parametric ci, output2 = bootstrap ci
alpha = 0.05;

% parametric ci for mean
[~,~,ci_param,~] = ttest(inputVector);

% bootstrap ci for mean
n = numel(inputVector);
b_samples = 1000;
B = zeros(n,b_samples); % B = nx1000
% create bootstrap samples
for i = 1:b_samples
    for j = 1:n
        p = round(unifrnd(1,n)); %uniformly distr numbers in range [1,n].
        % if NaN val picked, pick again
        while(isnan(inputVector(p,1)))
            p = round(unifrnd(1,n)); %uniformly distr numbers in range [1,n].
        end
        B(j,i) = inputVector(p,1);
    end
end

mu_B = mean(B); %1x1000
s_mu_B = sort(mu_B);

B_ci = NaN(1,2);

% Finding 0.025 and 0.975 percentiles
% k = [(B+1)a/2] , B = 1000, a=0.05
k_1 = fix(((b_samples+1) * alpha/2));
B_ci(1,1) = s_mu_B(1,k_1);
k_2 = b_samples+1-k_1;
B_ci(1,2) = s_mu_B(1,k_2);

output1 = ci_param;
output2 = B_ci;

end

