function f = plotRobot(info,model)

% setup figure
f = figure(1); clf;
ax = gca; 
axis(ax,'equal'); grid off;
colors = parula(8);
footcolor = [0.9,0.9,0.9];
footalpha = 1;
comcolor = colors(3,:);
copcolor = colors(7,:);

% get indices of new steps
new_step_inds = find(info.feet.new_step_flag == 1);



% get desired indices to plot (depending on how long the log is)
   
if info.num_steps >= 5
    indices = new_step_inds(2):new_step_inds(4);
    
    for i = [new_step_inds(2:4)]
        show(model.loadedExo,info.x(:,i),'Visuals','on','Frames','off'); hold on;
        %     pause(1);
    end

else
    indices = [];
end

% edit view
view(ax,0,20);
% view(ax,90,20);
xlim([-0.5,0.75]);
ylim([-0.5,1]);
zlim([0,1.8]);
ax.GridAlpha = 0.1;

% add floor
[x y] = meshgrid(-0.5:0.1:1); % Generate x and y data
z = zeros(size(x, 1)); % Generate z data
surf(x, y, z) % Plot the surface

% Plot prior stance foot
stance_foot = info.feet.stance_foot_pos(:,new_step_inds(1));
[x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
for i = 1:size(stance_foot,2)
    rectangle(ax,'Position',[x(i),y(i),w(i),h(i)],'FaceColor',[footcolor,footalpha]); 
end

% Plot Stance Foot
stance_foot = info.feet.stance_foot_pos(:,indices);
[x,y,w,h] = getFootRectangle(stance_foot([1,2],[1:end]));
for i = 1:size(stance_foot,2)
    rectangle(ax,'Position',[x(i),y(i),w(i),h(i)],'FaceColor',[footcolor,footalpha]); 
end

amberTools.graphics.latexify;
amberTools.graphics.fontsize(25);
f.Position = [2088 130 560 829];
%%

% plot COM
p_com = plot(ax,info.com(1,indices),info.com(2,indices),'r','LineWidth',2);

% plot COP
p_cop = plot(ax,info.cop(1,indices),info.cop(2,indices),'b','LineWidth',2);

% legend:
% legend(ax,[p_com,p_cop],{'com','cop'},'AutoUpdate','off');

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

