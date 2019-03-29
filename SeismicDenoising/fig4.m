% The recovered seismic signal using ISLR method and  SSWT-GoDec
% ISLR method
% inpu parameters
R = 30; M =2; K =2.5; Nfft = 350;k=.01;mu=1.5;Nit=40;penalty_func='atan';
%% gride search for lam1 and lam2 
%This code write By Rasoul Anvari 
for i=1:length(lam1)
    for j=1:length(lam2)
        [i,j]
        de_trace=ISLR_stft_seismic(y,R,1,M,K,Nfft,k,lam1(i),lam2(j),mu,Nit,penalty_func);
        SSNR(i,j)=SNR(s',de_trace);
    end
end
[a,b]=find(SSNR==max(SSNR(:)));
lam11=lam1(a)
lam22=lam2(b)
%denoising by sutible parameter lam2 and lam1 
de_trace=ISLR_stft_seismic(y,R,1,M,K,Nfft,k,lam1,lam2,mu,Nit,penalty_func);
SNR(s(:),de_trace(:))
%% denoising by WSST_GODec
% inpu parameters
[n,m]=size(y);
t=(0:m-1)*dt;
voiceperoctave=16;
wav_type='bump';
p=90;iter=150;r=5;
  l=mad(y);  
god_out=godec_wsst_den_gholtashi(y,t,voiceperoctave,gamma,wav_type,r,l,p,iter);
%% average Amplitude
freq=(1/dt)*(0:size(c,2)-1)/size(c,2);
A_de_trace=sum(abs(fft(de_trace)),1)/size(c,2);
A_god_out=sum(abs(fft(god_out)),1)/size(c,2);

%% 
figure;
subplot(2,3,1)
plot(dt*(0:size(de_trace,2)-1),de_trace)
subplot(2,3,2)
plot(dt*(0:size(de_trace,2)-1),c-de_trace)
subplot(2,3,3)
plot(freq,A_de_trace)
subplot(2,3,4)
plot(dt*(0:size(c,2)-1),god_out)
subplot(2,3,5)
plot(dt*(0:size(c,2)-1),c-god_out)
subplot(2,4,6)
plot(freq,A_god_out)
