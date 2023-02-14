% Moratis Konstantinos
% Alexandros Tsingilis

% Simple linear regression model, R^2

function [output1] = Group39Exe6Fun1(inputVector1,inputVector2, fig_name, ind_name)

% ouput1 = R_squared 

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
    
    x_mat = [ones(n,1) newVector1];
    y_val = newVector2;
    [b,bint,r,rint,~] = regress(y_val,x_mat);

    est_y = b(1) + b(2) * newVector1;
    mu_est_y = mean(est_y);
    mu_est_y_vec = ones(n,1) * mu_est_y;
    % calculate R_s
    R_s = 1 - sum( (newVector2 - est_y ).^2 ) / sum( (newVector2 - mu_est_y_vec).^2 );

    % create scatter plot as part of plot matrix for each dependend variable(Y)
    figure(fig_name);
    nexttile;

    scatter(newVector1,newVector2);
    hold on;
    plot(newVector1, est_y);
    s_t = "R^2 = " + string(R_s); %subtitle
    t = ["Independent varialbe " + ind_name, s_t];
    title(t);
    
    output1 = R_s;
end

