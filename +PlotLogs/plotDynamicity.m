function f = plotDynamicity(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_dyn = []; mid_dyn = []; best_dyn = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            worst_dyn = cat(2,worst_dyn,cur_gait.metrics.dynamicity);
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            mid_dyn = cat(2,mid_dyn,cur_gait.metrics.dynamicity);
        end
        
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            best_dyn = cat(2,best_dyn,cur_gait.metrics.dynamicity);
        end
        
    end
end

%% Plot dynamicities
f(1) = figure; ax = gca; hold on;

errorbar(ax,[1,2,3],[mean(worst_dyn),...
    mean(mid_dyn),...
    mean(best_dyn)],...
    [std(worst_dyn),...
    std(mid_dyn),...
    std(best_dyn)],'sk','MarkerFaceColor','k','LineWidth',1)

xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('Dynamicity');
Tools.latexify;
Tools.fontsize(22);
f(1).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_dyn',mid_dyn',best_dyn')

