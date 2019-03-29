% Author Rasoul Anvari
% Average amplitude spectrum of  noise-free,  noisy, and filtered synthetic seismic data via the (c) proposed
% algorithm,  SSWT-GoDec method and classical f-x SSA techniques.
close all
clc
freq=(1/dt)*(0:size(cmp,1)-1)/size(cmp,1);
A_free=sum(abs(fft(cmp)),2)/size(cmp,2);
A_noisy=sum(abs(fft(cmpn)),2)/size(cmpn,2);
A_den_trace=sum(abs(fft(den_trace)),2)/size(den_trace,2);
A_god_out=sum(abs(fft(god_out)),2)/size(god_out,2);
A_ssa=sum(abs(fft(ssa_out)),2)/size(ssa_out,2);
% A_free=A_free/max(A_free);
% A_noisy=A_noisy/max(A_noisy);
% A_opt=A_opt/max(A_opt);
% A_god=A_god/max(A_god);
% A_ssa=A_ssa/max(A_ssa);
subplot(3,2,1)
plot(freq,A_free)
ylabel('Amplitude','FontSize',20)
subplot(3,2,2)
plot(freq,A_noisy)
ylabel('Amplitude','FontSize',20)
subplot(3,2,3)
plot(freq,A_den_trace)
ylabel('Amplitude','FontSize',20)
subplot(3,2,4)
plot(freq,A_god_out)
ylabel('Amplitude','FontSize',20)
subplot(3,2,5)
plot(freq,A_ssa_out)
ylabel('Amplitude','FontSize',20)
xlim([0 120])
xlabel('Frequency (Hz)','FontSize',20)
ax = gca;
ax.FontSize=20;
