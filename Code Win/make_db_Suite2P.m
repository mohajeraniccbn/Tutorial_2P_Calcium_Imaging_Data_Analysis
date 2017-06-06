i = 0;

i = i+1;
db(i).mouse_name    = '162897';
db(i).date          = '2017-05-23';
db(i).expts         = [4];
db(i).nplanes       = 1;
db(i).diameter      = 20;

% i = i+1;
% db(i).mouse_name    = '160693';
% db(i).date          = '2017-04-19';
% db(i).expts         = [1];
% db(i).nplanes       = 1;
% db(i).diameter      = 10;
%

% example extra entries
% db(i).AlignToRedChannel= 1;
% db(i).BiDiPhase        = 0; % adjust the relative phase of consecutive lines
% db(i).nSVD             = 1000; % will overwrite the default, only for this dataset
% db(i).comments      = 'this was an adaptation experiment';
% db(i).expred        = [4]; % say one block which had a red channel 
% db(i).nchannels_red = 2; % how many channels did the red block have in total (assumes red is last)