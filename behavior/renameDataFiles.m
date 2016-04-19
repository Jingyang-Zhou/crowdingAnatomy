% rename data files
function [] = renameDataFiles(subjName, expDat)

%% modify subject name and experiment date

% Example:
% subjName = '--';
% date     = '20160417';

%% find data location

prjDir = fullfile('~', 'matlab', 'git', 'CriticalSpacing');
datDir = fullfile(prjDir, 'data');
cd(datDir)

%% load data names

txtStr = sprintf('*%s*', subjName);
matStr = sprintf('%s.mat', txtStr);
txtStr = sprintf('%s.txt', txtStr);
f      = dir(matStr);
tx     = dir(txtStr);

for k = 1 : length(f)
    file{k} = f(k).name;
    txt{k}  = tx(k).name;
end

%% new names

side = {'right', 'right', 'left', 'left', 'left', 'right', 'center'};
ecc  = [8, 4, 8, 4, 8, 8, 0];
d    = {'tangential', 'radial', 'tangential', 'radial', 'radial', 'radial', 'radial'};

for k = 1 : length(files)
    newFileName = sprintf('%s%s%d%s%s.mat', subjName, side{k}, ecc(k), d{k}, date);
    newTextName = sprintf('%s%s%d%s%s.txt', subjName, side{k}, ecc(k), d{k}, date);
    movefile(file{k}, newFileName)
    movefile(txt{k}, newTextName)
end

%% go back to the project directory

cd(prjDir)

end

