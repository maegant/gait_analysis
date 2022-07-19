function f = plotLocalStability(infos)

subs_to_plot = 1:length(infos);

% collect worst and best distances for each subject
worst_distances = cell(8,1);
best_distances = cell(8,1);
mid_distances = cell(8,1);
worst_ls = []; worst_ll = [];
best_ls = []; best_ll = [];
mid_ls = []; mid_ll = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            worst_distances{s} = cat(1,worst_distances{s},cur_gait.metrics.mean_neighbor_distance);
            worst_ls = cat(1,worst_ls,cur_gait.metrics.lambda_short);
            worst_ll = cat(1,worst_ll,cur_gait.metrics.lambda_long);
        end
        
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            mid_distances{s}  = cat(1,mid_distances{s}, cur_gait.metrics.mean_neighbor_distance);
            mid_ls = cat(1,mid_ls,cur_gait.metrics.lambda_short);
            mid_ll = cat(1,mid_ll,cur_gait.metrics.lambda_long);
        end
        
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            best_distances{s}  = cat(1,best_distances{s}, cur_gait.metrics.mean_neighbor_distance);
            best_ls = cat(1,best_ls,cur_gait.metrics.lambda_short);
            best_ll = cat(1,best_ll,cur_gait.metrics.lambda_long);
        end
        
    end
    
end

%% Plot group means for short-term  divergence exponents
f(1) = figure; hold on; ax = gca;

errorbar(ax,[1,2,3],[mean(worst_ls),mean(mid_ls),mean(best_ls)],[std(worst_ls),std(mid_ls),std(best_ls)],'sk','MarkerFaceColor','k','LineWidth',1)
xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('$\lambda_S$','Interpreter','latex');
Tools.latexify;
Tools.fontsize(22);
f(1).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_ls,mid_ls,best_ls)
%% Plot group means for long-term divergence exponents
f(2) = figure; hold on; ax = gca;

errorbar(ax,[1,2,3],[mean(worst_ll),mean(mid_ll),mean(best_ll)],[std(worst_ll),std(mid_ll),std(best_ll)],'sk','MarkerFaceColor','k','LineWidth',1)
xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('$\lambda_L$','Interpreter','latex');
Tools.latexify;
Tools.fontsize(22);
f(2).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_ll,mid_ll,best_ll)

end

