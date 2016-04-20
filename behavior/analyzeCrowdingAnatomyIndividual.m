function datSmry = analyzeCrowdingAnatomyIndividual(subj)

% function [] = analyzeCrowdingAnatomyIndividual(subjNum)

% subjNum: for example, 23 means "wl_subj023", input can either be a
%          subject ID ('wl_subj023') or a subject number (23).

% To see the list of subject initials and subject ID, type "subjectList"

%% Example

exampleOn = 0;

if exampleOn,
    subj = 14;
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

%% extract data

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

%% re-arrange data

% datSmry
clear datSmry

for k = 1 : length(files)
    prmStr = sprintf('%d%s%s', run(k).param{1}, run(k).param{2}, run(k).param{3});  
    switch prmStr
        case '0centerradial'
            datSmry.centerRadial0      = run(k).thresh;
            datSmry.centerRadial0sd    = run(k).threshsd;
            datSmry.mcenterRadial0     = [mean(datSmry.centerRadial0), mean(datSmry.centerRadial0sd)];
        case '4rightradial'
            datSmry.leftRadial4        = run(k).thresh;
            datSmry.leftRadial4sd      = run(k).threshsd;
            datSmry.mleftRadial4       = [mean(datSmry.leftRadial4), mean(datSmry.leftRadial4sd)];
        case '4leftradial'
            datSmry.rightRadial4       = run(k).thresh;
            datSmry.rightRadial4sd     = run(k).threshsd;
            datSmry.mrightRadial4      = [mean(datSmry.rightRadial4), mean(datSmry.rightRadial4sd)];
        case '8rightradial'
            datSmry.leftRadial8        = run(k).thresh;
            datSmry.leftRadial8sd      = run(k).threshsd;
            datSmry.mleftRadial8       = [mean(datSmry.leftRadial8), mean(datSmry.leftRadial8sd)];
        case '8leftradial'
            datSmry.rightRadial8       = run(k).thresh;
            datSmry.rightRadial8sd     = run(k).threshsd;
            datSmry.mrightRadial8      = [mean(datSmry.rightRadial8), mean(datSmry.rightRadial8sd)];
        case '8righttangential'
            datSmry.leftTangential8    = run(k).thresh;
            datSmry.leftTangential8sd  = run(k).threshsd;
            datSmry.mleftTangential8   = [mean(datSmry.leftTangential8), mean(datSmry.leftTangential8sd)];
        case '8lefttangential'
            datSmry.rightTangential8   = run(k).thresh;
            datSmry.rightTangential8sd = run(k).threshsd;
            datSmry.mrightTangential8  = [mean(datSmry.rightTangential8), mean(datSmry.rightTangential8sd)];
    end 
end

%% do polar plot

% figure, clf

p1 = polar(0, 10);
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


%%
end

