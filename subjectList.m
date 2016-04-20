function [subjID, subjInit] = subjectList()

% Each entry in subjID is a winawer lab subject ID
% Each entry in subjInit is the initial of a subject in the behavioral
% experiment

%%

subjInit = {'EK','JB', 'SL', 'EN', 'JYZ', 'NC', 'HY'};
subjNum  = [1, 23, 31, 30, 14, 10, 36];
nSubj    = length(subjNum);
subjID   = {};

% create subject ID:
for k = 1 : nSubj
    subjID{k} = createSubjID(subjNum(k));
end

end