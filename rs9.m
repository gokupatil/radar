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