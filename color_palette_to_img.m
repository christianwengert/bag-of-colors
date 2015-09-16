% This file load a palette and write an image of it into a file

config_boc;

mycfg = 'holidays';
if strcmp (mycfg, 'holidays')
  cfg = config_holidays;
  nimg = cfg.n;
elseif strcmp (mycfg, 'Flickr60k');
  cfg = config_flickr60k;
  nimg = 10000;
end

w = 16;

colorspace = 'lab';
%options = [colorspace ' powerlaw L1'];
%newsize = [128 128];
%bocfile = [cfg.dir_data 'boc/k' num2str(kcol) '_' colorspace '_sz' num2str(newsize(1)) '.mat'];
%fprintf ('Save results in %s\n', bocfile);


% Load palette
load ([cfg.dir_palette 'C' num2str(kcol) '_' colorspace '_rv.mat']);

C = single (C);
[dis, idx] = sort (C (1, :));
C = C(:, idx);


[R,G,B] = Lab2RGB (C(1,:),C(2,:),C(3,:));
RGB = zeros (1, kcol, 3);
RGB(1,:,:) = [R ; G ; B]';

RGB = reshape (RGB, [kcol/w w 3])

% save image corresponding to palette
RGBs = uint8 (imresize (RGB, 10, 'Method','Box'));

RGBs(10:10:end,:,:) = 255;
RGBs(:,10:10:end,:) = 255;
RGBs = RGBs(1:end-1,1:end-1,:);
% 

imwrite (RGBs, ['palette_kc' num2str(kcol) '_learned.png']);
