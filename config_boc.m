%
% This file contains the necessary path and the parameters used by the BOC signature
%

% Yael must be installed. Here we assume that the library is installed in '~/src/yael'
dir_yael = 'test/yael_v175';
addpath ([dir_yael '/matlab'], './utils');


% Number of colors in the palette
kcol = 256;

% The best colorspace is the Lab (possible options: 'rgb' or 'lab'). 
colorspace = 'lab';

% The signature options
% here use component-wise power-law normalization, +L1 normalization, +component clipping
options = [colorspace ' powerlaw L1norm L1dis clip '];
