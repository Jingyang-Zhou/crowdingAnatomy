% compute pair-wise correlation between all ROIs
function [] = compue_roiCorr()

% function [] = compue_roiCorr()


%% paths and directories

prjtLoc = fullfile('/Volumes', 'server', 'Projects', 'crowdingAnatomy');
imgLoc  = fullfile(prjtLoc, 'figures');
util    = fullfile('/Volumes', 'server', 'Projects', 'Temporal integration', 'temporalUtils');

addpath(genpath(util))

%% load data

a       = load(fullfile(prjtLoc, 'data', 'surfaceSizeVista.mat'));
sfSize  = a.saHemi{1} + a.saHemi{2};
subList = a.subjNums;
roiList = a.roiList;

szLeft  = a.saHemi{1};
szRight = a.saHemi{2};

%% secondary variables

nSub = length(subList);
nRoi = length(roiList);

%% compute correlations within each subject

% combined hemisphere

sizeCor = [];
lCor    = [];
rCor    = [];

for iRoi1 = 1 :  nRoi
    for iRoi2 = 1 : nRoi
        sizeCor(iRoi1, iRoi2) = corr(sfSize(:, iRoi1), sfSize(:, iRoi2));
        lCor(iRoi1, iRoi2)    = corr(szLeft(:, iRoi1), szLeft(:, iRoi2));
        rCor(iRoi1, iRoi2)    = corr(szRight(:, iRoi1), szRight(:, iRoi2));
    end
end

% compute for subplot 2
sizeCor = round(sizeCor, 4);
unSize  = unique(sizeCor(:));

%% plottings
fg = figure; clf, colormap parula

subplot(2, 2, 1)
imagesc(sizeCor), figureProperty
title('Correlation between ROI sizes')

subplot(2, 2, 2)
plot(unSize, '.', 'markerSize', 30), box off
title('distribution of correlations'), axis tight, 
ylim([-1, 1]), xlim([0, length(unSize) + 2]), grid on
set(gca, 'xtick', '')
ylabel('corr')
text(1.3, -0.78, 'V3 vs TO')
text(21.3, 0.8, 'V1 vs V2')

subplot(2, 2, 3)
imagesc(lCor), figureProperty, 
title('Left hemisphere')

subplot(2, 2, 4)
imagesc(rCor), figureProperty
title('Right hemisphere')

%% save figure

saveFigures(fg, imgLoc, 'correlationAllROIs', 'eps', [800, 650])

%% sub-functions

    function [] = figureProperty()
        set(gca, 'xtick', 1 : nRoi, 'xticklabel', roiList)
        set(gca, 'ytick', 1 : nRoi, 'yticklabel', roiList)
        caxis([-1, 1]), colorbar
    end
%%
end