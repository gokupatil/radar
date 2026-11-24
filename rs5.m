
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
