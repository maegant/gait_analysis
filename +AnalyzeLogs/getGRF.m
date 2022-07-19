function info = getGRF(info)

for n = 1:length(info)
    
    % unpack variables
    phase = info(n).phase;
    new_step_flag = info(n).feet.new_step_flag;
    new_step_inds = find(new_step_flag == 1);
    
    
    switch info(n).feet.stance_foot{new_step_inds(1)}
        case 'Right'
            startInd = 1;
        otherwise
            startInd = 2;
    end
    
    % Need at least 10 complete steps to analyze (skip first and last step)
    if length(new_step_inds) < 10
        info(n).metrics.mean_grf = [];
        info(n).metrics.mean_grm = [];
    else
        
        numSteps = 10;
        stopInd = numSteps-startInd;
        
        % get ind corresponding to start, middle, and end of cycle
        new_cycle_inds = new_step_inds(startInd:stopInd);
        if stopInd+1 <= length(new_step_inds)
            end_cycle_inds = new_step_inds(startInd+1:stopInd+1)-1;
        else
            end_cycle_inds = [new_step_inds(startInd+1:stopInd)-1,length(new_step_flag)];
        end
        
        % Divide data into individual strides and normalize each stride to 0-100%
        % gait cycle
        %%
        norm_grf = [];
        norm_grm = [];
        for i = 1:length(new_cycle_inds)
            
            % get current step
            inds = new_cycle_inds(i):end_cycle_inds(i);
            
            % find indics of right stance
            switch info(n).feet.stance_foot{inds(1)}
                case 'Right'
                    temp_grf = info(n).feet.right.F(:,inds);
                    temp_grm = info(n).feet.right.M(:,inds);
                case 'Left'
                    temp_grf = info(n).feet.left.F(:,inds);
                    temp_grm = info(n).feet.left.M(:,inds);
            end
            
            temp_phase = phase(:,inds);
            norm_phase = (temp_phase - temp_phase(1))/(temp_phase(end)-temp_phase(1));
            
            % normalize step to 0-100%
            temp_norm_grf = interp1(norm_phase,temp_grf',linspace(0,1,101));
            temp_norm_grf = temp_norm_grf';
            temp_norm_grm = interp1(norm_phase,temp_grm',linspace(0,1,101));
            temp_norm_grm = temp_norm_grm';
            
            %concat each new cycle in dim 3
            norm_grf = cat(3,norm_grf,temp_norm_grf);
            norm_grm = cat(3,norm_grm,temp_norm_grm);
        end
        
        %%
        info(n).metrics.mean_grf = mean(norm_grf,3);
        info(n).metrics.mean_grm = mean(norm_grm,3);
        
    end
end
end