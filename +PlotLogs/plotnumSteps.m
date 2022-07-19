function f = plotnumSteps(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_feats = []; mid_feats = []; best_feats = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            worst_feats = cat(2,worst_feats,cur_gait.num_steps);
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            mid_feats = cat(2,mid_feats,cur_gait.num_steps);
        end
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            best_feats = cat(2,best_feats,cur_gait.num_steps);
        end
    end
    
end

%% Plot Cost of Dynamicity
f(1) = figure; ax = gca; hold on;

errorbar(ax,[1,2,3],[mean(worst_feats),...
    mean(mid_feats),...
    mean(best_feats)],...
    [std(worst_feats),...
    std(mid_feats),...
    std(best_feats)],'sk','MarkerFaceColor','k','LineWidth',1)

xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('Total Steps Taken');
Tools.latexify;
Tools.fontsize(22);
f(1).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_feats',mid_feats',best_feats')

