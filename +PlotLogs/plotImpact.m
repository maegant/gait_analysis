function f = plotImpact(infos)

subs_to_plot = 1:length(infos);

% Separate log files
worst_normImp = []; mid_normImp = []; best_normImp = [];
worst_normGRF = []; mid_normGRF = []; best_normGRF = [];
worst_cycleGRF = []; mid_cycleGRF = []; best_cycleGRF = [];

for s = subs_to_plot
    
    % Least Preferred
    for n = 1:length(infos{s}.least_preferred_gaits)
        cur_gait = infos{s}.least_preferred_gaits(n);
        if cur_gait.num_steps >= 12
            if ~isempty(cur_gait.metrics.mean_grf)
                mass = cur_gait.model.mass;
                worst_normImp = cat(2,worst_normImp,cur_gait.metrics.mean_grf(:,1)/(mass*9.81));
                worst_normGRF = cat(2,worst_normGRF,cur_gait.metrics.mean_grm(:,1));
                worst_cycleGRF = cat(1,worst_cycleGRF,cur_gait.metrics.mean_grf(3,:)/(mass*9.81));
            end
        end
    end
    
    % Random Gaits
    for n = 1:length(infos{s}.random_gaits)
        cur_gait = infos{s}.random_gaits(n);
        if cur_gait.num_steps >= 12
            if ~isempty(cur_gait.metrics.mean_grf)
                mass = cur_gait.model.mass;
                mid_normImp = cat(2,mid_normImp,cur_gait.metrics.mean_grf(:,1)/(mass*9.81));
                mid_normGRF = cat(2,mid_normGRF,cur_gait.metrics.mean_grm(:,1));
                mid_cycleGRF = cat(1,mid_cycleGRF,cur_gait.metrics.mean_grf(3,:)/(mass*9.81));
            end
        end
    end
    
    % Most Preferred
    for n = 1:length(infos{s}.most_preferred_gaits)
        cur_gait = infos{s}.most_preferred_gaits(n);
        if cur_gait.num_steps >= 12
            if ~isempty(cur_gait.metrics.mean_grf)
                mass = cur_gait.model.mass;
                best_normImp = cat(2,best_normImp,cur_gait.metrics.mean_grf(:,1)/(mass*9.81));
                best_normGRF = cat(2,best_normGRF,cur_gait.metrics.mean_grm(:,1));
                best_cycleGRF = cat(1,best_cycleGRF,cur_gait.metrics.mean_grf(3,:)/(mass*9.81));
            end
        end
    end
    
end

%% Plot Impact in X

worst_feat = [worst_normImp;worst_normGRF;vecnorm(worst_normImp,1)];
mid_feat = [mid_normImp;mid_normGRF;vecnorm(mid_normImp,1)];
best_feat = [best_normImp;best_normGRF;vecnorm(best_normImp,1)];

for i = 1:7
    f(i) = figure; ax = gca; hold on;
    
    errorbar(ax,[1,2,3],[mean(worst_feat(i,:)),...
        mean(mid_feat(i,:)),...
        mean(best_feat(i,:))],...
        [std(worst_feat(i,:)),...
        std(mid_feat(i,:)),...
        std(best_feat(i,:))],'sk','MarkerFaceColor','k','LineWidth',1)
    
    switch i
        case 1
            ylabel('$F_x$ at impact ($\%$ of mass)','Interpreter','latex');
        case 2
            ylabel('$F_y$ at impact ($\%$ of mass)','Interpreter','latex');
        case 3
            ylabel('$F_z$ at impact ($\%$ of mass)','Interpreter','latex');
        case 4
            ylabel('$M_x$ (N-m)','Interpreter','latex');
        case 5
            ylabel('$M_y$ (N-m)','Interpreter','latex');
        case 6
            ylabel('$M_z$ (N-m)','Interpreter','latex');
        case 7
            ylabel('Average Impact ($\%$ of mass)','Interpreter','latex');
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

%% Plot of GRF over Gait
f(8) = figure; ax = gca; hold on;

colors = parula(4);

plot(0:100,mean(worst_cycleGRF,1),'Color',colors(1,:),'LineWidth',2);
plot(0:100,mean(mid_cycleGRF,1),'Color',colors(2,:),'LineWidth',2);
plot(0:100,mean(best_cycleGRF,1),'Color',colors(3,:),'LineWidth',2);

l = legend({'Least Pref.','Rand Gait','Most Pref'});
l.Location = 'southeast';

xlabel('Percent Stance Phase ($\%$)','Interpreter','latex');
ylabel('$F_z$ ($\%$ of mass)','Interpreter','latex');
Tools.latexify;
Tools.fontsize(22);




