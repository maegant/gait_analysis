function f = plotTorsoPhase(info, existing_vals, s)

% validation trials specific to each subject
switch s
    case {1,2,3,4,5}
        worst_ind = find(existing_vals == 1);
        mid_ind = find(existing_vals == 3);
        best_ind = find(existing_vals == 7);
    case 6
        worst_ind = find(existing_vals == 3);
        mid_ind = find(existing_vals == 5);
        best_ind = find(existing_vals == 7);
end

% find log indices that ignore first and last step
worst_new_steps =  find(info(worst_ind).feet.new_step_flag == 1);
mid_new_steps   =  find(info(mid_ind).feet.new_step_flag == 1);
best_new_steps  =  find(info(best_ind).feet.new_step_flag == 1);

worst_step_inds = worst_new_steps(2):worst_new_steps(end-1);
mid_step_inds   = mid_new_steps(2):mid_new_steps(end-1);
best_step_inds  = best_new_steps(2):best_new_steps(end-1);

% Process Torso Rotations
worst_torso   = info(worst_ind).Torso(:,worst_step_inds);
mid_torso     = info(mid_ind).Torso(:,mid_step_inds);
best_torso    = info(best_ind).Torso(:,best_step_inds);

%% Plot Phase Diagram Roll

for i = 1:3
    f(i) = figure(i); clf; hold on;
    colors = parula(3);
    
    p_lp = plot(rad2deg(worst_torso(i,:))   ,rad2deg(worst_torso(i+3,:))    ,'LineStyle',':','Color',[colors(1,:),0.95],'LineWidth',2);
    p_rg = plot(rad2deg(mid_torso(i,:))     ,rad2deg(mid_torso(i+3,:))      ,'LineStyle','-','Color',[colors(2,:),0.95],'LineWidth',2);
    p_mp = plot(rad2deg(best_torso(i,:))    ,rad2deg(best_torso(i+3,:))     ,'LineStyle','--','Color',[colors(3,:),0.95],'LineWidth',2);
    
    l = legend([p_lp,p_rg,p_mp],{'LP','RG','MP'});
    l.Orientation = 'horizontal';
    l.Location = 'northoutside';
    
    switch i
        case 1
            xlabel('Torso Roll (deg)');
            ylabel('Roll Vel (deg/s)');
        case 2
            xlabel('Torso Pitch (deg)');
            ylabel('Pitch Vel (deg/s)');
        case 3
            xlabel('Torso Yaw (deg)');
            ylabel('Yaw Vel (deg/s)');
    end
    
    amberTools.graphics.latexify;
    amberTools.graphics.fontsize(22);
    
end
