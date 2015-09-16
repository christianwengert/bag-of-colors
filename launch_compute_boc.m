% This file compute the BOC signatures for the images of a given dataset

% Load parameters
config_boc;
mycfg = 'holidays';

% To compute the BOC on the Flickr60k dataset, use the following line instead
% mycfg = 'flickr60k';

if strcmp (mycfg, 'holidays')
  cfg = config_holidays;
  nimg = cfg.n;
elseif strcmp (mycfg, 'flickr60k');
  cfg = config_flickr60k;
  nimg = 10000;  % Limit to 10000 images
end

% The matlab data file that will contain the BOC signature for the whole dataset
bocfile = [cfg.dir_data 'boc/k' num2str(kcol) '_' colorspace '_sz' num2str(cfg.ppmsize) '.mat'];
fprintf ('Save BOC descriptors in %s\n', bocfile);


% Load the palette (must be already computed)
load (cfg.fname_palette (kcol, colorspace), 'C');
C = single (C);


% Compute the BOC
% Timings 'tall' does not include the cost of loading an image
tall = 0;  
Hall = [];  % The set of raw color histogram (before normalization)

for imno = 1:nimg
  fprintf ('\rImage %d / %d', imno, nimg);
  I = load_image (cfg, imno, 'ppm');
  
  if length (size (I)) < 3, continue; end
  
  t0 = cputime();
  H = compute_color_histo (I, C, options);
  tall = tall + cputime() - t0;
  
  Hall = [Hall H];
end

% Post-normalization according to given options (see config_boc.m)
t0 = cputime()
Xall = boc_from_histo (Hall, options);
tall = tall + cputime() - t0;


fprintf ('\nkcol=%d,  Extraction time per image=%.5fs\n', kcol, tall / nimg);
save (bocfile, 'Xall', 'Hall', 'C');
