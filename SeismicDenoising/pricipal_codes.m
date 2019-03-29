clear all
clc
close all
load data
% cmpn=cmp+randn(size(cmp))/11;
% snrin=snr(cmp,cmpn-cmp);
voiceperoctave=16;
% gamma=0.068;
wav_type='bump';
Rank=1;
high_freq_cut=100;
% l=mad(cmpn);
p=80;
iter=100;
%%%%%%%%%%%%%%%%
[m,n]=size(cmp);
t=(0:m-1)*dt;
tic
for i=1:n
    i
    god_out(:,i) = godec_wsst_den_gholtashi(cmpn(:,i),t,voiceperoctave,wav_type,r,.00005,p,iter);
end
tic_god=toc;
tic
[ssa_out]=ssa_denoising(cmpn,dt,Rank,high_freq_cut);
tic_ssa=toc;
god_snr=snr(cmp,god_out-cmp);
ssa_snr=snr(cmp,ssa_out-cmp);
% mkdir('C:\sers\rasoulanvari\Documents\section5',['snr',num2str(round(snrin))])
% save(['C:\Users\rasoulanvari\Documents\section5\snr',num2str(round(snrin)),'\matlab'])