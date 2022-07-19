function info = getDeviation(info)

for n = 1:length(info)
    % unpack variables (cleaner code albeit slower)
    phase = info(n).phase;
    new_step_flag = info(n).feet.new_step_flag;
    new_step_inds = find(new_step_flag == 1);
    
    %% Get Standard Deviation of Trunk Motions
    
    % DESCRIPTION:
    %   - asses variability of stride data over the entire gait cycle
    %   - Taken from https://reader.elsevier.com/reader/sd/pii/S096663620700183X?token=8E0C13054A38D188931BAD7DE68108754732CFD437825AA429FB2DB8B6E003F7A97026E84D55A74537A69472E7B57E09&originRegion=us-east-1&originCreation=20220707170239
    
    % IMPORTANT: Take every other step to get a full gait cycle, and update the
    % phase
    switch info(n).feet.stance_foot{new_step_inds(1)}
        case 'Right'
            startInd = 3;
        otherwise
            startInd = 4;
    end
    
    %% Need at least 10 cycles of data
    if length(new_step_inds) < 14
        
        info(n).metrics.meanSD = [];
        
    else
        
        %% Divide data into complete gait cycles (RHS to RHS)
        stopInd = length(new_step_inds)-2;
        new_cycle_inds = new_step_inds(startInd:2:stopInd);
        middle_cycle_inds = new_step_inds(startInd+1:2:stopInd+1);
        end_cycle_inds = new_step_inds(startInd+2:2:stopInd+2)-1;
        cycle_phase = phase;
        for i = 1:length(new_cycle_inds)
            cycle_phase(middle_cycle_inds(i):end_cycle_inds(i)) = phase(middle_cycle_inds(i):end_cycle_inds(i))+phase(middle_cycle_inds(i)-1)+eps;
        end
        
        %% Normalize Strides to 0-100% Gait Cycle
        norm_rot = [];
        norm_dx = [];
        for i = 1:length(new_cycle_inds)
            
            % get current step
            inds = new_cycle_inds(i):end_cycle_inds(i);
            temp_rot = info(n).Torso(1:3,inds);
            temp_dx = info(n).dx(1:3,inds);
            temp_phase = cycle_phase(:,inds);
            
            % normalize step to 0-100%
            norm_phase = (temp_phase - temp_phase(1))/(temp_phase(end)-temp_phase(1));
            temp_norm_rot = interp1(norm_phase,temp_rot',linspace(0,1,101));
            temp_norm_dx = interp1(norm_phase,temp_dx',linspace(0,1,101));
            temp_norm_rot = temp_norm_rot';
            temp_norm_dx = temp_norm_dx';
            
            %concat each new cycle in dim 3
            norm_rot = cat(3,norm_rot,temp_norm_rot);
            norm_dx = cat(3,norm_dx,temp_norm_dx);
        end
        
        %% Compute mean SD
        meanSD = mean(std([norm_rot;norm_dx],[],3),2);
        
        %% Store meanSD
        info(n).metrics.meanSD = meanSD;
        
    end
    
end

