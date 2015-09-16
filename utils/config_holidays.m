% Return a config object that contains all the paths for the Holidays dataset
% as well as the groundtruth

function cfg = config_holidays (params)

dir_data = './holidays/';

if nargin == 1
  if isfield (params,{'dir_data'})
    dir_data = params.dir_data;
  end
end

cfg.name = 'holidays';

cfg.ppmsize=16384;
cfg.dir_data = [dir_data '/'];
cfg.gnd_file = [cfg.dir_data 'gnd.mat'];
cfg.dir_ppm = [cfg.dir_data num2str(cfg.ppmsize) 'pix/'];

% palette learned on distinct set
cfgflickr = config_flickr60k;
cfg.fname_palette = cfgflickr.fname_palette;


% Retrieve the list of images number 
load (cfg.gnd_file, 'imlist');

% Retrieve the set of group of matching images (first image number is the query)
load (cfg.gnd_file, 'gnd');

% the query number (redundant with gnd, as gnd{i}(1)=qidx(i)
load (cfg.gnd_file, 'qidx');

cfg.imlist = imlist;
cfg.gnd = gnd;
cfg.qidx = qidx;
cfg.n = length (cfg.imlist);
cfg.nq = length (cfg.qidx);
