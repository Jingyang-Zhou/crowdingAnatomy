% analyzeCAIndividual_wrapper

%% load the list of subjects

[subjID, subjInit] = subjectList;

for k = 1 : length(subjID)
    figure (1), subplot_tight(8, 1, k, 0.02)
   datSmry{k} =  analyzeCrowdingAnatomyIndividual(subjID{k});
    title(subjID{k})
end

%% compare across subjects

subjNum = [1, 23, 31, 30, 14];

figure (2)

% compare fovea
for k = 1 : 5
   foveal(k) = datSmry{k}.mcenterRadial0(1); 
   l4(k)     = datSmry{k}.mleftRadial4(1);
   r4(k)     = datSmry{k}.mrightRadial4(1);
   lr8(k)    = datSmry{k}.mleftRadial8(1);
   rr8(k)    = datSmry{k}.mrightRadial8(1);
   
  lt8(k)     = datSmry{k}.mleftTangential8(1);
  rt8(k)     = datSmry{k}.mrightTangential8(1);
end

deg4 = mean([l4; r4]);
deg8r = mean([lr8; rr8]);
deg8t = mean([lt8; rt8]);

subplot(4, 1, 1)
plot(foveal, 'o-'), box off
set(gca, 'xtick', 1:5, 'xticklabel', subjNum)
ylabel('thresh(deg)')
title('foveal radial')
xlim([0.5, 5.5])

subplot(4, 1, 2)
plot(deg4, 'o-'), box off
set(gca, 'xtick', 1:5)
set(gca, 'xtick', 1:5, 'xticklabel', subjNum)
ylabel('thresh(deg)')
title('4 degree radial')
xlim([0.5, 5.5])

subplot(4, 1, 3)
plot(deg8r, 'o-'), box off
set(gca, 'xtick', 1:5)
set(gca, 'xtick', 1:5, 'xticklabel', subjNum)
ylabel('thresh(deg)')
title('8 degree radial')
xlim([0.5, 5.5])

subplot(4, 1, 4)
plot(deg8t, 'o-'), box off
set(gca, 'xtick', 1:5)
set(gca, 'xtick', 1:5, 'xticklabel', subjNum)
xlabel('subject number')
ylabel('thresh(deg)')
title('8 degree tangential')
xlim([0.5, 5.5])


