%Author Rasoul Anvari
% in this code Synthetic seismic trace that is composed of four zero-phase Ricker wavelets with dominant frequency 35 Hz at
% 0:11s; 0:37s; 0:4s and 0:54s, respectively
dt=.002;
c=15;
wav=ricker(dt,35);
t=zeros(1,330);
t(60)=.7;;t(180)=.9;t(195)=.9;t(270)=.5;
c=conv(t,wav,'same');
c=c./max(max(c));
%% noisy signal
SNR = @(x,y) 10 * log10(sum(abs(x).^2)/sum(abs(x-y).^2));
sigma = 1/3.18;
randn('state',201314);
y = c + sigma*randn(size(c));
snr_int=SNR(c,y);
%% average Amplitude
freq=(1/dt)*(0:size(c,2)-1)/size(c,2);
A_free=sum(abs(fft(c)),1)/size(c,2);
A_noisy=sum(abs(fft(y)),1)/size(y,2);
%% 
figure;
subplot(2,2,1)
plot(dt*(0:size(c,2)-1),c)
subplot(2,2,2)
plot(freq,A_free)
subplot(2,2,3)
plot(dt*(0:size(c,2)-1),y)
subplot(2,2,4)
plot(freq,A_noisy)






