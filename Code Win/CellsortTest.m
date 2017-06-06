%% Cellsort Artificial Data Test

% Eran Mukamel
% December 1, 2009
% eran@post.harvard.edu
    
% fn = 'ArtificialData_SNR_0.1_FOV_250.tif';
fn = fileName;
%% 1. PCA
tic
nPCs = 100;
flims = [];
figure(1);clf
[mixedsig, mixedfilters, CovEvals, covtrace, movm, movtm] = ...
    CellsortPCA(fn, flims, nPCs, [], [], []);
toc
%% 2a. Choose PCs
figure(2);clf;
tic
[PCuse] = CellsortChoosePCs(fn, mixedfilters);
toc
%% 2b. Plot PC spectrum

figure(3);clf
CellsortPlotPCspectrum(fn, CovEvals, PCuse)

%% 3a. ICA
tic
nIC = length(PCuse);
mu = 0.5;

[ica_sig, ica_filters, ica_A, numiter] = CellsortICA(mixedsig, mixedfilters, CovEvals, PCuse, mu, nIC);
toc
%% 3b. Plot ICs
tic
tlims = [];
dt = 0.1;

figure(2)
CellsortICAplot('series', ica_filters, ica_sig, movm, tlims, dt, [], [], PCuse);
toc
%% 4a. Segment contiguous regions within ICs
tic
smwidth = 2;
thresh = 2;
arealims = [30 90];
plotting = 1;
figure(200);
[ica_segments, segmentlabel, segcentroid] = CellsortSegmentation(ica_filters, smwidth, thresh, arealims, plotting);
toc
%% 4b. CellsortApplyFilter 
tic
subtractmean = 1;

cell_sig = CellsortApplyFilter(fn, ica_segments, flims, movm, subtractmean);
toc
%% 5. CellsortFindspikes 

deconvtau = 0;
spike_thresh = 2;
normalization = 1;

[spmat, spt, spc] = CellsortFindspikes(ica_sig, spike_thresh, dt, deconvtau, normalization);

%% Show results

figure(2)
CellsortICAplot('series', ica_filters, ica_sig, movm, tlims, dt, 1, 2, PCuse, spt, spc);
