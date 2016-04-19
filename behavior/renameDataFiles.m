% re-name all the data files in the data folder

subjList = {'JB', 'JYZ', 'NC', 'HY'};
subjNum  = [23, 14, 10, 36];
nSubj    = length(subjList);
subjID   = {};

% create subject ID:
for k = 1 : nSubj
    subjID{k} = sprintf('wl_subj0%d', subjNum(k));
end

%% paths

prjDir  = fullfile('/Volumes', 'server', 'Projects', 'crowdingAnatomy');
datDir  = fullfile(prjDir, 'data', 'raw');
current = pwd;

cd(datDir)

%% create data file name

for iSub = 1 : nSubj
    nameStr = sprintf('*%s*', subjList{iSub});
    matStr  = sprintf('%s.mat', nameStr);
    txtStr  = sprintf('%s.txt', nameStr);
    
    f       = dir(matStr);
    tx      = dir(txtStr);
    
    % load each file and check its side, exx, and direction
    for k = 1 : length(f)
        file{k} = f(k).name;
        txt{k}  = tx(k).name;
        
        clear oo dat ecc fixLoc radTang
        a       = load(file{k});
        dat     = a.oo;
        ecc     = dat(1).eccentricityDeg;
        fixLoc  = dat(1).fixationLocation;
        radTang = dat(1).radialOrTangential;
        
        if strcmp(fixLoc, 'left'),
            side = 'right';
        elseif strcmp(fixLoc, 'right'),
            side = 'left';
        elseif strcmp(fixLoc, 'center')
            side = fixLoc;
        else
            error('Unidentifiable fix Loc');
        end
        
        % create new name
        newName     = sprintf('%s%s%d%s', subjID{iSub}, side, ecc, radTang);
        newMatName  = sprintf('%s.mat', newName);
        newTextName = sprintf('%s.txt', newName);
        
        % rename the current file
        movefile(file{k}, newMatName);
        movefile(txt{k},  newTextName);
       
    end
end

%% go back to original directory

cd(current)