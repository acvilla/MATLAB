% Create transfer function of Converter based on analytical model
% Variable Description (Unit)
R = 1; % Load Resistance (Ohms)
Rf = 0.1;
C = 100e-6; % Output Filter Capacitance (Farads)
L = 10e-6; % Output Filter Inductance (Henries)
rc = 0.01; % Filter Capacitor ESR (Ohms)
V = 13.97; % Output Voltage (Volts)
d = 0.46566; % Steady-State Duty Cycle
Fm = 0.09898;
Gvd = tf((V/d)*[rc*C, 1],[L*C*(R+rc)/R, (L/R) + (rc*C),1]) % Gvd of Converter, derived analytically
Gid = tf((V/d)*[C*(R+rc), 1],R*[L*C*(R+rc)/R, (L/R) + (rc*C),1]) % Gid of Converter, derived analytically
%[Gm,Pm,Wcg,Wcp] = margin(H);
Gvc = tf((Fm*V/d)*[rc*C, 1], Rf*[L*C*(R+rc)/R, (L/R) + (rc*C) + Fm*V*C*(R+rc)/(d*R),(1 + Fm*V/(d*R))])
% Open and Parse LTSPICE ac analysis results text file
fidi = fopen('Gvc_SyncBuck_average_CPM');
cell = textscan(fidi, '%f(%fdB,%f°)', 'CollectOutput',1);
D = cell2mat(cell);
freq = D(:,1);
mag = D(:,2);
ph = D(:,3);
wout = 2*pi*freq;
[mag_tf, ph_tf, wout] = bode(Gvc, wout); % Extract data from analytical transfer function
bode(Gvc)
mag_tf = squeeze(mag_tf);
ph_tf = squeeze(ph_tf);
mag_tf = mag2db(abs(mag_tf)); % Converter magnitude value to decibels


% Plot the results for comparison between analytical expression and
% simulations
figure
subplot(2,1,1)
semilogx(freq, mag)
hold on
semilogx(freq, mag_tf)
hold off
title('Amplitude (dB)')
grid
legend('LTSPICE','MATLAB')
subplot(2,1,2)
semilogx(freq, ph)
hold on
semilogx(freq, ph_tf)
hold off
title('Phase (°)')
grid
xlabel('Frequency')
legend('LTSPICE','MATLAB')
%Hout = freqresp(H, wout);
%mag = abs(Hout);
close(figure)
