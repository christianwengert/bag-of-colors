% Compute the BOC associated with image I and a given palette
% 
function H = compute_color_histo (I, palette, options)

if nargin < 3
  options = 'lab';
end

kcol = size (palette, 2);

% Extracts options: color space and normalizer
if length (strfind (options, 'rgb')) > 0
  colorspace = 'rgb';
elseif length (strfind (options, 'lab')) > 0
  colorspace = 'lab';
else
  assert (~'Unknown color space');
end



% Extract the different color channels (originally: RGB)
c1 = I(:, :, 1); c1 = c1(:);
c2 = I(:, :, 2); c2 = c2(:);
c3 = I(:, :, 3); c3 = c3(:);
  
if strcmp (colorspace, 'lab') % -> need conversion
  [c1, c2, c3] = RGB2Lab (double(c1), double(c2), double(c3));
end

% compute the raw histogram
P = single ([c1' ; c2' ; c3']);
[Pc, Pcdis] = yael_nn (palette, P, 1);
H = hist (Pc, 1:kcol)';



