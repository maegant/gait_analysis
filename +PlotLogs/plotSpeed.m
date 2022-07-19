function f = plotSpeed(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_speed = []; mid_speed = []; best_speed = [];
worst_sc = []; mid_sc = []; best_sc = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            
            % get speed for gait
            avg_vel_x = norm(cur_gait.x([1,2],end)-cur_gait.x([1,2],1),2)/cur_gait.time(end);
            
            % get step cadence
            new_step_inds = find(cur_gait.feet.new_step_flag == 1);
            stance_foot = cur_gait.feet.stance_foot_pos(1,:);
            avg_sl = mean(stance_foot(new_step_inds(2:end))-stance_foot(new_step_inds(1:end-1)));
            avg_sc = (1/avg_sl)*avg_vel_x*60; %units in steps/min
            
            worst_speed = cat(2,worst_speed,avg_vel_x);
            worst_sc = cat(2,worst_sc,avg_sc);
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 6
            
            % get speed for gait
            avg_vel_x = norm(cur_gait.x([1,2],end)-cur_gait.x([1,2],1),2)/cur_gait.time(end);
            
            % get step cadence
            new_step_inds = find(cur_gait.feet.new_step_flag == 1);
            stance_foot = cur_gait.feet.stance_foot_pos(1,:);
            avg_sl = mean(stance_foot(new_step_inds(2:end))-stance_foot(new_step_inds(1:end-1)));
            avg_sc = (1/avg_sl)*avg_vel_x*60; %units in steps/min
            
            mid_speed = cat(2,mid_speed,avg_vel_x);
            mid_sc = cat(2,mid_sc,avg_sc);
        end
        
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 6
            
            % get speed for gait
            avg_vel_x = norm(cur_gait.x([1,2],end)-cur_gait.x([1,2],1),2)/cur_gait.time(end);
            
            % get step cadence
            new_step_inds = find(cur_gait.feet.new_step_flag == 1);
            stance_foot = cur_gait.feet.stance_foot_pos(1,:);
            avg_sl = mean(stance_foot(new_step_inds(2:end))-stance_foot(new_step_inds(1:end-1)));
            avg_sc = (1/avg_sl)*avg_vel_x*60; %units in steps/min
            
            best_speed = cat(2,best_speed,avg_vel_x);
            best_sc = cat(2,best_sc,avg_sc);
        end
        
    end
    
end

%% Plot speed
f(1) = figure; ax = gca; hold on;

errorbar(ax,[1,2,3],[mean(worst_speed),...
    mean(mid_speed),...
    mean(best_speed)],...
    [std(worst_speed),...
    std(mid_speed),...
    std(best_speed)],'sk','MarkerFaceColor','k','LineWidth',1)

xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('Average Speed (m/s)');
Tools.latexify;
Tools.fontsize(22);
f(1).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_speed',mid_speed',best_speed')


%% Plot Step Cadence
f(2) = figure; ax = gca; hold on;

errorbar(ax,[1,2,3],[mean(worst_sc),...
    mean(mid_sc),...
    mean(best_sc)],...
    [std(worst_sc),...
    std(mid_sc),...
    std(best_sc)],'sk','MarkerFaceColor','k','LineWidth',1)

xlim([0.5,3.5]);
xticks([1,2,3]);
xticklabels({'LP','RG','MP'});
ylabel('Average Step Cadence (steps/min)');
Tools.latexify;
Tools.fontsize(22);
f(2).Position = [1988 379 249 420];

%%%% Run anova
PlotLogs.runAnova(worst_sc',mid_sc',best_sc')


