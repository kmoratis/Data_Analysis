% Moratis Konstantinos
% Alexandros Tsingilis

% k-degree polynomial regression, non-linear regression

function [output1,output2] = Non_linear_reg(inputVector1,inputVector2, name)
% inputVector1 = (X), inputVector1 = (Y)
% output1 = index of model with max adj_R2:
    % 1-3 : k-degree polynomial, 4: exp, 5: power, 6: log, 7: reverse

% output2 = max adj_R2    

% create new vectors, with no NaN elements
inputArr = [inputVector1 inputVector2];
newArr = inputArr((all((~isnan(inputArr)),2)),:);

newVector1 = newArr(:,1); % independent var (X)
newVector2 = newArr(:,2); % dependent var (Y)
n = numel(newVector1);

adj_R2_mat = NaN(7,1); % number of models = 7
figure('Position', [4, 4, 1080, 720]);
clf;

% find k degree polynomial regression
kmax = 3;
for k=1:kmax
    switch k
        case 1
            xM = [ones(n,1) newVector1];
        case 2
            xM = [ones(n,1) newVector1 newVector1.^2];
        case 3
            xM = [ones(n,1) newVector1 newVector1.^2 newVector1.^3];
    end
    
    b = regress(newVector2,xM);
    est_y = xM * b;
    
    % calculate R^2 and adj_R^2
    mu_est_y = mean(est_y);
    eV = newVector2 - est_y;
    R2 = 1-(sum(eV.^2))/(sum((newVector2-mu_est_y).^2));
    adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((newVector2-mu_est_y).^2));
    adj_R2_mat(k) = adjR2;
    
    % create scatter diagram, with estimated regression line
    res = [newVector1 est_y];
    res = sortrows(res);
    subplot(4,2,k);
    scatter(newVector1, newVector2);
    hold on;
    plot(res(:,1), res(:,2), 'LineWidth', 1.2);
    s_t = "adjR^2 = " + string(adjR2); %subtitle
    t = ["Polynomial r.m. degree " + string(k), s_t];
    title(t);
end
   
% non-linear models (but intrinsically linear)

% n.l.model 1: y = a*exp(b*x)
% transform to linear
x_2 = newVector1;
xM = [ones(n,1) x_2];
y_2 = log(newVector2); % real y-vals

% calculate b with mean squares method
b = regress(y_2,xM);

est_y_2 = b(1) + b(2)*x_2;
% calculate R2, adj_R2
k = 1;
mu_est_y2 = mean(est_y_2);
eV = y_2 - est_y_2;
R2 = 1-(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adj_R2_mat(4) = adjR2;

% create scatter diagram, with estimated regression line
subplot(4,2,5);
scatter(newVector1, newVector2);
hold on;
% reverse transform to get regression line (non-linear)
r_est_y_2 = exp(est_y_2);
res = [newVector1 r_est_y_2];
res = sortrows(res);
plot(res(:,1), res(:,2), 'LineWidth', 1.2);
s_t = "adjR^2 = " + string(adjR2); %subtitle
t = ["Exp non-linear r.m" , s_t];
title(t);

% SN and GR indexes are rank deficient to within machine precision for the models 5-7 
if (name == "SN" || name == "GR")
    % add global figure title
    sgtitle("Regression models for FG, with " + name + " as independent var");
    [m,i] = max(adj_R2_mat);
    output1 = i;
    output2 = m;
    return;
end

% n.l.model 2: y = a*(x^b)
% transform to linear
x_2 = log10(newVector1);
xM = [ones(n,1) x_2];
y_2 = log10(newVector2); % real y-vals

% calculate b with mean squares method
b = regress(y_2,xM);

est_y_2 = b(1) + b(2)*x_2;
% calculate R2, adj_R2
k = 1;
mu_est_y2 = mean(est_y_2);
eV = y_2 - est_y_2;
R2 = 1-(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adj_R2_mat(5) = adjR2;

% create scatter diagram, with estimated regression line
subplot(4,2,6);
scatter(newVector1, newVector2);
hold on;
% reverse transform to get regression line (non-linear)
r_est_y_2 = 10.^est_y_2;
res = [newVector1 r_est_y_2];
res = sortrows(res);
plot(res(:,1), res(:,2), 'LineWidth', 1.2); % newVector1 already reversed (was never transf)
s_t = "adjR^2 = " + string(adjR2); %subtitle
t = ["Power non-linear r.m" , s_t];
title(t);

% n.l.model 3: y = a + b*log(x)
% transform to linear
x_2 = log10(newVector1);
xM = [ones(n,1) x_2];
y_2 = newVector2; % real y-vals

% calculate b with mean squares method
b = regress(y_2,xM);

est_y_2 = b(1) + b(2)*x_2;
% calculate R2, adj_R2
k = 1;
mu_est_y2 = mean(est_y_2);
eV = y_2 - est_y_2;
R2 = 1-(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adj_R2_mat(6) = adjR2;

% create scatter diagram, with estimated regression line
subplot(4,2,7);
scatter(newVector1, newVector2);
hold on;
% reverse transform to get regression line (non-linear)
r_est_y_2 = est_y_2;
res = [newVector1 r_est_y_2];
res = sortrows(res);
plot(res(:,1), res(:,2), 'LineWidth', 1.2); % newVector1 already reversed (was never transf)
s_t = "adjR^2 = " + string(adjR2); %subtitle
t = ["y = a+b*log(x) non-linear r.m" , s_t];
title(t);

% n.l.model 4: y = α + β*(1/x)
% transform to linear
x_2 = 1./newVector1;
xM = [ones(n,1) x_2];
y_2 = newVector2; % real y-vals

% calculate b with mean squares method
b = regress(y_2,xM);

est_y_2 = b(1) + b(2)*x_2;
% calculate R2, adj_R2
k = 1;
mu_est_y2 = mean(est_y_2);
eV = y_2 - est_y_2;
R2 = 1-(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((y_2-mu_est_y2).^2));
adj_R2_mat(7) = adjR2;

% create scatter diagram, with estimated regression line
subplot(4,2,8);
scatter(newVector1, newVector2);
hold on;
% reverse transform to get regression line (non-linear)
r_est_y_2 = est_y_2;
res = [newVector1 r_est_y_2];
res = sortrows(res);
plot(res(:,1), res(:,2), 'LineWidth', 1.2); % newVector1 already reversed (was never transf)
s_t = "adjR^2 = " + string(adjR2); %subtitle
t = ["Reverse non-linear r.m" , s_t];
title(t);

% add global figure title
sgtitle("Regression models for FG, with " + name + " as independent var");

% find model with max adj_R2
[m,i] = max(adj_R2_mat);

output1 = i;
output2 = m;
end
