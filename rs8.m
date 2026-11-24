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