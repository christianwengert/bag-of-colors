% This function computes the mAP for a given set of returned results.
%
% Usage: map = compute_results (idx, gnd);
%
% Notes:
% 1) ranks starts from 1
% 2) The top result (the query itself) should be filtered externally
function [map, tpranks] = compute_results(idx, gnd, verbose)

if nargin < 3
  verbose = false;
end

map = 0;
nq = size (gnd, 1);   % number of queries

tpranks = zeros (1, max (idx(:)));

for i = 1:nq
  qgnd = gnd{i}(2:end);
  nres = length (qgnd); % number of groundtruth results
  tp = [];
  
  % Remove the query from the set of results
  ids = idx (:, i);
  idskeep = find (ids ~= gnd{i}(1));
  ids = ids (idskeep);

  for j = 2:length(gnd{i})
    
    pos = find (gnd{i}(j) == ids);
    if ~isempty(pos)
      tp = [tp pos];
    end
  end
  tp = sort (tp);
  ap = score_ap_from_ranks1 (tp, nres);

  tpranks (tp) = tpranks (tp) + 1;
  
  if verbose
    fprintf ('query no %d -> gnd = ', i);
    fprintf ('%d ', qgnd);
    fprintf ('\n              tp ranks = ');
    fprintf ('%d ', tp);
    fprintf (' -> ap=%.3f\n', ap);
  end
  map = map + ap;
end
map = map / nq;

