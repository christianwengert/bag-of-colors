% H. Jegou 15/07/2008
%
% Generate a random orthogonal basis (in rows)
%
% Parameters: d, the size of the matrix
function P = rand_ortho_proj (d)
  
P = single (randn (d, d)); 

for i = 1:d
  P (:, i) = P (:, i) ./ norm (P (:, i), 2);  % Normalisation is not strictly
                                              % required here (I am just
                                              % paranoid on numeric stability)
end

[Q, R] = qr (P);
P = Q';
