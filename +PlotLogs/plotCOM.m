function f = plotCOM(log,info,num_steps)

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
    indices = new_step_inds(2):new_step_inds(num_steps+1);
    
    % Add first stance foot
    stance_foot = info.feet.stance_foot_pos(:,new_step_inds(1));
    [x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
    rectangle(ax,'Position',[x,y,w,h],'FaceColor',[footcolor,footalpha]);
    
elseif info.num_steps > 1
    indices = new_step_inds(2):new_step_inds(end);
    
    % Add first stance foot
    stance_foot = info.feet.stance_foot_pos(:,new_step_inds(1));
    [x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
    rectangle(ax,'Position',[x,y,w,h],'FaceColor',[footcolor,footalpha]);
    
else
    indices = 1:size(info.feet.stance_foot_pos,2);
end

% Plot Stance Foot
stance_foot = info.feet.stance_foot_pos(:,indices);
[x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
for i = 1:size(stance_foot,2)
    rectangle(ax,'Position',[x(i),y(i),w(i),h(i)],'FaceColor',[footcolor,footalpha]); 
end

% plot COM
p_com = plot(ax,info.com(1,indices),info.com(2,indices),'r','LineWidth',2);
    
% % legend(obj.axs,p_com,stancefoot],{'com','cop (right stance)','cop (left stance)','swing leg'},'AutoUpdate','off')
%     
%     drawnow





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

