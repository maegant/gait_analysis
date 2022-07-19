function f = plotCOMCOP(info,num_steps)

% setup figure
f = figure(1); clf;
ax = gca; hold on;
axis(ax,'equal');
colors = parula(8);
footcolor = [0.9,0.9,0.9];
footalpha = 1;
comcolor = colors(3,:);
copcolor = colors(7,:);

% get indices of new steps
new_step_inds = find(info.feet.new_step_flag == 1);

% get desired indices to plot (depending on how long the log is)
if info.num_steps > num_steps
    new_step_indices = new_step_inds(2:num_steps+1);
    indices = new_step_inds(2):new_step_inds(num_steps+1);
    
    % Add first stance foot
    stance_foot = info.feet.stance_foot_pos(:,new_step_inds(1));
    [x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
    rectangle(ax,'Position',[x,y,w,h],'FaceColor',[footcolor,footalpha]);
    
elseif info.num_steps > 1
    new_step_indices = new_step_inds(2:end);
    indices = new_step_inds(2):new_step_inds(end);
    
    % Add first stance foot
    stance_foot = info.feet.stance_foot_pos(:,new_step_inds(1));
    [x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
    rectangle(ax,'Position',[x,y,w,h],'FaceColor',[footcolor,footalpha]);
    
else
    new_step_indices = [];
    indices = 1:size(info.feet.stance_foot_pos,2);
end

% Plot Stance Foot
stance_foot = info.feet.stance_foot_pos(:,indices);
[x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
for i = 1:size(stance_foot,2)
    rectangle(ax,'Position',[x(i),y(i),w(i),h(i)],'FaceColor',[footcolor,footalpha]); 
end


%%

% plot COM
p_com = plot(ax,info.com(1,indices),info.com(2,indices),'r','LineWidth',2);

% plot COP
p_cop = plot(ax,info.cop(1,indices),info.cop(2,indices),'b','LineWidth',2);

% legend:
% legend(ax,[p_com,p_cop],{'com','cop'},'AutoUpdate','off');

% Formatting
xlabel('X (m)');
ylabel('Y (m)');

% get average forward velocity
avg_vel_x = norm(info.x([1,2],end)-info.x([1,2],1),2)/info.time(end);
new_step_inds = find(info.feet.new_step_flag == 1);
stance_foot = info.feet.stance_foot_pos(1,:);
avg_sl = mean(stance_foot(new_step_inds(2:end))-stance_foot(new_step_inds(1:end-1)));
avg_sc = (1/avg_sl)*avg_vel_x*60; %units in steps/min

% convert step duration to step cadence
SL = info.tuned_gait_params(1,1);
SD = info.tuned_gait_params(2,1);
SC = (1/SD)*60;
title({...%'Random Gait',...
    sprintf('SL: %2.1fcm, SC: %2.1fspm, SW: %2.1fcm',SL,SC,info.tuned_gait_params(3,1)),...
    sprintf('SH: %2.1fcm, PR: %2.1fdeg, PP: %2.1fdeg',info.tuned_gait_params(4:6,1)),...
    sprintf('Dynamicity: %2.1f',info.metrics.dynamicity),...
    sprintf('Avg Speed: %1.2f m/s',avg_vel_x)});
        
Tools.latexify;
Tools.fontsize(22);

end

function [x,y,w,h] = getFootRectangle(sole)

lengthToToe = 0.2275;
lengthToHeel = 0.0731;
width = 0.0716;

tl = sole+[lengthToToe;width];
tr = sole+[lengthToToe;-width];
bl = sole+[-lengthToHeel;width];
br = sole+[-lengthToHeel;-width];

% unrotated X and Y pairs
x = br(1,:)'; 
y = br(2,:)';
w = (lengthToToe + lengthToHeel)*ones(length(x),1);
h = 2*width*ones(length(x),1);
      
end

