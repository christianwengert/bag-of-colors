% Return a config object that contains all the paths for the Holidays dataset

function cfg = config_flickr60k (params)

dir_data = './flickr60k/';

if nargin == 1
  if isfield (params,{'dir_data'})
    dir_data = params.dir_data;
  end
end
  

% (approximate) number of pixels of the re-sized images
cfg.ppmsize=65536;  

cfg.name = 'Flickr60k';
cfg.dir_data = dir_data;
cfg.dir_jpg = [cfg.dir_data 'jpg/'];
cfg.dir_ppm = [cfg.dir_data 'ppmsmall/'];


% The main colors pre-extracted on the first 10000 images of flickr60k
cfg.fname_maincolors = [cfg.dir_data 'maincolors.mat']; 

% palette learned
cfg.dir_palette = [cfg.dir_data 'color_palette/']; 

cfg.fname_palette = inline(['sprintf(''' cfg.dir_palette '/C%d_%s.mat'', k, palette)'],'k', 'palette');

cfg.fname_jpg = inline(['sprintf(''' cfg.dir_jpg '/%d.jpg'', n)']);
cfg.fname_ppm = inline(['sprintf(''' cfg.dir_ppm '/%d.ppm'', n)']);
