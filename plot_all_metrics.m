%% Load stored data
all_subjects = cell(1,8);
for s = 1:8
   sub_to_load = sprintf('Validation_Subject%i.mat',s);
   subject_gait_info = load(fullfile('Processed Logs',sub_to_load),'-mat','gait_info'); 
   all_subjects{s} = subject_gait_info.gait_info;
end

%% Stability Metric Processing
all_sets = {'least_preferred_gaits','random_gaits','most_preferred_gaits'};
for s = 1:8
    for i = 1:3 
        
        set = all_sets{i};
        fprintf('Processing %s of Subject %i   \n',all_sets{i},s);
        all_subjects{s}.(set) = AnalyzeLogs.getDynamicity(all_subjects{s}.(set));
        all_subjects{s}.(set) = AnalyzeLogs.getDeviation(all_subjects{s}.(set));
        all_subjects{s}.(set) = AnalyzeLogs.getOrbitalStability(all_subjects{s}.(set));
        all_subjects{s}.(set) = AnalyzeLogs.getLocalStability(all_subjects{s}.(set));
        all_subjects{s}.(set) = AnalyzeLogs.getGRF(all_subjects{s}.(set));
        all_subjects{s}.(set) = AnalyzeLogs.getMCOT(all_subjects{s}.(set));
        
    end
end

%% Print out approximate number of steps:
all_subjects = AnalyzeLogs.getNumSteps(all_subjects);

%% Create Folder to store Figures
if ~isfolder('Figures')
    mkdir('Figures');
end

%% Plot Orbital Stability
f = PlotLogs.plotOrbitalStability(all_subjects);                               
print(f(1),fullfile('Figures','orbital_stability_roll.png'),'-dpng');
print(f(2),fullfile('Figures','orbital_stability_pitch.png'),'-dpng');
print(f(3),fullfile('Figures','orbital_stability_yaw.png'),'-dpng');

%% Plot Local Divergence Exponents
f = PlotLogs.plotLocalStability(all_subjects);
print(f(1),fullfile('Figures','shortterm_divergence.png'),'-dpng');
print(f(2),fullfile('Figures','longterm_divergence.png'),'-dpng');

%% Plot mean Standard Deviation
f = PlotLogs.plotDeviation(all_subjects);
print(f(1),fullfile('Figures','meanSD_roll.png'),'-dpng');
print(f(2),fullfile('Figures','meanSD_pitch.png'),'-dpng');
print(f(3),fullfile('Figures','meanSD_yaw.png'),'-dpng');
print(f(4),fullfile('Figures','meanSD_xvel.png'),'-dpng');
print(f(5),fullfile('Figures','meanSD_yvel.png'),'-dpng');
print(f(6),fullfile('Figures','meanSD_zvel.png'),'-dpng');

%% Plot mechanical cost of transport
f = PlotLogs.plotMCOT(all_subjects);
print(f(1),fullfile('Figures','mcot.png'),'-dpng');

%% Plot dynamicity
f = PlotLogs.plotDynamicity(all_subjects);
print(f(1),fullfile('Figures','dynamicity.png'),'-dpng');

%% Plot Average Speed
f = PlotLogs.plotSpeed(all_subjects);
print(f(1),fullfile('Figures','speed.png'),'-dpng');
print(f(2),fullfile('Figures','stepcadence.png'),'-dpng');

%% Plot GRF at Impact
f = PlotLogs.plotImpact(all_subjects);
print(f(1),fullfile('Figures','grf_x.png'),'-dpng');
print(f(2),fullfile('Figures','grf_y.png'),'-dpng');
print(f(3),fullfile('Figures','grf_z.png'),'-dpng');
print(f(4),fullfile('Figures','grm_x.png'),'-dpng');
print(f(5),fullfile('Figures','grm_y.png'),'-dpng');
print(f(6),fullfile('Figures','grm_z.png'),'-dpng');
print(f(7),fullfile('Figures','grf_norm.png'),'-dpng');
print(f(8),fullfile('Figures','grf_z_cycle.png'),'-dpng');

%% Plot Average and Std Torso Motion
f = PlotLogs.plotTorso(all_subjects);
print(f(1),fullfile('Figures','torso_mean_roll.png'),'-dpng');
print(f(2),fullfile('Figures','torso_mean_pitch.png'),'-dpng');
print(f(3),fullfile('Figures','torso_mean_yaw.png'),'-dpng');
print(f(4),fullfile('Figures','torso_std_roll.png'),'-dpng');
print(f(5),fullfile('Figures','torso_std_pitch.png'),'-dpng');
print(f(6),fullfile('Figures','torso_std_yaw.png'),'-dpng');

%% Plot Cost of Dynamicity
f = PlotLogs.plotCOD(all_subjects);
print(f(1),fullfile('Figures','cost_of_dynamicity.png'),'-dpng');

%% Plot Number of Steps 
f = PlotLogs.plotnumSteps(all_subjects);
print(f(1),fullfile('Figures','num_steps.png'),'-dpng');
