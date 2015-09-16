% select the most important image by loading an image
function [maincolors, fall] = compute_main_colors (cfg, n, blocksize)


maincolors = zeros (0, 3);
fall = [];

for imno = 1:n
  
  imorig = load_image (cfg, imno, 'ppm');
  
  im = floor (double(imorig));

  nblockx = floor (size (im, 2) / blocksize);
  nblocky = floor (size (im, 1) / blocksize);
  nblocks = nblockx * nblocky;
  maxx = blocksize * nblockx;
  maxy = blocksize * nblocky;
  imcol = zeros (nblocks, 1);
  
  
  fprintf ('Image %5d  -> %dx%d   blocks=%dx%d\n', imno, size(im, 2), size (im, 1), nblockx, nblocky);
  if nblockx < 2 || nblocky < 2
    continue;
  end
  
  
  im = im (1:maxy, 1:maxx, :);
  im = im (:, :, 1) + 256 .* im (:, :, 2) + 256^2 .* im (:, :, 3);
 
  
  % Process each block
  for bx = 0:nblockx-1
    for by = 0:nblocky-1
      block = im (by*blocksize+1:(by+1)*blocksize, bx*blocksize+1:(bx+1)*blocksize);
      block = block (:);
      
      % store the main color within the block
      [maincolor, f] = mode (block);
      fall = [fall f];

      % Consider only values occuring at least 5 times. Otherwise use the pixel in the center. 
      if f < 5
	maincolor = block (blocksize*blocksize/2);
      end
      
      imcol (bx + by * nblockx + 1) = maincolor;
    end
  end

  r = mod (imcol, 256);
  imcol = (imcol - r) / 256;
  g = mod (imcol, 256);
  imcol = (imcol - g) / 256;
  b = imcol;
  
  imcol = [r g b];
  
%  imcol = [mod(imcol, 256)  mod
  maincolors = [maincolors imcol'];
end
