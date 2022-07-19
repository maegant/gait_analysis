function info = getOrbitalStability(info)

for n = 1:length(info)
    % unpack variables
    phase = info(n).phase;
    new_step_flag = info(n).feet.new_step_flag;
    new_step_inds = find(new_step_flag == 1);
    
    %% Orbital Stability (maxFM)
    
    % DESCRIPTION:
    %   - MaxFM<1 indicates that trajectories on average converge and the
    %   system is orbitally stable.
    %   - If maxFM increases, but remains <1, then the system is less orbitally
    %    stable
    %   - quantifies the rate at which all trajectories diverge or converge
    %   from the average trajectory after one complete stride
    
    % IMPORTANT: Take every other step to get a full gait cycle, and update the
    % phase
    switch info(n).feet.stance_foot{new_step_inds(1)}
        case 'Right'
            startInd = 1;
        otherwise
            startInd = 2;
    end
    
    % Need at least 6 complete cycles to analyze (skip first and last step)
    if length(new_step_inds) < 12
        info(n).metrics.fm = [];
        info(n).metrics.maxFM = [];
    else
        
        %     numSteps = 4;
        %     stopInd = startInd+(2*(numSteps-1));
        stopInd = length(new_step_inds)-2;
        
        % get ind corresponding to start, middle, and end of cycle
        new_cycle_inds = new_step_inds(startInd:2:stopInd);
        middle_cycle_inds = new_step_inds(startInd+1:2:stopInd+1);
        end_cycle_inds = new_step_inds(startInd+2:2:stopInd+2)-1;
        
        % get phase corresponding to entire cycle
        cycle_phase = phase;
        for i = 1:length(new_cycle_inds)
            cycle_phase(middle_cycle_inds(i):end_cycle_inds(i)) = phase(middle_cycle_inds(i):end_cycle_inds(i))+phase(middle_cycle_inds(i)-1)+eps;
        end
        
        % Divide data into individual strides and normalize each stride to 0-100%
        % gait cycle
        norm_x = [];
        norm_dx = [];
        %%
        for i = 1:length(new_cycle_inds)
            
            % get current step
            inds = new_cycle_inds(i):end_cycle_inds(i);
            temp_x = info(n).Torso(1:3,inds);
            temp_dx = info(n).Torso(4:6,inds);
            
            temp_phase = cycle_phase(:,inds);
            norm_phase = (temp_phase - temp_phase(1))/(temp_phase(end)-temp_phase(1));
            
            % normalize step to 0-100%
            temp_norm_x = interp1(norm_phase,temp_x',linspace(0,1,101));
            temp_norm_dx = interp1(norm_phase,temp_dx',linspace(0,1,101));
            temp_norm_x = temp_norm_x';
            temp_norm_dx = temp_norm_dx';
            
            %concat each new cycle in dim 3
            norm_x = cat(3,norm_x,temp_norm_x);
            norm_dx = cat(3,norm_dx,temp_norm_dx);
        end
        %%
        
        % At each percent of gait cycle, Poincar\'e map is defined
        % Poincar\'e Map Construction for Time Series Data
        for sel_sec = 1:3 % global roll pitch yaw;
            %             sel_x = norm_x(sel_sec,:,:);
            sel_x = cat(1,norm_x(sel_sec,:,:),norm_dx(sel_sec,:,:));
            
            % assume fixed point is the average x across all steps
            xstar = mean(sel_x,3);
            
            % optional: plot phase portrait at certain phase cycle
            %     figure
            % %     plot3(linspace(0,100,101),xstar(1,:),xstar(2,:),'k','LineWidth',2); hold on;
            %     plot(linspace(0,100,101),xstar(1,:),'k','LineWidth',2); hold on;
            %     alphas = linspace(0.1,1,size(sel_x,3));
            %     for i = 1:size(sel_x,3)
            % %         plot3( linspace(0,100,101),...
            % %             sel_x(1,:,i),...
            % %             sel_x(2,:,i),'Color',[0,0,1,alphas(i)],'LineWidth',2);
            %         plot( linspace(0,100,101),...
            %             sel_x(1,:,i),...
            %           'Color',[0,0,1,alphas(i)],'LineWidth',2);
            %     end
            %     xlabel('percent gait cycle'); ylabel('x'); %zlabel('dx');
            
            % compute Floquet Multiplier from (Hurmuzlu, et al., 1996)
            num_comparisons = size(sel_x,3)-1;
            num_states = size(sel_x,1);
            fm = []; maxfm = [];
            for phasecycle = 1:101
                
                % Compute cycle by cycle differences
                dA = zeros(num_states,num_comparisons); dB = dA;
                for i = 1:num_comparisons
                    for k = 1:num_states
                        dA(k,i) = sel_x(k,phasecycle,i)-xstar(k,phasecycle);
                        dB(k,i) = sel_x(k,phasecycle,i+1)-xstar(k,phasecycle);
                    end
                end
                
                % Solve for the components of the Jacobian using a linear fit of
                % each state: (dx_j^{n+1} = \sum_{k=1}^d J_{k,j} dx_j^n)
                %             options = optimoptions('lsqnonlin','Display','none','Algorithm','levenberg-marquardt');
                %             F = @(x) paramNd(x,dA,dB);
                %             [J,~] = lsqnonlin(F,zeros(num_states,num_states),[],[],options);
                
                % Solve for J using equation: dB = JdA
                % (Only works when num_states = 1)
                J = (dA*dA')\dB*dA';
                
                fm(:,phasecycle) = abs(real((eig(J))));
                maxfm(phasecycle) = max(fm(:,phasecycle));
            end
            
            info(n).metrics.fm{sel_sec} = fm;
            info(n).metrics.maxFM{sel_sec} = maxfm;
            
        end
        
    end
end
end

%% For solving for jacobian
function F = paramNd(x,dA,dB)
for i = 1:size(x,1)
    F(i,:) = dB(i,:) - sum(x(:,i)*dA(i,:),1);
end
end
