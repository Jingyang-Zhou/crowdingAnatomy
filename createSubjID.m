% create subject ID
function subjID = createSubjID(subjNum)

% function subjID = createSubjID(subjNum)

%% example

exmapleOn = 0;

if exmapleOn
    subjNum = 10;
end

%% varify input

assert(isnumeric(subjNum), 'subjNum needs to be an integer.')

%% make subject ID

if (subjNum < 10) & (subjNum > 0)
    subjID = sprintf('wl_subj00%d', subjNum);
elseif subjNum >= 10
    subjID = sprintf('wl_subj0%d', subjNum);
else
    error('subjNum needs to be an integer above zero.')
end


end