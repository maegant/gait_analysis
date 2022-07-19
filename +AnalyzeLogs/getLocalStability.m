function info = getLocalStability(info)

for n = 1:length(info)
    
    % unpack variables
    phase = info(n).phase;
    new_step_flag = info(n).feet.new_step_flag;
    new_step_inds = find(new_step_flag == 1);
    
    %% Get Local Divergence Exponents (short-term and long-term)
    
    % DESCRIPTION:
    %   - assess dynamic walking stability within consecutive strides and
    %   describe how quickly infinitesimally close initial conditions
    %   diverge over time
    %   - Taken from (Dingwell and Cusumano, 2000)
    
    % IMPORTANT: Take every other step to get a full gait cycle, and update the
    % phase
    switch info(n).feet.stance_foot{new_step_inds(1)}
        case 'Right'
            startInd = 1;
        otherwise
            startInd = 2;
    end
    
    % Need at least 10 complete cycles to analyze
    if length(new_step_inds) < 20
        
        info(n).metrics.mean_neighbor_distance = [];
        info(n).metrics.lambda_short = [];
        info(n).metrics.lambda_long = [];
        
    else
        
        %  get ind corresponding to start, middle, and end of cycle
        %   (from Right Impact to Right Impact)
        stopInd = startInd+(2*(10-1));
        new_cycle_inds = new_step_inds(startInd:2:stopInd);
        middle_cycle_inds = new_step_inds(startInd+1:2:stopInd+1);
        end_cycle_inds = new_step_inds(startInd+2:2:stopInd+2)-1;
        cycle_phase = phase;
        for i = 1:length(new_cycle_inds)
            cycle_phase(middle_cycle_inds(i):end_cycle_inds(i)) = phase(middle_cycle_inds(i):end_cycle_inds(i))+phase(middle_cycle_inds(i)-1)+eps;
        end
        
        % Take 10 continuous strides of data:
        mean_nt = [];
        for i = 1:10
            cur_inds = new_cycle_inds(i):end_cycle_inds(i);
            mean_nt = cat(2,mean_nt,size(info(n).x(:,cur_inds)));
        end
        mean_nt = ceil(mean(mean_nt));
        
        % entire x:
        x_clipped = [info(n).x(4:6,new_cycle_inds(1):end_cycle_inds(end));info(n).dx(4:6,new_cycle_inds(1):end_cycle_inds(end))];
        t_clipped = info(n).time(:,new_cycle_inds(1):end_cycle_inds(end));
        
        % 10 continuous  strides of data were re-sampled to be 1000 data points
        % (average of 100 per stride)
        avg_dt = mean(diff(t_clipped));
        t_clipped_resamp = linspace(t_clipped(1),t_clipped(end),1000);
        x_clipped_resamp = interp1(t_clipped,x_clipped',t_clipped_resamp);
        x_clipped_resamp = x_clipped_resamp';
        
        % reconstruct attractor dynamics using method of delays
        %embedding dimension - m > 2n
        % Find nearest neighbors. Constrain temporal seperation.
        % Measure average separation of neighbors. Do not normalize.
        % Use least squares to fit a line to the data.
        
        % Compute logarithmic distance between neighboring trajectories for
        % subsequent strides
        %     all_distances = cell(10,1);
        all_distances = [];
        %%
        % compute euclidean distance between jth pair of nearest neighbors
        for j = 1:100
            for i = 1:1000
                nearestneighbor = min(vecnorm(x_clipped_resamp(:,j)-x_clipped_resamp(:,min(900,j+i):end),2,1));
                all_distances(j,i) = nearestneighbor;
            end
        end
        % equation 8 of https://aip.scitation.org/doi/pdf/10.1063/1.1324008
        avgs = log(vecnorm(all_distances,2,1));
        
        avgs_short = avgs(1:100); %0-1stride
        avgs_long = avgs(101:end);
        
        info(n).metrics.mean_neighbor_distance = avgs;
        info(n).metrics.lambda_short = (avgs_short(end)-avgs_short(1))/(t_clipped_resamp(100)-t_clipped_resamp(1));
        info(n).metrics.lambda_long = (avgs_long(end)-avgs_long(1))/(t_clipped_resamp(end)-t_clipped_resamp(101));
        
    end
    
end

