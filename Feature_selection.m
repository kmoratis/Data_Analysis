% Moratis Konstantinos
% Alexandros Tsingilis

% Exercise 9

clear;
clc;
close all;

% Example data
data = readtable('Heathrow.xlsx');

% Define significance level
alpha = 0.05;

% Define predictors and response variables
predictors = {'T', 'TM', 'Tm', 'PP', 'V', 'RA', 'SN', 'TS'};
response_fg = 'FG';
response_gr = 'GR';

% Subset data for years with complete observations
idx_fg = all(~isnan(data{:, [predictors, response_fg]}), 2);
data_fg = data(idx_fg, [predictors, response_fg]);

idx_gr = all(~isnan(data{:, [predictors, response_gr]}), 2);
data_gr = data(idx_gr, [predictors, response_gr]);

% Fit multiple linear regression models
mdl_fg = fitlm(data_fg{:, predictors}, data_fg.(response_fg));
mdl_gr = fitlm(data_gr{:, predictors}, data_gr.(response_gr));

% Print model summary
disp('Results for FG:')
disp(mdl_fg)
disp('Results for GR:')
disp(mdl_gr)

% Check which coefficients are statistically significant
pvals_fg = mdl_fg.Coefficients.pValue(2:end);
significant_fg = pvals_fg < alpha;

pvals_gr = mdl_gr.Coefficients.pValue(2:end);
significant_gr = pvals_gr < alpha;

disp(['Significant predictors for FG: ' strjoin(predictors(significant_fg), ', ')])
disp(['Significant predictors for GR: ' strjoin(predictors(significant_gr), ', ')])

% Fit stepwise regression models
mdl_stepwise_fg = stepwiselm(data_fg{:, predictors}, data_fg.(response_fg));
mdl_stepwise_gr = stepwiselm(data_gr{:, predictors}, data_gr.(response_gr));

% Print model summary
disp('Results for FG (stepwise):')
disp(mdl_stepwise_fg)
disp('Results for GR (stepwise):')
disp(mdl_stepwise_gr)

% Fit PCA regression models
[coeff_fg, score_fg, ~, ~, explained_fg] = pca(data_fg{:, predictors});
n_components_fg = find(cumsum(explained_fg) >= 90, 1); % keep 90% of variance
mdl_pca_fg = fitlm(score_fg(:, 1:n_components_fg), data_fg.(response_fg));

[coeff_gr, score_gr, ~, ~, explained_gr] = pca(data_gr{:, predictors});
n_components_gr = find(cumsum(explained_gr) >= 90, 1); % keep 90% of variance
mdl_pca_gr = fitlm(score_gr(:, 1:n_components_gr), data_gr.(response_gr));

% Print model summary
disp('Results for FG (PCA):')
disp(mdl_pca_fg)
disp('Results for GR (PCA):')
disp(mdl_pca_gr)
