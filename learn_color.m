% This script learns a palette color from natural images

% Learn config parameter (in particular the number kcol of colors in the palette)
config_boc;

% Use an independant dataset for this learning stage
cfg = config_flickr60k;


% REMARK: the main colors have been already extracted, because this stage is a bit costly
% They have been generated using the following matlab 
if 0
  n = 10000;            % number of images used to learn the palette
  blocksize = 16;       % block size (see paper)
  [maincolors, fall] = compute_main_colors (cfg, n, blocksize);
  save (cfg.fname_maincolors, 'maincolors');
% Instead, load the pre-computed main colors
else
  load (cfg.fname_maincolors, 'maincolors');
end
  

%convert color space if necessary
if strcmp (colorspace, 'lab')
  [l,a,b] = RGB2Lab(maincolors(1,:),maincolors(2,:),maincolors(3,:)); 
  maincolors = [l ; a ; b];
end
  
%learn vocabulary
C = yael_kmeans (single (maincolors), kcol, 'redo', 3, 'niter', 50);

% Save the palette
save (cfg.fname_palette(kcol, colorspace), 'C');
