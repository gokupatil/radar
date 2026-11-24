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