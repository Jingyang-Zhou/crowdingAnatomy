function [sbjOrder, size, cmag] = loadSizeCmag()

% compare v1 size and size of cortical magnification

prjDir  = fullfile('/Volumes', 'server', 'Projects', 'crowdingAnatomy');
codeDir = fullfile(prjDir, 'code');
datDir  = fullfile(prjDir, 'data');
current = pwd;

cd(prjDir)
addpath(genpath(codeDir))

%% get data labels

sbjOrder  = getLabels('size', 'subjects');
sizeLabel = getLabels('size', 'data');
cmagLabel = getLabels('cmag', 'data');

%% get relevant entries

% size --------------------------------------------------------------------
% sizes: mid-gray Hinds length, width, template-12, template-8
size.soi  = cell(1, 10);
size.sidx = nan(1, length(size.soi));
svar  = {'hinds', 'template_12', 'template_8', 'hinds_length', 'hinds_width'};

% cmag --------------------------------------------------------------------
% cmag : 'midgray', 'mean4', 'radial4', 'radial 8', 'tangential 8' 'mean8'
cmag.coi  = cell(1, 10);
cmag.cidx = nan(1, length(cmag.coi));
cvar = {'mean_4', 'radial_4', 'radial_8', 'tangential_8', 'mean_8'};

for k = 1 : length(size.soi)
    if k < length(size.soi)/2 + 1
        side  = 'LH';
        count = k;
    else
        side  = 'RH';
        count = k - round(length(size.soi)/2);
    end
    size.soi{k}  = sprintf('%s_midgray_%s', side, svar{count});
    size.sidx(k) = find(ismember(sizeLabel, size.soi{k}));
    
    cmag.coi{k}  = sprintf('%s_midgray_%s', side, cvar{count});
    cmag.cidx(k) = find(ismember(cmagLabel, cmag.coi{k}));
end

%% load size file

a       = csvread(fullfile(datDir, 'V1_sizes.csv'), 1, 1);
size.dat = a(:, size.sidx);

b       = csvread(fullfile(datDir, 'V1_cmags.csv'), 1, 1);
cmag.dat = b(:, cmag.cidx);

%%
cd(current)
end




