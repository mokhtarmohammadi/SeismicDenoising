clear
clc
close all
load data
%load('J:\real data\first data\realdata_out.mat')
%data=data/max(max(data));
%datan=datan/max(max(data));
cmp=cmp/max(max(cmp));
cmpn=cmp+randn(size(cmp))/6.4;
snrint=snr(cmp,cmpn-cmp)
data=cmp;
datan=cmpn;
clc
plotseis(data)
box on
figure
plotseis(datan)
box on
SNR(data(:),datan(:))


R = 28; M =2; K =1;
Nfft = 625;k=.1;mu=1.5;Nit=40;
penalty_func='atan';
%lam1=0.0375;
%lam2=0.0187;
% lam1=0:0.1:1;
lam1=[0 .01 .1];
lam2=0:0.001:1;
for kk=1:size(data,2)
    y=datan(:,kk);
    s=data(:,kk);
    kk
    for i=1:length(lam1)
        parfor j=1:length(lam2)
            
            de_trace=ISLR_stft_seismic(y,R,M,K,Nfft,k,lam1(i),lam2(j),mu,Nit,penalty_func);
            SSNR(i,j)=SNR(s,de_trace);
        end
    end
    [a,b]=find(SSNR==max(SSNR(:)));
    lam11(kk)=lam1(a)
    lam22(kk)=lam2(b)
    de_trace(:,kk)=ISLR_stft_seismic(y,R,M,K,Nfft,k,lam11(kk),lam22(kk),mu,Nit,penalty_func);
end
% figure
plotseis(de_trace)
% box on
SNR(data(:),de_trace(:))