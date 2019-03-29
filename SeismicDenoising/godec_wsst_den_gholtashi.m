function den_trace = godec_wsst_den_gholtashi(in_trace,t,voiceperoctave,gamma,wav_type,r,l,p,iter)
%% Alg3 - Denoising Using Singular Spectrum Analysis and RPCA for a Linear Event  %%%
%% Amir Nazari - 94/02/02 %%%
% clc, 
% clear all

%% Input Parameters
% prompt = {'Ricker Parameters:[ dt fdom tlength ]','Num. of Traces:',...
%     'Num. of Samples:','SNR:','Scale:','Sigma','Rank:','Add Noise Method:(1 or 0)','Mean and Sigma:[ mu s ]','Num. of Voices:'};
% dlg_title = 'Input Parameters';
% num_lines = 1;
% def = {'[ 0.002 35 50 ]','40','250','-4','1','0.02','8','1','[0 .65]','16'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% 
% RickerParam = str2num(answer{1});
% NumCol = str2double(answer{2});
% N = str2double(answer{3});
% SNR = str2double(answer{4});
% Scale = str2double(answer{5});
% Sigma = str2double(answer{6});
% Rank = str2double(answer{7});
% AddN = str2double(answer{8});
% MandS = str2num(answer{9});
% nv = str2double(answer{10});
% mu = MandS(1); s = MandS(2);

% [N NumCol]=size(Data);
% addpath(genpath('D:\Informations Needed for my Thesis\Denoising Method - Simulations and Word File\Methods\8) SSA Denoising Method\Code RPCA'));
dt = t(2)-t(1);
N=length(in_trace);
NumCol=1;
%gamma estimation 
[Tx, fs, Wx, as, w] = synsq_cwt_fw(t,in_trace, voiceperoctave);
[Wx,as,dWx,xMean] = cwt_fw(in_trace,wav_type,voiceperoctave,dt);
% gamma = est_riskshrink_thresh(Wx, voiceperoctave);
opt.gamma=gamma;
opt.type=wav_type;
%% Transform to FX domain by Applying FFT

SSTMat=zeros(length(fs),N,NumCol);
for i = 1 : NumCol
    [SSTMat( : , : , i )] = synsq_cwt_fw(t,in_trace,voiceperoctave,opt);
end
%% nmf
for i=1:NumCol
    TempAbs(:,:) = abs( SSTMat(:,:,i ));
    TempPh(:,:) = angle( SSTMat(:,:,i )) ;
    [L,S,~,~]=SSGoDec(TempAbs,r,l,p,iter);
    SSTMatNew(:,:,i)=L.*exp(1i.*TempPh);
    
end
%% Back to TX (the output) 
for i = 1 :NumCol
    Temp = synsq_cwt_iw(SSTMatNew(:,:,i), fs);
    DenData( :, i ) = (Temp(1,:));
end
for i = 1 : NumCol
    [SSTMatrec( : , : , i )] = synsq_cwt_fw(t,DenData(:,i),voiceperoctave);
end
for i = 1 :NumCol
    Temp = synsq_cwt_iw(SSTMatrec(:,:,i), fs);
    DenData( :, i ) = (Temp(1,:));
end

den_trace=DenData;
% den_trace=(den_trace./max(max(den_trace))).*max(max(in_trace));
