% Experiment: MTI Radar Simulation with Clutter, Stationary Target & Moving Target
clc;
clear;
close all;

%% 1. Radar Range / Distance Axis
range = 0:0.1:100; % Range axis from 0 to 100 km (resolution: 0.1 km)

%% 2. Define Individual Signal Components
% (A) Stationary Clutter: Distributed, broad environmental reflections (at 20 km & 75 km)
clutter_sweep1 = 8 * exp(-((range - 20)/2.5).^2) + ...
    6 * exp(-((range - 75)/3).^2);
clutter_sweep2 = clutter_sweep1; % Clutter remains completely identical in Sweep 2

% (B) Stationary Target: Point target with zero velocity (fixed tower at 50 km)
stat_target_sweep1 = 7 * exp(-((range - 50)/1.2).^2);
stat_target_sweep2 = 7 * exp(-((range - 50)/1.2).^2); % Fixed position in Sweep 2

% (C) Moving Target: Point target changing position due to velocity (moves from 35 km to 40 km)
mov_target_sweep1 = 7 * exp(-((range - 35)/1.2).^2);
mov_target_sweep2 = 7 * exp(-((range - 40)/1.2).^2); % Shifted position in Sweep 2

%% 3. Combine into Composite Radar Sweeps
% Sweep 1 (Current Pulse Echo)
sweep1 = clutter_sweep1 + stat_target_sweep1 + mov_target_sweep1;

% Sweep 2 (Delayed Pulse Echo after 1 PRI)
sweep2 = clutter_sweep2 + stat_target_sweep2 + mov_target_sweep2;

%% 4. Apply Single Delay Line Canceller
% Output = |Sweep 1 - Sweep 2|
mti_output = abs(sweep1 - sweep2);

%% 5. Plotting (A-Scope Waveform Representation)
figure('Name', 'MTI Radar: Clutter vs Stationary vs Moving', 'Color', 'w');

% Plot 1: First Sweep Echo x[n]
subplot(3, 1, 1);
plot(range, sweep1, 'b', 'LineWidth', 1.5);
title({'1. Sweep 1: Clutter (20, 75 km), Stationary Target (50 km), Moving Target (35 km)'});
xlabel('Distance / Range (km)');
ylabel('Amplitude (V)');
ylim([0, 10]);
grid on;

% Plot 2: Delayed Second Sweep Echo x[n+1]
subplot(3, 1, 2);
plot(range, sweep2, 'r', 'LineWidth', 1.5);
title({'2. Sweep 2 (Delayed): Clutter & Stationary Target Unchanged, Moving Target Shifted to 40 km'});
xlabel('Distance / Range (km)');
ylabel('Amplitude (V)');
ylim([0, 10]);
grid on;

% Plot 3: Delay Line Canceller Output y[n]
subplot(3, 1, 3);
plot(range, mti_output, 'g', 'LineWidth', 1.5);
title({'3. MTI Output: Clutter & Stationary Targets Cancelled (0 V), Only Moving Target Detected'});
xlabel('Distance / Range (km)');
ylabel('Amplitude (V)');
ylim([0, 10]);
grid on;