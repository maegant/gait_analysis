function info = getMCOT(info)

% compute average MCOT across all steps: (From eq: 17/18 of "Algorithmic foundations of
% realizing multi-contact locomotion on the humanoid robot
% DURUS")

for n = 1:length(info)
    
    % get mass of exoskeleton for patient
    mass = info(n).model.mass;
    
    if info(n).num_steps > 5
        
        new_step_inds = find(info(n).feet.new_step_flag == 1);
        
        % all step lengths
        stance_poses = info(n).feet.stance_foot_pos(:,info(n).feet.new_step_flag == 1);
        all_sl = diff(stance_poses(1,:));
        
        
        all_mcot = [];
        for i = 1:length(new_step_inds)-1
            cur_inds = new_step_inds(i):new_step_inds(i+1)-1;
            u = info(n).joints.torque(:,cur_inds);
            dq = info(n).joints.velocity(:,cur_inds);
            time = info(n).time(:,cur_inds);
            lstep = all_sl(i);
            
            cur_mcot = getcurrentmcot(u,dq,time,mass,lstep);
            
            all_mcot = cat(2,all_mcot,cur_mcot);
        end
        
        % get mean mCOT across all steps:
        info(n).metrics.MCOT = mean(all_mcot);
        
    else
        info(n).metrics.MCOT = [];
    end
    
end
end

function mcot = getcurrentmcot(u,dq,time,mass,d)

% (From eq: 17/18 of "Algorithmic foundations of
% realizing multi-contact locomotion on the humanoid robot
% DURUS")

P = sum(sqrt((u.*(dq./(2*pi))).^2),1);
intP = cumtrapz(time,P);
mcot = sum(intP)/(mass*9.81*d);

end
