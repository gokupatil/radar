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