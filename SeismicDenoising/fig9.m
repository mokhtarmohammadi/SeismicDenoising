% Output-input SNRs for the proposed, SSWT-GoDec and classical f-x SSA methods for different input SNRs in
% synthetic seismic section is calculated and result aere saved. we loade
% the results by the this pasu-code and plot the out put snr 
clc
clear
snrin1=[-8 -7 -6 -5 -4 -3 -2 -1 1 2 3 4 5 6 7 8];
for k=1:length(snrin1)
    k
    temp=['H:\nunauto\section6\snr',num2str(snrin1(k)),'\matlab.mat']
    load (temp)
    snrislr(k)=ISLr_snr;
    snrgod(k)=god_snr;
    snrssa(k)=ssa_snr;  
end
plot(snrin1,snrislr,snrin1,god_snr,snrin1,snrssa)