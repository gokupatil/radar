%exp1 : radar range >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
clc; 
clear; 
close all;

% Radar Parameters
Pt = 10e3;             % Transmit power (W)
f = 10e9;              % Frequency (Hz)
G = 10^(30/10);        % Antenna gain 30 dB -> 1000
sigma = 1;             % Target radar cross section (m^2)
L = 10^(6/10);         % System losses 6 dB -> linear ratio
Pmin = 1e-13;          % Minimum detectable power (W)
c = 3e8;               % Speed of light (m/s)
lambda = c / f;        % Wavelength (m)

% Maximum range calculation (Radar Range Equation)
Rmax = ((Pt * G^2 * lambda^2 * sigma) / ((4 * pi)^3 * L * Pmin))^(1/4);
fprintf('Rmax = %.2f km\n', Rmax / 1000);

% Plot 1: Received power vs. range
R = linspace(1, Rmax, 100);
Pr = (Pt * G^2 * lambda^2 * sigma) ./ ((4 * pi)^3 * R.^4 * L);

figure;
subplot(1, 2, 1);
plot(R / 1000, 10 * log10(Pr / 1e-3), 'LineWidth', 1.5);
grid on;
xlabel('Range (km)');
ylabel('Received Power (dBm)');
title('Received Power vs Range');

% Plot 2: Transmit power vs. maximum range
Pt1 = linspace(1e3, 50e3, 100);
R1 = ((Pt1 * G^2 * lambda^2 * sigma) ./ ((4 * pi)^3 * L * Pmin)).^(1/4);

subplot(1, 2, 2);
plot(Pt1 / 1000, R1 / 1000, 'LineWidth', 1.5);
grid on;
xlabel('Transmitter Power (kW)');
ylabel('Maximum Range (km)');
title('Tx Power vs Maximum Range');



%exp 2 : radar dection in noise(roc)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

clc; clear; close all;
N = 10000;                      % number of trials
SNR_dB = [-15 -10 -5 0 5 10 15];
th = 0.5;                       % detection threshold
Pd = zeros(size(SNR_dB)); Pfa = zeros(size(SNR_dB));

for k = 1:length(SNR_dB)
    snr = 10^(SNR_dB(k)/10);    % dB -> ratio
    noise_std = sqrt(1/snr);    % signal power = 1
    present = 1 + noise_std*randn(1,N); % target present = signal + noise
    absent = 0 + noise_std*randn(1,N);  % target absent = noise only
    Pd(k) = mean(present > th);         % fraction above threshold
    Pfa(k) = mean(absent > th);
end

disp(table(SNR_dB', Pd', Pfa', 'VariableNames', {'SNR_dB', 'Pd', 'Pfa'}));
subplot(1,3,1); plot(SNR_dB, Pd, '-o'); grid on;
xlabel('SNR (dB)'); ylabel('Pd'); title('Pd vs SNR');
subplot(1,3,2); plot(SNR_dB, Pfa, '-s'); grid on;
xlabel('SNR (dB)'); ylabel('Pfa'); title('Pfa vs SNR');

% ROC curves (theory, sweep threshold)
x = -1:0.01:2;
subplot(1,3,3); hold on;
for s = [-5 0 10]
    sn = sqrt(1/10^(s/10));
    plot(0.5*erfc(x/(sn*sqrt(2))), 0.5*erfc((x-1)/(sn*sqrt(2))));
end
legend('-5 dB', '0 dB', '10 dB'); grid on;
xlabel('Pfa'); ylabel('Pd'); title('ROC Curves');


% exp3 dopper frequency shift>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
clc; clear; close all;
c = 3e8;

% Part 1: fd vs velocity (fc = 10 GHz)
fc = 10e9; lambda = c/fc;
v = 0:10:100;
fd = 2*v/lambda; % Doppler formula
disp(table(v', fd', 'VariableNames', {'Velocity', 'Doppler_Hz'}));
subplot(1,3,1); plot(v, fd, '-o'); grid on;
xlabel('Velocity (m/s)'); ylabel('Doppler (Hz)');

% Part 2: fd vs carrier frequency (v = 50 m/s)
fc2 = [1 3 5 10 24]*1e9;
fd2 = 2*50./(c./fc2);
disp(table((fc2/1e9)', fd2', 'VariableNames', {'Carrier_GHz', 'Doppler_Hz'}));
subplot(1,3,2); plot(fc2/1e9, fd2, '-s'); grid on;
xlabel('Carrier frequency (GHz)'); ylabel('Doppler (Hz)');

% Part 3: spectrum of a 4000 Hz Doppler signal
fs = 100e3; t = 0:1/fs:0.01-1/fs; N = length(t);
x = cos(2*pi*4000*t) + 0.5*randn(size(t)); % tone + noise
P = abs(fft(x)).^2 / N;                    % power spectrum
f = (0:N-1)*fs/N;                          % frequency axis
subplot(1,3,3); plot(f(1:N/2), P(1:N/2)); xlim([0 10000]); grid on;
xlabel('Frequency (Hz)'); ylabel('Power');


%exp4 mit >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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



exp5 pulse doppler radar target detection >>>>>>>>>>>>>

clc;
clear;
close all;

c = 3e8;
fc = 10e9;
lambda = c/fc;

PRF = 2000;
PRI = 1/PRF;

Np = 128;
Nr = 100;
dR = 100;

ranges = [3000 6000];
vels = [12 -8];

rx = zeros(Nr,Np);

for p = 1:Np
    for k = 1:2
        bin = ranges(k)/dR + 1;
        fd = 2*vels(k)/lambda;
        rx(bin,p) = exp(1j*2*pi*fd*(p-1)*PRI);
    end
end

% Add noise
rx = rx + 0.1*(randn(Nr,Np) + 1j*randn(Nr,Np));

% Doppler FFT
RD = fftshift(fft(rx,[],2),2);

% Axes
vel = (-Np/2:Np/2-1)*PRF/Np*lambda/2;
rangeAxis = (0:Nr-1)*dR;

% Plot
imagesc(vel,rangeAxis,20*log10(abs(RD)));
colormap jet;
colorbar;

xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range-Doppler Map');
ylim([0 8000]);

exp6 radar display>>>>>>>>>>>>>>>>>>>>
clc; clear; close all;
ranges = [30 75 50];    % km
az = [45 120 300];      % degrees
amp = [0.8 0.5 0.9];    % echo strength

% Polar -> Cartesian
x = ranges.*cos(deg2rad(az));
y = ranges.*sin(deg2rad(az));
disp(table((1:3)', ranges', az', x', y', 'VariableNames', {'ID', 'Range_km', 'Azimuth_deg', 'X_km', 'Y_km'}));

% A-scan: amplitude vs range (noise + 3 spikes)
r = 0:0.1:100;
a = 0.05*rand(size(r));
for i = 1:3
    [~, idx] = min(abs(r - ranges(i)));
    a(idx) = amp(i);
end
subplot(2,2,1); plot(r, a, 'g'); grid on;
title('A-Scan'); xlabel('Range (km)'); ylabel('Amplitude');

% B-scan: range vs azimuth
subplot(2,2,3); plot(az, ranges, 'ro'); grid on;
title('B-Scan'); xlabel('Azimuth (deg)'); ylabel('Range (km)');
xlim([0 360]); ylim([0 100]);

% PPI: top view with range rings
subplot(1,2,2); hold on;
th = linspace(0, 2*pi, 100);
for R = 20:20:100
    plot(R*cos(th), R*sin(th), 'k--'); % range rings
end
plot(x, y, 'ro'); axis equal; title('PPI Display');
xlabel('X (km)'); ylabel('Y (km)');

exp7 link budget>>>>>>>>>>>>>>>>>>>>>>
clc; clear; close all;
% [Uplink  Downlink]
f = [14 12];            % frequency (GHz)
d = [36000 36000];      % distance (km)
Pt = [20 10];           % transmit power (W)
Gt = [45 35];           % Tx antenna gain (dBi)
Gr = [30 40];           % Rx antenna gain (dBi)
loss = 2;               % extra losses (dB)
N = -125;               % noise power (dBW)
CN_req = 10;            % required C/N (dB)

EIRP = 10*log10(Pt) + Gt;                   % dBW
FSPL = 92.45 + 20*log10(f) + 20*log10(d);   % free space loss (dB)
Pr = EIRP - FSPL + Gr - loss;               % received power (dBW)
CN = Pr - N;                                % C/N (dB)
margin = CN - CN_req;                       % link margin (dB)

fprintf('EIRP   (dBW): %8.2f %8.2f\n', EIRP);
fprintf('FSPL   (dB) : %8.2f %8.2f\n', FSPL);
fprintf('Pr     (dBW): %8.2f %8.2f\n', Pr);
fprintf('C/N    (dB) : %8.2f %8.2f\n', CN);
fprintf('Margin (dB) : %8.2f %8.2f\n', margin);

% Plot: downlink received power vs distance
dd = linspace(30000, 45000, 100);
pr = EIRP(2) - (92.45 + 20*log10(12) + 20*log10(dd)) + Gr(2) - loss;
plot(dd, pr); grid on;
xlabel('Distance (km)'); ylabel('Received Power (dBW)');
title('Downlink Received Power vs Distance');


exp8  satellite orbit >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
clc;
clear;
close all;

% 1. Earth Parameters
Re = 6371;              % Earth radius (km)
mu = 398600.4418;       % Gravity constant

% 2. Choose Orbit (1 = LEO, 2 = MEO, 3 = GEO)
choice = input('Enter 1 for LEO, 2 for MEO, 3 for GEO: ');

if choice == 1
    alt = 500;          % LEO altitude (km)
    name = 'LEO';
elseif choice == 2
    alt = 20200;        % MEO altitude (km)
    name = 'MEO';
elseif choice == 3
    alt = 35786;        % GEO altitude (km)
    name = 'GEO';
else
    error('Please enter 1, 2, or 3 only');
end

% 3. Calculate Radius and Time Period
r = Re + alt;                           % Total orbit radius (km)
T = 2 * pi * sqrt(r^3 / mu) / 3600;     % Time period in hours
fprintf('%s Orbit | Period: %.2f hours\n', name, T);

% 4. Orbit & Ground Track Coordinates
theta = linspace(0, 2*pi, 200);
x = r * cos(theta);                     % Satellite X
y = r * sin(theta);                     % Satellite Y
z = zeros(size(theta));                 % Satellite Z

gx = Re * cos(theta);                   % Ground track X (on Earth surface)
gy = Re * sin(theta);                   % Ground track Y (on Earth surface)
gz = zeros(size(theta));                % Ground track Z

% 5. Plot Earth, Orbit, and Ground Track in ONE 3D Plot
figure('Color', 'w');
[xe, ye, ze] = sphere(40);
surf(Re*xe, Re*ye, Re*ze, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.6);
hold on;
axis equal;
grid on;

plot3(x, y, z, 'r--', 'LineWidth', 1.5);        % Satellite Orbit
plot3(gx, gy, gz, 'b-', 'LineWidth', 2);        % Ground Track on Earth
sat = plot3(x(1), y(1), z(1), 'ko', 'MarkerFaceColor', 'yellow', 'MarkerSize', 8);

title([name ' Satellite Orbit & Ground Track']);
xlabel('X (km)');
ylabel('Y (km)');
zlabel('Z (km)');
legend('Earth', 'Satellite Orbit', 'Ground Track', 'Satellite');
view(3);

% 6. Animate Satellite Movement
for k = 1:2:200
    set(sat, 'XData', x(k), 'YData', y(k), 'ZData', z(k));
    drawnow;
    pause(0.02);
end



exp9 simulation on system noic s/n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>




clc; clear; close all;
k = 1.38e-23;           % Boltzmann constant (J/K)
C = -100;               % carrier power (dBW)
B = 1e6;                % bandwidth (Hz)
T = 150;                % system noise temperature (K)
G = 35;                 % antenna gain (dBi)

Pn = k*T*B;             % noise power (W)
PndB = 10*log10(Pn);    % noise power (dBW)
CN = C - PndB;          % carrier to noise ratio (dB)
GT = G - 10*log10(T);   % figure of merit (dB/K)

fprintf('Noise Power: %.3g W\n', Pn);
fprintf('Noise Power: %.2f dBW\n', PndB);
fprintf('C/N        : %.2f dB\n', CN);
fprintf('G/T        : %.2f dB/K\n', GT);

Ta = 50:10:500;         % temperature range (K)
Ga = 10:60;             % gain range (dBi)

subplot(2,2,1); plot(Ta, 10*log10(k*Ta*B)); grid on;
title('Noise Temp vs Noise Power'); xlabel('T (K)'); ylabel('dBW');
subplot(2,2,2); plot(Ta, C - 10*log10(k*Ta*B)); grid on;
title('Noise Temp vs C/N'); xlabel('T (K)'); ylabel('dB');
subplot(2,2,3); plot(Ga, Ga - 10*log10(T)); grid on;
title('Antenna Gain vs G/T'); xlabel('Gain (dBi)'); ylabel('dB/K');
subplot(2,2,4); plot(Ta, G - 10*log10(Ta)); grid on;
title('Noise Temp vs G/T'); xlabel('T (K)'); ylabel('dB/K');
