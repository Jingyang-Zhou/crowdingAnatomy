function [] = analyzeCorticalBehavior(whichSizePlot)

%% INPUTS:

% whichSizePlot : "radial4dg", "radial8dg", "tangential8dg"

exampleOn = 1;
if exampleOn
    whichSizePlot = 'tangential8dg';
end

%% paths
rootPth = v1CrowdingRootPath;
addpath(genpath(rootPth))

%% load data

[bID, datSmry]       = analyzeCAIndividual_wrapper;
[sbjOrder, sz, cmag] = loadSizeCmag;

%% sort data

% rename subject ID from behavioral data
for k = 1 : length(sbjOrder)
    cID{k} = createSubjID(sbjOrder(k));
end
% sort cortical data (CHECK IF LENGTH OF cID IS GREATER THAN THAT OF
% subjID)
for k = 1 : length(bID) - 1
    idx(k) = find(ismember(cID, bID{k}));
end

%% Extract behavioral data

%% analyze 4 degree

bdat4rd   = {};
bdat4rdsd = {};

for k = 1 : length(idx)
    bdat4rd{1}(k, :)   = datSmry{k}.leftRadial4;
    bdat4rd{2}(k, :)   = datSmry{k}.rightRadial4;
    
    bdat4rdsd{1}(k, :) = std(datSmry{k}.leftRadial4);
    bdat4rdsd{2}(k, :) = std(datSmry{k}.rightRadial4);
end

%% analyze 8 degree

bdat8rd   = {};
bdat8tg   = {};

bdat8rdsd = {};
bdat8tgsd = {};

for k = 1 : length(idx)
    bdat8rd{1}(k, :)   = datSmry{k}.leftRadial8;
    bdat8rd{2}(k, :)   = datSmry{k}.rightRadial8;
    bdat8tg{1}(k, :)   = datSmry{k}.leftTangential8;
    bdat8tg{2}(k, :)   = datSmry{k}.rightTangential8;
    
    bdat8rdsd{1}(k, :) = std(datSmry{k}.leftRadial8);
    bdat8rdsd{2}(k, :) = std(datSmry{k}.rightRadial8);
    bdat8tgsd{1}(k, :) = std(datSmry{k}.leftTangential8);
    bdat8tgsd{2}(k, :) = std(datSmry{k}.rightTangential8);
end

%% plot size and performance

switch lower(whichSizePlot)
    case 'radial4dg'
        toPlot = bdat4rd;
    case 'radial8dg'
        toPlot = bdat8rd;
    case 'tangential8dg'
        toPlot = bdat8tg;
end
% re-order size data
sizeDat    = sz.dat(idx, :);
nSizeTypes = 5;

% Plotting ----------------------------------------------------------------
figure (2), clf
for k = 1 : nSizeTypes
    
    sz_pl = [sizeDat(:, k); sizeDat(:, k+5)];
    b_pl  = [mean(toPlot{2}, 2); mean(toPlot{1}, 2)];
    sd_pl = [bdat8tgsd{2}; bdat8tgsd{1}];
    
    subplot(3, 2, k)
    sc = plot(sz_pl, b_pl, 'o', 'markersize', 12, 'markerEdgeColor', 'k',...
        'markerfacecolor', 'r', 'linewidth', 2);
    hold on
    % plot standard error
    for k1 = 1 : length(b_pl)
        l = line([sz_pl(k1), sz_pl(k1)], [b_pl(k1) - sd_pl(k1), b_pl(k1) + sd_pl(k1)]);
        l.Color = 'k';
    end
    box off, grid on, ylabel('threshold')
    if k < 4, xlabel('size (mm2)')
    else, xlabel('length(mm)')
    end
    % title
    txt = strrep(sz.soi{k}(4:end), '_', '-');
    title(txt)
end

%% analyze cmag and performance

cmagDat = cmag.dat(idx, :);

figure (3), clf

b8rd_pl    = [mean(bdat8rd{2}, 2); mean(bdat8rd{1}, 2)];
b4rd_pl    = [mean(bdat4rd{2}, 2); mean(bdat4rd{1}, 2)];
b8tg_pl    = [mean(bdat8tg{2}, 2); mean(bdat8tg{1}, 2)];

[cmag4m_pl, cmag4rd_pl, cmag8rd_pl, cmag8tg_pl, cmag8m_pl] = getCMagDat(cmagDat);

subplot(3, 2, 1)
p1 = plot(cmag8rd_pl, b8rd_pl, 'o');
plotRoutine(p1, '8 degree radial')

subplot(3, 2, 2)
p2 = plot(cmag8tg_pl, b8tg_pl, 'o');
plotRoutine(p2, '8 degree tangential');

subplot(3, 2, 3)
p3 = plot(cmag4rd_pl, b4rd_pl, 'o'),
plotRoutine(p3, '4 degree radial');

subplot(3, 2, 4)
p4 = plot(cmag4m_pl, b4rd_pl, 'o');
plotRoutine(p4, '4 degree mean/radial');

subplot(3, 2, 5)
p5 = plot(cmag8m_pl, b8rd_pl, 'o');
plotRoutine(p5, '8 degree mean/radial');


%% sub-function

    function [] = plotRoutine(pi, titleTxt)
        pi.MarkerEdgeColor = 'k';
        pi.MarkerFaceColor = 'c';
        xlabel('cortical mag. (mm/dg.)')
        ylabel('threshold')
        grid on, box off
        title(titleTxt)
    end

%% sub-function (extract cortical magnification and behavioral data)

    function [cmag4m_pl, cmag4rd_pl, cmag8rd_pl, cmag8tg_pl, cmag8m_pl] = getCMagDat(cmagDat)
        
        getCMag = @(k)[cmagDat(:, k); cmagDat(:, k + 5)];
        
        cmag4m_pl  = getCMag(1);
        cmag4rd_pl = getCMag(2);
        cmag8rd_pl = getCMag(3);
        cmag8tg_pl = getCMag(4);
        cmag8m_pl  = getCMag(5);
    end

end

