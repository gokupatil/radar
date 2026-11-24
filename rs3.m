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