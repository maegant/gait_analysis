function f = plotMCOT(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_MCOT = []; mid_MCOT = []; best_MCOT = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            worst_MCOT = cat(2,worst_MCOT,cur_gait.metrics.MCOT);
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            mid_MCOT = cat(2,mid_MCOT,cur_gait.metrics.MCOT);
        end
        
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            best_MCOT = cat(2,best_MCOT,cur_gait.metrics.MCOT);
        end
        
    end
    
end

%% Plot MCOT for gaits

f(1) = figure; ax = gca; hold on;

errorbar(ax,[1,2,3],[mean(worst_MCOT),...
    mean(mid_MCOT),...
    mean(best_MCOT)],...
    [std(worst_MCOT),...
    std(mid_MCOT),...
    std(best_MCOT)],'sk','MarkerFaceColor','k','LineWidth',1)

xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('MCOT');
Tools.latexify;
Tools.fontsize(22);
f(1).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_MCOT',mid_MCOT',best_MCOT')



