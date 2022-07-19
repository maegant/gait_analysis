function info = getDynamicity(info)

for n = 1:length(info)
    
    % Compute measure of 'dynamicity'
    if info(n).num_steps > 5
        
        new_step_inds = find(info(n).feet.new_step_flag == 1);
        
        % get all step lengths
        stance_poses = info(n).feet.stance_foot_pos(:,info(n).feet.new_step_flag == 1);
        all_sl = diff(stance_poses(1,:));
        
        % get all step durations
        all_sd = diff(info(n).time(:,new_step_inds));
        
        all_dynamicity = [];
        for i = 1:length(new_step_inds)-1
            cur_inds = new_step_inds(i):new_step_inds(i+1)-1;
            
            com = info(n).com([1,2],cur_inds);
            cop = info(n).cop(:,cur_inds);
            time = info(n).time(:,cur_inds);
            
            current_dyn = getcurrentdynamicity(com,cop,time,all_sl(i),all_sd(i));
            
            all_dynamicity = cat(2,all_dynamicity,current_dyn);
        end
        
        info(n).metrics.dynamicity = mean(all_dynamicity);
        
    else
        info(n).metrics.dynamicity = [];
    end
    
end

end

%% Helper function for computing dynamicity of a step
function dynamicity = getcurrentdynamicity(com,cop,time,sl,sd)

% compute: ||com-cop||_2
comcop = vecnorm(com-cop,2,1);

% compute dynamicity
integral = cumtrapz(time,comcop);
dynamicity = integral(end)/(sl*sd);

end










