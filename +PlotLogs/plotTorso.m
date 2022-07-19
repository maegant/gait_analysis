function f = plotTorso(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_torso_mean = []; mid_torso_mean = []; best_torso_mean = [];
worst_torso_std = []; mid_torso_std = []; best_torso_std = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            mean_abs_torso = rad2deg(mean(abs(cur_gait.Torso(1:3,:)),2));
            std_abs_torso = rad2deg(std(abs(cur_gait.Torso(1:3,:)),[],2));
            worst_torso_mean = cat(2,worst_torso_mean,mean_abs_torso);
            worst_torso_std = cat(2,worst_torso_std,std_abs_torso);
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            mean_abs_torso = rad2deg(mean(abs(cur_gait.Torso(1:3,:)),2));
            std_abs_torso = rad2deg(std(abs(cur_gait.Torso(1:3,:)),[],2));
            mid_torso_mean = cat(2,mid_torso_mean,mean_abs_torso);
            mid_torso_std = cat(2,mid_torso_std,std_abs_torso);
        end
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            mean_abs_torso = rad2deg(mean(abs(cur_gait.Torso(1:3,:)),2));
            std_abs_torso = rad2deg(std(abs(cur_gait.Torso(1:3,:)),[],2));
            best_torso_mean = cat(2,best_torso_mean,mean_abs_torso);
            best_torso_std = cat(2,best_torso_std,std_abs_torso);
        end
    end
    
end

%% Plot mean roll

worst_feat  = [worst_torso_mean; worst_torso_std];
mid_feat    = [mid_torso_mean; mid_torso_std];
best_feat   = [best_torso_mean; best_torso_std];

for i = 1:6
    f(i) = figure; ax = gca; hold on;
    
    errorbar(ax,[1,2,3],[mean(worst_feat(i,:)),...
        mean(mid_feat(i,:)),...
        mean(best_feat(i,:))],...
        [std(worst_feat(i,:)),...
        std(mid_feat(i,:)),...
        std(best_feat(i,:))],'sk','MarkerFaceColor','k','LineWidth',1)
    
    switch i
        case 1
            ylabel('Abs. Torso Roll (deg)');
        case 2
            ylabel('Abs. Torso Pitch (deg)');
        case 3
            ylabel('Abs. Torso Yaw (deg)');
            ylim([1.5,4]);
        case 4
            ylabel('Std Abs. Torso Roll (deg)');
        case 5
            ylabel('Std Abs. Torso Pitch (deg)');
        case 6
            ylabel('Std Abs. Torso Yaw (deg)');
    end
    
    xlim([0.5,3.5]);
    xticks([1,2,3]);
    xticklabels({'LP','RG','MP'});
    Tools.latexify;
    Tools.fontsize(22);
    f(i).Position = [1988 379 249 420];
    
    %%%% Run anova
    PlotLogs.runAnova(worst_feat(i,:)',mid_feat(i,:)',best_feat(i,:)')
    
end

