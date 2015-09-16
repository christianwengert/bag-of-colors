% compute score for the BOC approach

config_boc;
options

mycfg = 'holidays';

if strcmp (mycfg, 'holidays')
  cfg = config_holidays;
  nimg = cfg.n;
else
  error ('Unknow database');
end

knn = 500;

% Comparison metric
seldis = 1;
if length (strfind (options, 'L1dis')) > 0
  seldis = 1;
elseif length (strfind (options, 'L2dis')) > 0
  seldis = 2;
end


bocfile = [cfg.dir_data 'boc/k' num2str(kcol) '_' colorspace '_sz' num2str(cfg.ppmsize) '.mat'];

% Load the signatures from disk
load (bocfile, 'Hall');

% Compute BOC from histogram. We could use directly Xall instead, but here we save 
% some time when testing different options in config_boc.m
X = single(boc_from_histo (Hall, options) );

% 
[idx, dis] = yael_nn (X, X(:,cfg.qidx), knn, seldis);


[map, tpranks1] = compute_results (idx, cfg.gnd, false);
fprintf ('kcol=%4d   mAP=%.4f  clip=%d  idf=%d\n', kcol, map, ...
	 length(strfind(options,'clip'))>0, ...
	 length(strfind(options,'idf'))>0);

