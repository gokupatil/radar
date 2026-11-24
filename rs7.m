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