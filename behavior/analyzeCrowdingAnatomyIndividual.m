function datSmry = analyzeCrowdingAnatomyIndividual(subj)

% function [] = analyzeCrowdingAnatomyIndividual(subjNum)

% subjNum: for example, 23 means "wl_subj023", input can either be a
%          subject ID ('wl_subj023') or a subject number (23).

% To see the list of subject initials and subject ID, type "subjectList"

%% Example

exampleOn = 0;

if exampleOn,
    subj = 31;
end

%% varify inputs:

if isstr(subj)
    assert(strcmp(subj(1:7), 'wl_subj'), 'subj needs to be a Winawer lab subject ID.');
    subjID = subj;
elseif isnumeric(subj)
    subjID = createSubjID(subj);
end

%% Paths and directory

current = pwd;
[prjDir, datDir, codeDir] = crowdingAnatPth;

% go to data directory
cd(datDir)

%% extract spacing data (critical space)

% load all the mat files for the subject
files = dir(sprintf('%s*.mat', subjID));

% make sure there are 7 data files per subejct
assert(length(files)== 7, 'The number of data files is incorrect.');

for k = 1: length(files)
    clear oo
    a   = load(files(k).name);
    dat = a.oo;
    
    % record this run's parameters, param: [ecc, fixLoc, radTang]
    run(k).param    = {};
    run(k).param    = {dat(1).eccentricityDeg, dat(1).fixationLocation, dat(1).radialOrTangential};
    run(k).thresh   = [10^(QuestMean(dat(1).q)), 10^(QuestMean(dat(2).q))];
    run(k).threshsd = [10^(QuestSd(dat(1).q)), 10^(QuestSd(dat(2).q))];
end

%% extract size data (acuity)

if strcmp(subjID, 'wl_subj014')
    acfiles = dir(sprintf('size%s*.mat', subjID));
    
    for k = 1 : length(acfiles)
        clear oo
        a   = load(acfiles(k).name);
        dat = a.oo;
        
        % record this run's parameters, param : [ecc, fixLoc];
        szrun(k).param    = {};
        szrun(k).param    = {dat(1).eccentricityDeg, dat(1).fixationLocation};
        szrun(k).thresh   = [10^(QuestMean(dat(1).q)), 10^(QuestMean(dat(2).q))];
        szrun(k).threshsd = [10^(QuestSd(dat(1).q)), 10^(QuestSd(dat(2).q))];
    end
end

%% re-arrange data

cmpMean   = @(k) [mean(run(k).thresh), mean(run(k).threshsd)];


% datSmry
clear datSmry

% critical space:
for k = 1 : length(files)
    prmStr = sprintf('%d%s%s', run(k).param{1}, run(k).param{2}, run(k).param{3});
    switch prmStr
        case '0centerradial'
            datSmry.centerRadial0      = run(k).thresh;
            datSmry.centerRadial0sd    = run(k).threshsd;
            datSmry.mcenterRadial0     = cmpMean(k);
        case '4rightradial'
            datSmry.leftRadial4        = run(k).thresh;
            datSmry.leftRadial4sd      = run(k).threshsd;
            datSmry.mleftRadial4       = cmpMean(k);
        case '4leftradial'
            datSmry.rightRadial4       = run(k).thresh;
            datSmry.rightRadial4sd     = run(k).threshsd;
            datSmry.mrightRadial4      = cmpMean(k);
        case '8rightradial'
            datSmry.leftRadial8        = run(k).thresh;
            datSmry.leftRadial8sd      = run(k).threshsd;
            datSmry.mleftRadial8       = cmpMean(k);
        case '8leftradial'
            datSmry.rightRadial8       = run(k).thresh;
            datSmry.rightRadial8sd     = run(k).threshsd;
            datSmry.mrightRadial8      = cmpMean(k);
        case '8righttangential'
            datSmry.leftTangential8    = run(k).thresh;
            datSmry.leftTangential8sd  = run(k).threshsd;
            datSmry.mleftTangential8   = cmpMean(k);
        case '8lefttangential'
            datSmry.rightTangential8   = run(k).thresh;
            datSmry.rightTangential8sd = run(k).threshsd;
            datSmry.mrightTangential8  = cmpMean(k);
    end
end

if strcmp(subjID, 'wl_subj014')
    cmpszMean = @(k) [mean(szrun(k).thresh), mean(szrun(k).threshsd)];
    % size
    for k = 1 : length(acfiles)
        szPrmStr =  sprintf('%d%s%s', szrun(k).param{1}, szrun(k).param{2});
        switch szPrmStr
            case '0center'
                datSmry.szcenter0   = szrun(k).thresh;
                datSmry.szcenter0sd = szrun(k).threshsd;
                datSmry.szmcenter0  = cmpszMean(k);
            case '4left'
                datSmry.szright4    = szrun(k).thresh;
                datSmry.szright4sd  = szrun(k).threshsd;
                datSmry.szmright4   = cmpszMean(k);
            case '4right'
                datSmry.szleft4     = szrun(k).thresh;
                datSmry.szleft4sd   = szrun(k).threshsd;
                datSmry.szmleft4  = cmpszMean(k);
            case '8left'
                datSmry.szright8    = szrun(k).thresh;
                datSmry.szright8sd  = szrun(k).threshsd;
                datSmry.szmright8   = cmpszMean(k);
            case '8right'
                datSmry.szleft8     = szrun(k).thresh;
                datSmry.szleft8sd   = szrun(k).threshsd;
                datSmry.szmleft8    = cmpszMean(k);
        end
    end
end
%% do polar plot - critical space

if exampleOn
    figure(2), clf
end
set(gca, 'Color', 'k')
p1 = polar(0, 10);
p1.Color = 'k';
t  = findall(gcf, 'type', 'text');
delete(t)

% plot foveal threshold
foveal   = datSmry.mcenterRadial0;
lf       = line([-foveal(1), foveal(1)], [0, 0]); hold on
lf.Color = 'k';
df       = plot(0, 0, 'ko', 'markersize', 5);

% plot 4 degree threshold
left4deg  = datSmry.leftRadial4;
right4deg = datSmry.mrightRadial4;

ll4 = line([-4-left4deg(1), -4+left4deg(1)], [0, 0]);
ll4.Color = 'm';
dl4 = plot(-4, 0, 'mo', 'markersize', 5);
rl4 = line([4-right4deg(1), 4+right4deg(1)], [0, 0]);
rl4.Color = 'm';
dr4 = plot(4, 0, 'mo', 'markersize', 5);

% plot 8 degree
% radial
leftr8deg  = datSmry.mleftRadial8;
rightr8deg = datSmry.mrightRadial8;

ll8 = line([-8-leftr8deg(1), -8+leftr8deg(1)], [0, 0]);
ll8.Color = 'c';
dl8 = plot(-8, 0, 'co', 'markersize', 5);

rl8 = line([8-rightr8deg(1), 8+rightr8deg(1)], [0, 0]);
rl8.Color = 'c';
dl8 = plot(8, 0, 'co', 'markersize', 5);

% tangential
leftt8deg  = datSmry.mleftTangential8;
rightt8deg = datSmry.mrightTangential8;

tl8        = line([-8, -8], [-leftt8deg(1), leftt8deg(1)]);
tl8.Color  = 'c';
dt8 = plot(-8, 0, 'co', 'markersize', 5);

tr8        = line([8, 8], [-rightt8deg(1), rightt8deg(1)]);
tr8.Color  = 'c';
dr8        = plot(8, 0, 'co', 'markersize', 5);

ylim([-3, 3])

%% plot critical space and acuity comparison

crleft8dg    = mean([datSmry.mleftRadial8(1), datSmry.mleftTangential8(1)]);
crright8dg   = mean([datSmry.mrightRadial8(1), datSmry.mrightTangential8(1)]);

crleft8dgsd  = mean([datSmry.mleftRadial8(2), datSmry.mleftTangential8(2)]);
crright8dgsd = mean([datSmry.mrightRadial8(2), datSmry.mrightTangential8(2)]);

% if strcmp(subjID, 'wl_subj014')
%     figure (100), clf
%     
%     % plot critical space
%     deg = [-8, -4, 0, 4, 8];
%     p1 = plot(deg, [crleft8dg , left4deg(1), foveal(1), right4deg(1), crright8dg], 'ro:'); hold on
%     p2 = plot(deg+0.2, [datSmry.szmleft8(1), datSmry.szmleft4(1), 0, datSmry.szmright4(1), datSmry.szmright8(1)], 'bo:');
%     p1.MarkerFaceColor = 'r';
%     p1.MarkerEdgeColor = 'k';
%     p2.MarkerFaceColor = 'b';
%     p2.MarkerEdgeColor = 'k';
%     
%     % plot error bar
%     l1 = line([-8, -8], [crleft8dg - crleft8dgsd, crleft8dg + crleft8dgsd]);
%     l2 = line([8, 8], [crright8dg - crright8dgsd, crright8dg + crright8dgsd]);
%     l3 = line([-4, -4], [left4deg(1)- left4deg(2), left4deg(1)+left4deg(2)]);
%     l4 = line([4, 4], [right4deg(1)- right4deg(2), right4deg(1)+right4deg(2)]);
%     l5 = line([0, 0], [foveal(1) - foveal(2), foveal(1)+ foveal(2)]);
%     l1.Color = 'r';
%     l2.Color = 'r';
%     l3.Color = 'r';
%     l4.Color = 'r';
%     l5.Color = 'r';
%     
%     l6 = line([-8, -8]+0.2, [datSmry.szmleft8(1) - datSmry.szmleft8(2), datSmry.szmleft8(1)+datSmry.szmleft8(2)]);
%     l7 = line([-4, -4]+0.2, [datSmry.szmleft4(1) - datSmry.szmleft4(2), datSmry.szmleft4(1)+datSmry.szmleft4(2)]);
%     l8 = line([4, 4]+0.2, [datSmry.szmright4(1) - datSmry.szmright4(2), datSmry.szmright4(1)+datSmry.szmright4(2)]);
%     l9 = line([8, 8]+0.2, [datSmry.szmright8(1) - datSmry.szmright8(2), datSmry.szmright8(1)+datSmry.szmright8(2)]);
%     l6.Color = 'b';
%     l7.Color = 'b';
%     l8.Color = 'b';
%     l9.Color = 'b';
%     
%     box off
%     xlabel('ecc.')
%     ylabel('threshold (deg)')
%     title('Compare acuity and critical space')
%     text(0.2, 0.03, 'not a measured point')
%     legend('critical space', 'acuity')
%     xlim([-8.5, 8.5])
% end



%%
end

