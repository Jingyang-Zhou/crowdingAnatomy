analyzeCAIndividualVistasoft_wrapper


function [subjID, datSmry] = analyzeCAIndividual_wrapper
% function [subjID, datSmry] = analyzeCAIndividual_wrapper

%% load the list of subjects

[subjID, subjInit] = subjectList;

for k = 1 : length(subjID)
    figure(1), subplot_tight(8, 1, k, 0.02)
    
    datSmry{k} =  analyzeCrowdingAnatomyIndividual(subjID{k});
    
    title(subjID{k})
end

%% compare across subjects

% [21, 1, 23, 31, 30, 14, 24]
% 
% totalv1Voxel = [684.8175, 686.5415, 757.2354, 787.2697, 945.8126];
% lefthemiv1   = [629.3143, 801.7175, 735.8269, 623.0764, 910.4746];
% righthemiv1  = [740.3208, 571.3654, 778.6439, 951.4630, 981.1505];

subjNum = [1, 23, 31, 30, 14];

figure (2)

% compare fovea
for k = 1 : 5
    foveal(k) = datSmry{k}.mcenterRadial0(1);
    l4(k)     = datSmry{k}.mleftRadial4(1);
    r4(k)     = datSmry{k}.mrightRadial4(1);
    lr8(k)    = datSmry{k}.mleftRadial8(1);
    rr8(k)    = datSmry{k}.mrightRadial8(1);
    
    lt8(k)    = datSmry{k}.mleftTangential8(1);
    rt8(k)    = datSmry{k}.mrightTangential8(1);
end

deg4 = mean([l4; r4]);
deg8r = mean([lr8; rr8]);
deg8t = mean([lt8; rt8]);
% 
% subplot(4, 1, 1)
% p = plot(totalv1Voxel, foveal, 'o'); box off
% p.MarkerFaceColor = 'r';
% ylabel('thresh(deg)')
% title('foveal radial')
% set(gca, 'xtick', round(totalv1Voxel))
% ylim([0, 0.1])
% 
% 
% subplot(4, 1, 2)
% p = plot(totalv1Voxel, deg4, 'o'); box off
% p.MarkerFaceColor = 'r';
% ylabel('thresh(deg)')
% title('4 degree radial')
% set(gca, 'xtick', round(totalv1Voxel))
% ylim([0, 1.5])
% 
% 
% subplot(4, 1, 3)
% p = plot(totalv1Voxel, deg8r, 'o'); box off
% p.MarkerFaceColor = 'r';
% ylabel('thresh(deg)')
% title('8 degree radial')
% set(gca, 'xtick', round(totalv1Voxel))
% ylim([0, 2.6])
% 
% subplot(4, 1, 4)
% p = plot(totalv1Voxel, deg8t, 'o'); box off
% p.MarkerFaceColor = 'r';
% xlabel('average v1 size(mm^2)')
% ylabel('thresh(deg)')
% title('8 degree tangential')
% ylim([0, 1])
% set(gca, 'xtick', round(totalv1Voxel))
% 
% %%
% figure (3), clf
% % left 4 degree
% subplot(3, 2, 1)
% p = plot(righthemiv1, l4, 'o');
% p.MarkerFaceColor = 'r';
% set(gca, 'xtick', round(sort(righthemiv1)))
% box off
% title('left 4 degree')
% ylim([0, 1.5]),  ylabel('thresh.(deg)')
% 
% 
% subplot(3, 2, 3)
% p = plot(righthemiv1, lr8, 'o');
% p.MarkerFaceColor = 'r';
% box off
% title('left 8 degree radial')
% set(gca, 'xtick', round(sort(righthemiv1)))
% ylim([0, 3]),  ylabel('thresh.(deg)')
% 
% subplot(3, 2, 5)
% p = plot(righthemiv1, lt8, 'o');
% p.MarkerFaceColor = 'r';
% box off
% title('left 8 degree tangential')
% set(gca, 'xtick', round(sort(righthemiv1)))
% ylim([0, 1]),  ylabel('thresh.(deg)')
% xlabel('right V1 size')
% 
% subplot(3, 2, 2)
% p = plot(lefthemiv1, r4, 'o');
% p.MarkerFaceColor = 'r';
% box off
% title('right 4 degree')
% set(gca, 'xtick', round(sort(lefthemiv1)))
% ylim([0, 1.4]), ylabel('thresh.(deg)')
% 
% subplot(3, 2, 4)
% p = plot(lefthemiv1, rr8, 'o');
% p.MarkerFaceColor = 'r';
% box off
% title('right 8 degree radial')
% set(gca, 'xtick', round(sort(lefthemiv1)))
% ylim([0, 3]),  ylabel('thresh.(deg)')
% 
% subplot(3, 2, 6)
% p = plot(lefthemiv1, rt8, 'o');
% p.MarkerFaceColor = 'r';
% box off
% title('right 8 degree tangential')
% set(gca, 'xtick', round(sort(lefthemiv1)))
% ylim([0, 1]),  ylabel('thresh.(deg)')
% xlabel('left V1 size')

end




