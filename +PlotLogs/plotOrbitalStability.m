function f = plotOrbitalStability(infos)

subs_to_plot = 1:length(infos);

worstmaxFMAll = cell(1,3); worstmaxSub = cell(1,8);
bestmaxFMAll = cell(1,3); bestmaxSub = cell(1,8);
midmaxFMAll = cell(1,3); midmaxSub = cell(1,8);

for s = subs_to_plot % go through all subjects
    
    for sel = 1:3 %go through all 3 poincare sections
        
        % Least Preferred
        for n = 1:length(infos{s}.least_preferred_gaits)
            cur_gait = infos{s}.least_preferred_gaits(n);
            if cur_gait.num_steps >= 12
                worstmaxFMAll{sel} = cat(1,worstmaxFMAll{sel},cur_gait.metrics.maxFM{sel});
                worstmaxSub{s} = cat(1,worstmaxSub{s},cur_gait.metrics.maxFM{sel});
            end
        end
        
        % Random Gaits
        for n = 1:length(infos{s}.random_gaits)
            cur_gait = infos{s}.random_gaits(n);
            if cur_gait.num_steps >= 12
                midmaxFMAll{sel}  = cat(1,midmaxFMAll{sel}, cur_gait.metrics.maxFM{sel});
                midmaxSub{s} = cat(1,midmaxSub{s},cur_gait.metrics.maxFM{sel});
            end
            
        end
        
        % Most Preferred
        for n = 1:length(infos{s}.most_preferred_gaits)
            cur_gait = infos{s}.most_preferred_gaits(n);
            if cur_gait.num_steps >= 12
                bestmaxFMAll{sel}  = cat(1,bestmaxFMAll{sel}, cur_gait.metrics.maxFM{sel});
                bestmaxSub{s} = cat(1,bestmaxSub{s},cur_gait.metrics.maxFM{sel});
            end
            
        end
        
    end
    
end


for sel = 1:3
    worst_avgmaxFM = mean(worstmaxFMAll{sel},1);
    best_avgmaxFM = mean(bestmaxFMAll{sel},1);
    mid_avgmaxFM = mean(midmaxFMAll{sel},1);
    worst_stdmaxFM = std(worstmaxFMAll{sel});
    best_stdmaxFM = std(bestmaxFMAll{sel});
    mid_stdmaxFM = std(midmaxFMAll{sel});
end


%% Plot mean maxFM over entire gait cycle for all subjects
% subplot(1,2,2); cla; hold on;
% 
% l1 = repmat({'Least Pref.'},size(worstmaxFMAll,1),1);
% l2 = repmat({'Rand Gait.'},size(midmaxFMAll,1),1);
% l2 = repmat({'Most Pref.'},size(bestmaxFMAll,1),1);
% 
% colors = parula(6);
% 
% % mean worst avgmaxFM
% legendText = {};
% for s = subs_to_plot
%     plot([1,2,3],[mean(worstmaxSub{s},'all'),...
%         mean(midmaxSub{s},'all'),...
%         mean(bestmaxSub{s},'all')]','-o','Color',colors(s,:),'MarkerFaceColor',colors(s,:))
%     legendText = cat(2,legendText,sprintf('Sub %i',s));
% end
% legend(legendText)
% 
% 
% xlim([0.75,3.25]);
% xticks([1,2,3]);
% xticklabels({'Least Pref','Rand Gait','Most Pref'})
% % boxplot([mean(worstmaxFMAll,2);
% %           mean(bestmaxFMAll,2)],...
% %           [l1;l2]);'
% 
% Tools.latexify;
% Tools.fontsize(22);

%% Prettier figure


for sel = 1:3
    f(sel) = figure; ax = gca; hold on
    
    worst_mean = mean(worstmaxFMAll{sel},2);
    rand_mean = mean(midmaxFMAll{sel},2);
    best_mean = mean(bestmaxFMAll{sel},2);
    
    errorbar(ax,[1,2,3],[mean(worst_mean),...
        mean(rand_mean),...
        mean(best_mean)],...
        [std(worst_mean),...
        std(rand_mean),...
        std(best_mean)],'sk','MarkerFaceColor','k','LineWidth',1)
    
    xlim([0.5,3.5]);
    xticks([1,2,3]);
    xticklabels({'LP','RG','MP'});
    switch sel
        case 1
            ylabel('maxFM for Torso Roll');
        case 2
            ylabel('maxFM for Torso Pitch');
        case 3
            ylabel('maxFM for Torso Yaw');
    end
    Tools.latexify;
    Tools.fontsize(22);
    f(sel).Position = [1988 379 249 420];
    
    %%%% Run anova
    PlotLogs.runAnova(worst_mean,rand_mean,best_mean)
    
end
end

