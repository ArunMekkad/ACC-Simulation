% Adaptive Cruise Control System Using Model Predictive Control

% Simulink model
mdl = 'Simulink_model';
open_system(mdl)

% Sample time (seconds)
Ts = 0.25;

% Initial conditions for Lead Car subsystem
pos_lead = 50;    % Initial position (meters)
vel_lead = 26;    % Initial velocity (m/s)

% Initial conditions for Ego Car subsystem
pos_ego = 10;    % Initial position (meters)
vel_ego = 28;    % Initial velocity (m/s)

% Adaptive Cruise Control parameters
time_gap = 1.3;         % Time gap (seconds)
default_spacing = 10;      % Standstill spacing (meters)
v_set = 26;          % Driver-set velocity (m/s)
min_ac = -3.5;       % Min acceleration (m/s^2)
max_ac = 2;        % Max acceleration (m/s^2)

% Gain values
xerr_gain = 0.06;  % Error gain
vx_gain = 5.42;    % Velocity gain
verr_gain = 1.4;

% Configure logging
set_param(mdl, 'SignalLogging', 'on');
set_param(mdl, 'SignalLoggingName', 'logsout');

% Run the simulation
simOut = sim(mdl, 'SimulationMode', 'normal', 'AbsTol', '1e-5', ...
             'SaveState', 'on', 'StateSaveName', 'xoutNew', ...
             'SaveOutput', 'on', 'OutputSaveName', 'youtNew', ...
             'SignalLogging', 'on', 'SignalLoggingName', 'logsout');

% Extract logsout variable from simulation output
logsout = simOut.logsout;

%Calculation of safe distance
ego_velocity = logsout.getElement('EgoVelocity').Values.Data;
safe_distance = default_spacing + (time_gap * ego_velocity);

% Plot the simulation result
figure;
hold on;
plot(logsout.getElement('EgoVelocity').Values.Time, safe_distance, 'r', 'DisplayName', 'Safe Distance');
plot(logsout.getElement('Relative_distance').Values.Time, logsout.getElement('Relative_distance').Values.Data, 'b', 'DisplayName', 'Relative Distance');
xlabel('Time (s)');
ylabel('Position (m)');
title('Position vs. Time');
legend('show');
hold off;

figure;
hold on;
plot(logsout.getElement('Ego_accleration').Values.Time, logsout.getElement('Ego_accleration').Values.Data, 'b', 'DisplayName', 'Ego Car Accleration');
plot(logsout.getElement('ACC_acceleration').Values.Time, logsout.getElement('ACC_acceleration').Values.Data, 'g', 'DisplayName', 'ACC acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s.^2)');
title('Acceleration vs. Time');
legend('show');
hold off;

figure;
hold on;
plot(logsout.getElement('SetVelocity').Values.Time, logsout.getElement('SetVelocity').Values.Data, 'r', 'DisplayName', 'SetVelocity');
plot(logsout.getElement('EgoVelocity').Values.Time, logsout.getElement('EgoVelocity').Values.Data, 'b', 'DisplayName', 'Ego Car Velocity');
plot(logsout.getElement('LeadVelocity').Values.Time, logsout.getElement('LeadVelocity').Values.Data, 'g', 'DisplayName', 'Lead Car Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity vs. Time');
legend('show');
hold off;


