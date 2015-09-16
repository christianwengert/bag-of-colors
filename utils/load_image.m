% load images 
%
% Usage: im = load_images (cfg, imno)
% 
% Warning: imno may start from 0 depending on dataset, 
%          while matlab numbering from 1 is adopted for cells on output!
% cfg contains the config parameters and imno can be 
%    an integer vector   -> only the images considered are loaded into a cell structure
%    a single integer    -> only the image is loaded into a matrix
function im = load_image (cfg, imno, imgfmt)

% must be exactly 2 arguments
assert (nargin >= 2);

if nargin <= 2
  imgfmt = 'jpg';
end

if strcmp (cfg.name, 'holidays')
  im = load_holidays_image (cfg, imno);
  return;
end


% Load only one image
if length (imno) == 1
  if strcmp (imgfmt, 'jpg')
    imbasename = cfg.fname_jpg (imno);
  else
    imbasename = cfg.fname_ppm (imno);
  end
  im = []; 
  
  try iminfo = imfinfo (imbasename);
  catch 
    fprintf ('Unable to open file %s. Skipping.\n', imbasename);
    return;
  end
  
  % Check image format
  if iminfo.Width < 128 | iminfo.Height < 128 | iminfo.BitDepth ~= 24
    fprintf ('Image too small or with unsupporte bit depth: %s. Skipping.\n', imbasename);
    return;
  end
  im = imread (imbasename);

% Load all the images into a cell array of descriptors/meta-information
else
  nimg = length (imno);
  im = cell (nimg, 1);
  
  for i = 1:length(imno)
    imbasename = cfg.fname_jpg (imno(i));

    try iminfo = imfinfo (imbasename);
    catch exception,  continue ; end
    
    im{i} = imread (imbasename);
  end
end
