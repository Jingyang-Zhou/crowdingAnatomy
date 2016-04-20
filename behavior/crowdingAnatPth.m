function [prjDir, datDir, codeDir] = crowdingAnatPth()

% function [prjDir, datDir, codeDir] = crowdingAnatPth()

%%

prjDir  = fullfile('/Volumes', 'server', 'Projects', 'crowdingAnatomy');
datDir  = fullfile(prjDir, 'data', 'raw');
codeDir = fullfile(prjDir, 'code');

addpath(genpath(codeDir))

%% load CriticalSpacing path

cpPth = fullfile('~', 'matlab', 'git', 'CriticalSpacing');
assert(exist(cpPth)== 7, 'CriticalSpacing path does not exist, may need to install CritialSpacing.');

addpath(genpath(cpPth))

%% load psychtoolbox path

psychTb = fullfile('/Applications', 'Psychtoolbox');
assert(exist(psychTb) == 7, 'Cannot find psychtoolbox path, may need to install psychtoolbox.');

addpath(genpath(psychTb))

end