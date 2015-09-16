% This function compute the BOC from the histogram
% The different normalization/processing are performed according to the 'options' parameters

function X = boc_from_histo (H, options)

%--- Detect selected options ---

% Powerlaw component-wise normalization
powerlaw = length (strfind (options, 'powerlaw')) > 0;

% Inverse document frequency
idf = length (strfind (options, 'idf')) > 0;

% Post-normalization
if length (strfind (options, 'L1norm')) > 0
  selnorm = 1;
elseif length (strfind (options, 'L2norm')) > 0
  selnorm = 2;
else selnorm = 0;
end

% If option 'clip' is activated, clip the largest values and re-normalize
if length (strfind (options, 'clip')) > 0
  clip = true;
else clip = false;
end

% idf weights
if length (strfind (options, 'idf')) > 0
  idf = true;
else idf = false;
end

% PCA
if length (strfind (options, 'pca')) > 0
  pca = true;
else pca = false;
end



%--- Process normalization stage
X = single (H);

if powerlaw 
  X = X .^ 0.5;
end

% Normalization of the histogram (possibly none)
if selnorm > 0
  X = single(yael_fvecs_normalize (X, selnorm));
end

% If option 'clip' is activated, clip the largest values and re-normalize
if clip
  kcol = size (X, 1);
  thres = 1 / sqrt (kcol);
  postoobig = find (X > thres);
  X(postoobig) = thres;
  
  % Re-normalization is required
  X = yael_fvecs_normalize (X, selnorm);
end

% idf normalization
if idf
  nocccol = sum (X > 0, 2);
  idfw =  log(size(X,2) ./ nocccol);

  infpos = find (isfinite(idfw) == 0);
  idfw(infpos) = 0;
  
  infpos = find (isnan (idfw) == 1);
  idfw(infpos) = 0;

  X = X .* repmat (idfw, 1, size(X,2));
  X = yael_fvecs_normalize (single(X), selnorm);
end


% Final PCA (half the components are kept)
if pca
  X = double (X);
  
  dout = size (X, 1) / 2;
  Xm = mean (X, 2);
  X = X - repmat (Xm, 1, size (X,2));
  Xcov = X * X';
  Xcov = (Xcov + Xcov') / 2;
  
  [eigvec, eigval] = eigs (Xcov, dout, 'LM');
  X = eigvec' * X;
 
  X = single (X);
end