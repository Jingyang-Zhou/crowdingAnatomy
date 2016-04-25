function output = getLabels(szOrCmag, sbjOrData)

% function output = getLabels(szOrCmag, sbjOrData)
% szOrCmag  : "size" or "cMag" (cortical magnification)
% sbjOrData : "subjects" (subject list) or "data" (brain data)

exampleOn = 0;
if exampleOn
    szOrCmag  = 'cmag';
    sbjOrData = 'data';
end

%% size or cortical magnification

hemi      = {'LH', 'RH'};
layer     = {'white', 'midgray', 'pial'};
method    = {'hinds', 'template_12', 'template_8', 'hinds_length', 'hinds_width'};
direction = {'mean', 'radial', 'tangential'};
dg        = [2, 4, 8];

switch lower(szOrCmag)
    case 'size'
        labels = {};
        for k1 = 1 : length(hemi)
            for k2 = 1 : length(layer)
                for k3 = 1 : length(method)
                    labels = [labels, sprintf('%s_%s_%s', hemi{k1}, layer{k2}, method{k3})];
                end
            end
        end
    case 'cmag'
        labels     = {};
        for k1 = 1 : length(hemi)
            for k2 = 1 : length(layer)
                for k3 = 1 : length(direction)
                    for k4 = 1 : length(dg)
                        labels = [labels, sprintf('%s_%s_%s_%d', hemi{k1}, ...
                            layer{k2}, direction{k3}, dg(k4))];
                    end
                end
            end
        end
end

%% subjects or data
sbjList = [36, 23, 31, 30, 14, 4, 10, 1];

%% select which output

switch lower(sbjOrData)
    case {'subjects', 'subject', 'subj'}
        output = sbjList;
    case 'data'
        output = labels;
end

%%
end