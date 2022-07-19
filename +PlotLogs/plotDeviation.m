function f = plotDeviation(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_meanSD = []; mid_meanSD = []; best_meanSD = [];

for s = subs_to_plot
    
        % Least Preferred
        for n = 1:length(infos{s}.least_preferred_gaits)
            cur_gait = infos{s}.least_preferred_gaits(n);
            if cur_gait.num_steps >= 6
                worst_meanSD = cat(2,worst_meanSD,cur_gait.metrics.meanSD);
            end
        end
        
        % Random Gaits
        for n = 1:length(infos{s}.random_gaits)
            cur_gait = infos{s}.random_gaits(n);
            if cur_gait.num_steps >= 6
                mid_meanSD = cat(2,mid_meanSD,cur_gait.metrics.meanSD);
            end
            
        end
        
        % Most Preferred
        for n = 1:length(infos{s}.most_preferred_gaits)
            cur_gait = infos{s}.most_preferred_gaits(n);
            if cur_gait.num_steps >= 6
                best_meanSD = cat(2,best_meanSD,cur_gait.metrics.meanSD);
            end
            
        end
        
end

%% Plot mean standard deviation for trunk roll

for i = 1:6
    f(i) = figure; ax = gca; hold on;
    
    worst_feat  = rad2deg(worst_meanSD(i,:))';
    mid_feat    = rad2deg(mid_meanSD(i,:))';
    best_feat   = rad2deg(best_meanSD(i,:))';
    
    errorbar(ax,[1,2,3],[mean(worst_feat),...
        mean(mid_feat),...
        mean(best_feat)],...
        [std(worst_feat),...
        std(mid_feat),...
        std(best_feat)],'sk','MarkerFaceColor','k','LineWidth',1)
    
    switch i
        case 1
            ylabel('meanSD of Torso Roll (deg)');
        case 2
            ylabel('meanSD of Torso Pitch (deg)');
        case 3
            ylabel('meanSD of Torso Yaw (deg)');
        case 4
            ylabel('meanSD of Forw. Vel. (m/s)');
        case 5
            ylabel('meanSD of Lat. Vel. (m/s)');
        case 6
            ylabel('meanSD of Vert. Vel. (m/s)');
    end
    xlim([0.5,3.5]);
    xticks([1,2,3]);
    xticklabels({'LP','RG','MP'});
    Tools.latexify;
    Tools.fontsize(22);
    f(i).Position = [1988 379 249 420];
    
    %%%% Run anova
    PlotLogs.runAnova(worst_feat,mid_feat,best_feat)
    
end



