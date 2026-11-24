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