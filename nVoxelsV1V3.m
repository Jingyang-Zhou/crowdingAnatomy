% surface area plot in temporal subjects

%% Predefined variables

subjNums = [1, 14, 21, 23, 24, 30, 31];
expNums  = [1, 1, 1, 1, 1, 2, 2];
dispTx   = @(s) fprintf('[nVoxelsV1V3]: %s', s);
roiList  = {'V1', 'V2', 'V3'};


%% paths and directories

if ~exist('temporalUtils'),
    temporalUtils = fullfile('/Volumes', 'server', 'Projects', 'Temporal integration', 'temporalUtils');
    addpath(genpath(temporalUtils))
end

meshLoc = fullfile('/Volumes', 'server', 'Projects', 'Anatomy');
prjtLoc = fullfile('/Volumes', 'server', 'Projects', 'v1Crowding');

%% secondary variables

nSubj   = length(subjNums);
nRoi    = length(roiList);
roi     = {};
saLeft  = nan(nSubj, nRoi);
saRight = nan(size(saLeft));
cJet    = parula(nSubj);

% create roi to be analyzed
for k = 1 : nRoi
    roi{k} = sprintf('bilateral%sEcc2to10', roiList{k});
    dispTx(sprintf('ROI to be analyzed : %s\n', roi{k}))
end

%% Compute surface area

for k = 1 : nSubj
    subjID = gotoSubject(subjNums(k), expNums(k));
    dispTx(pwd)
    
    % open gray view
    mrvCleanWorkspace;
    gray = mrVista('3');
    gray = viewSet(gray, 'current dt', 'Averages');
    
    for iRoi = 1 : nRoi
        roiFileName = sprintf('%s.mat', roi{iRoi});
        gray = loadROI(gray, roiFileName, 1, [], 0, 1);
        
        % left and right mesh directory
        meshDir{1} = fullfile(meshLoc, subjID, 'Left', '3DMeshes', 'leftUnsmoothed.mat');
        meshDir{2} = fullfile(meshLoc, subjID, 'Right', '3DMeshes', 'rightUnsmoothed.mat');
        
        for hemi = 1 : 2
            gray = meshLoad(gray, meshDir{hemi}, 0);
            % re-compute vertex
            MSH = viewGet(gray, 'Mesh');
            vertexGrayMap = mrmMapVerticesToGray( meshGet(MSH, 'initialvertices'), ...
                viewGet(gray, 'nodes'), viewGet(gray, 'mmPerVox'), viewGet(gray, 'edges') );
            MSH = meshSet(MSH, 'vertexgraymap', vertexGrayMap);
            gray = viewSet(gray, 'Mesh', MSH);
            
            clear MSH vertexGrayMap
            
            % compute surface area of the roi
            saHemi{hemi}(k, iRoi) = roiSurfaceArea(gray)
            % delete mesh
            gray = meshDelete(gray, inf);
        end
    end
    close all
end

%% sorting subjects

v1Average = (saHemi{1}(:, 1) + saHemi{2}(:, 1))./2;
[reOrderedV1, order] = sort(v1Average);

newSaHemi{1} = saHemi{1}(order, :);
newSaHemi{2} = saHemi{2}(order, :);

dispTx(sprintf('Order of the subjects : %s', mat2str(order)))

%% plotting

fh = figure, clf

% V1 surface area
subplot(1, 3, 1)
for subj = 1 : nSubj
    plot(subj, newSaHemi{1}(subj, 1), '.', 'markersize', 40, 'color', cJet(subj, :)); hold on
    plot(subj, newSaHemi{2}(subj, 1), 'o', 'markerSize', 10, 'color', cJet(subj, :), 'markerFaceColor', 'w');
end
axis tight, box off,
set(gca, 'xtick', 1 : nSubj, 'xticklabel', 1 : nSubj, 'xgrid', 'on')
xlim([0.5, nSubj + 0.5]), ylim([0, 1500])
xlabel('subject'), ylabel('Area (mm2)')
set(gca, 'ytick', 0 : 200 : 1500), title('V1')

% V2 + V3 surface area
subplot(1, 3, 2)
for subj = 1 : nSubj
    plot(subj, sum(newSaHemi{1}(subj, 2 : 3)), '.', 'markersize', 40, 'color', cJet(subj, :)), hold on
    plot(subj, sum(newSaHemi{2}(subj, 2 : 3)), 'o', 'markerSize', 10, 'color', cJet(subj, :), 'markerFaceColor', 'w');
end
axis tight, box off,
set(gca, 'xtick', 1 : nSubj, 'xticklabel', 1 : nSubj, 'xgrid', 'on')
xlim([0.5, nSubj + 0.5]), ylim([0, 1500])
xlabel('subject'), ylabel('Area (mm2)')
set(gca, 'ytick', 0 : 200 : 1500), title('V2 + V3')

% within subject surface area comparison
tmp = newSaHemi{1} + newSaHemi{2};
sa  = [tmp(:, 1), tmp(:, 2) + tmp(:, 3)];

subplot(1, 3, 3)
for k = 1 : nSubj
    plot(sa(k, :), '.:', 'color', cJet(k, :), 'markerSize', 35), hold on
    plot(sa(k, :), 'o:', 'color', cJet(k, :).*0.7, 'markerSize', 10), hold on
end
axis tight, box off, xlim([0, 3]),
set(gca, 'xtick', 1 : 2, 'xtickLabel', {'V1', 'V2+V3'}, 'xgrid', 'on')
title('Area (Left + Right) per Subject')
ylabel('Area (mm2)'), ylim([0, max(sa(:)) + 400]), 


%% save figures

imgLoc = fullfile(prjtLoc, 'figures');

saveFigures(fh, imgLoc, 'temporalSubjectV1V2V3Sizes', 'eps', [1200, 400])
