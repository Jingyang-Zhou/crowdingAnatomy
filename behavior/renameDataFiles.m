
function [] = renameDataFiles()


%% paths

[prjDir, datDir, codeDir] = crowdingAnatPth;

current = pwd;
cd(datDir)

%% re-name all the data files in the data folder

[subjID, subjInit] = subjectList;
nSubj              = length(subjID);

%% create data file name

for iSub = 1 : nSubj
    nameStr = sprintf('*%s*', subjInit{iSub});
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

%%
end