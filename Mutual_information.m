% Moratis Konstantinos
% Alexandros Tsingilis

% Mutual Information

function I = Mutual_information(x,y)
% Remove missing Values
A = rmmissing([x y],1);
x = A(:,1);
y = A(:,2);
% Computing the median of the two vectors
median_x = median(x);
median_y = median(y);
% Compute the joint probability distribution
p_XY = zeros(2,2);
p_XY(1,1) = sum(x <= median_x & y <= median_y);
p_XY(1,2) = sum(x <= median_x & y > median_y);
p_XY(2,1) = sum(x > median_x & y <= median_y);
p_XY(2,2) = sum(x > median_x & y > median_y);
% Normalize distribution
p_XY = p_XY / sum(sum(p_XY));
% Compute the marginals
p_X = sum(p_XY, 1);
p_Y = sum(p_XY, 2);
% Compute the Entropies
H_X = - sum(p_X .* log2(p_X));
H_Y = - sum(p_Y .* log2(p_Y));
H_XY = - sum(sum( p_XY .* log2(p_XY) ));
% Compute the mutual information
I = H_X + H_Y - H_XY;
end
