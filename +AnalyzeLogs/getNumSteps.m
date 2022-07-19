function info = getNumSteps(info)
all_sets = {'least_preferred_gaits','random_gaits','most_preferred_gaits'};

num_steps = [];
total_time = [];

for s = 1:length(info)
    
    for set =   1:3 %go through each set condition
        
        for n = 1:length(info{s}.(all_sets{set})) %go through all logs for that set
            
            cur_gait = info{s}.(all_sets{set})(n);
            if cur_gait.num_steps > 5
                num_steps = cat(2,num_steps,cur_gait.num_steps);
                total_time = cat(2,total_time,cur_gait.time(end));
            end
            
        end
        
    end
    
end

fprintf('Num Steps:  %2.2f ± %2.2f \n',mean(num_steps), std(num_steps));
fprintf('Total Time:  %2.2f ± %2.2f \n',mean(total_time), std(total_time));

end
