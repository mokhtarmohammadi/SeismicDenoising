% Author Rasoul Anvari
% The denoised synthetic section and their difference with original synthetic cmp by using the  proposed method,
%  SSWT-GoDec method and classical f-x SSA
clc
clear
close all
fs = 250;
load sec.mat
cmpn=cmp+randn(size(cmp))/11;
snrin=snr(cmp,cmpn-cmp);
%SSA parameters
Rank=1;
high_freq_cut=100;
% WSST-GoDec Parameters
l=mad(cmpn);
p=80;
iter=100;voiceperoctave=16;
% gamma=0.068;
wav_type='bump';

%%%%%%%%%%%%%%%%
[m,n]=size(cmp);
t=(0:m-1)*dt;
% ISLR parameters
N = length(cmpn(:,1)); 
n = 0:N-1;
R = 21; M =3; K =1; Nfft =550;k=.4;mu=3;
Nit=40;penalty_func='atan';
%% % lam1 and lam2 obtained By Gride search for any input Snr
% gride search
lam1=[0 .01 .1];
lam2=0:0.001:1;
for kk=1:size(cmpn,2)
    y=cmpn(:,kk);
    s=cmp(:,kk);
    kk
    for i=1:length(lam1)
        parfor j=1:length(lam2)
            
            de_trace=ISLR_stft_seismic(y,R,M,K,Nfft,k,lam1(i),lam2(j),mu,Nit,penalty_func);
            SSNR(i,j)=SNR(s,de_trace);
        end
    end
    [a,b]=find(SSNR==max(SSNR(:)));
end

%% 
lam1=0.3;lam2=.03;
SNR = @(x,y) 10 * log10(sum(abs(x).^2)/sum(abs(x-y).^2));
[m,n]=size(cmp);
tic
for i=1:n
de_trace(:,i)=ISLR_stft_seismic(cmpn(:,i),R,M,K,Nfft,k,lam1,lam2,mu,Nit,penalty_func);
end
tic_islr=toc;
tic
for i=1:n
    i
    god_out(:,i) = godec_wsst_den_gholtashi(cmpn(:,i),t,voiceperoctave,wav_type,r,.00005,p,iter);
end
tic_god=toc;
tic
[ssa_out]=ssa_denoising(cmpn,dt,Rank,high_freq_cut);
tic_ssa=toc;
%% 
u=
subplot(1,2,1)
plotseis(den_trace,(0:size(den_trace,1)-1)*dt,1:size(den_trace,2),[],[1.5 u],1,1,[.1,0,0]) 
title('filtered') 
subplot(1,2,2)
plotseis(cmp-den_trace,(0:size(cmp-den_trace,1)-1)*dt,1:size(cmp-den_trace,2),[],[1.5 u],1,1,[0.1,0,0]) 
title('difrence')
%% 
figure
subplot(1,2,1)
plotseis(ssa_out,(0:size(ssa_out,1)-1)*dt,1:size(ssa_out,2),[],[1.5 u],1,1,[.1,0,0]) 
title('filtered') 
subplot(1,2,2)
plotseis(data-ssa_out,(0:size(data-ssa_out,1)-1)*dt,1:size(data-ssa_out,2),[],[1.5 u],1,1,[0.1,0,0]) 
title('difrence')
%% 
subplot(1,2,1)
plotseis(god_out,(0:size(god_out,1)-1)*dt,1:size(god_out,2),[],[1.5 u],1,1,[.1,0,0]) 
title('filtered') 
subplot(1,2,2)
plotseis(data-god_out,(0:size(data-god_out,1)-1)*dt,1:size(data-god_out,2),[],[1.5 u],1,1,[0.1,0,0]) 
title('difrence')



% SNR(cmp,cmpn)
ISLr_snr=SNR(cmp,de_trace)
god_snr=snr(cmp,god_out-cmp);
ssa_snr=snr(cmp,ssa_out-cmp);
