% load images from the holidays dataset
% 
% Usage: im = load_holidays_images (cfg, imno)
% 
% where cfg contains the config parameters and imno can be 
%    void or not defined -> all images are loaded into cells of vectors
%    an integer vector   -> only the images considered are loaded into a cell structure
%    a single integer    -> only the image is loaded into a matrix
function im = load_holidays_image (cfg, imno)


% no arugment means all the images
if nargin < 2  
  imno = 1:length (cfg.imlist);
end

% Load only one image
if length (imno) == 1
  im = imread ([cfg.dir_ppm cfg.imlist{imno} '.ppm']);

% Load all the images into a cell array of descriptors/meta-information
else
  nimg = length (imno);
  im = cell (nimg, 1);
  
  for i = 1:length(imno)
    im{i} = imread ([cfg.dir_ppm cfg.imlist{imno(i)} '.ppm']);
  end
end