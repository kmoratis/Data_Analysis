% Moratis Konstantinos
% Alexandros Tsingilis

% X square test and Data visualization (histogram, bar graph) 

function [output1, output2, output3] = X_square_test(inputVector, name)
% output 3 == 1 if continuous index, else 0
% output 1 == p from test for normal (if cont) || p from test from binomial (if discr)
% output 2 == p from test for uniform (if cont) || p from test from discrete uniform (if discr)
    

    % returns the unique values of the vector
    u_vector = unique(inputVector);
    % returns the number of elements of u_vector
    n_unique = numel(u_vector);
    n = numel(inputVector);
    
    if n_unique > 10
        % X^2 test for normal distribution
        [h_norm,p_norm,~] = chi2gof(inputVector);
        
        % X^2 test for uniform distribution
        pd = makedist('uniform');
        [h_uni,p_uni] = kstest(inputVector,'CDF',pd);
        
        % create histogram 
        figure;
        histogram(inputVector);
        title(["Histogram for " + name + " data", "Normal p-val = " + num2str(p_norm) + ", Uniform p-val = " + num2str(p_uni) ]);
        
        output1 = p_norm;
        output2 = p_uni;
        output3 = 1;
    
    else
        
        % X^2 test for discrete uniform distribution
        low = min(inputVector);
        high = max(inputVector);
        p = 1/(high-low+1);
        [h_unid,p_unid,~] = chi2gof(inputVector,'CDF',{@(x) p*(x>=low & x<=high)});
        
        % X^2 test for binomial distribution
        
        % using the mle function to estimate the most-likelihood prob of
        % success based on the data (p)
        prob_vals = [0.1 0.25 0.5 0.75 0.9];
        for i = 1:numel(prob_vals);
            pd_2 = makedist('binomial','N',n_unique,'p',prob_vals(i));

            [h_binom,p_binom,~] = chi2gof(inputVector,'CDF', pd_2);
            if(h_binom == 0)
                break;
            end
        end
        
        % create bar graph 
        figure;
        bar(inputVector);
       
        title(["Bar graph for " + name + " data", "Discrete uni p-val = " + num2str(p_unid) + ", Binomial p-val = " + num2str(p_binom) ]);
        output1 = p_binom;
        output2 = p_unid;
        output3 = 0;
        %{
        if i wanted to display inside the graph area
        dim1 = [.15 .5 .3 .3];
        str1 = ["Discrete uni p-val = ", num2str(p_unid)];
        dim2 = [.15 .4 .3 .3];
        str2 = ["Binomial p-val = ", num2str(p_binom)];
        annotation('textbox',dim1,'String',str1, 'FitBoxToText','on');
        annotation('textbox',dim2,'String',str2, 'FitBoxToText','on');
        %}
    end
end

