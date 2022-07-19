function runAnova(worst_mean,rand_mean,best_mean)

labels1 = [repmat({'worst'},length(worst_mean),1); ...
    repmat({'rand'},length(rand_mean),1)]';
labels2 = [repmat({'worst'},length(worst_mean),1); ...
    repmat({'best'},length(best_mean),1)]';
labels3 = [repmat({'rand'},length(rand_mean),1); ...
    repmat({'best'},length(best_mean),1)]';
[p1,~] = anova1([worst_mean',rand_mean'],labels1,'off');
[p2,~] = anova1([worst_mean',best_mean'],labels2,'off');
[p3,~] = anova1([rand_mean',best_mean'],labels3,'off');

if p1<=0.05
    p1color = [0,0,0];
elseif p1<=0.2
    p1color = [0.5,0.5,0.5];
end
if p2<=0.05
    p2color = [0,0,0];
elseif p2<=0.2
    p2color = [0.5,0.5,0.5];
end
if p3<=0.05
    p3color = [0,0,0];
elseif p3<=0.2
    p3color = [0.5,0.5,0.5];
end
   

if p1<=0.2
    text(2,mean(rand_mean)+std(rand_mean),'$\ast$','Interpreter','latex','HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',40,'Color',p1color)
end
if p2<=0.2
    text(3,mean(best_mean)+std(best_mean),'$\ast$','Interpreter','latex','HorizontalAlignment','left','VerticalAlignment','baseline','FontSize',40,'Color',p2color)
end
if p3 <= 0.2
    text(3,mean(best_mean)-std(best_mean),'$\Delta$','Interpreter','latex','HorizontalAlignment','center','VerticalAlignment','cap','FontSize',40,'Color',p3color)
end

p1 
p2
p3

end
