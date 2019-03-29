clc
clear
snrin1=[-8 -7 -6 -5 -4 -3 -2 -1 1 2 3 4 5 6 7 8];
for k=1:length(snrin1)
    k
    temp=['H:\nunauto\section6\snr',num2str(snrin1(k)),'\matlab.mat']
    load (temp)
  
    timeislr(k)=tic_islr;
    timegod(k)=tic_god;
    timessa(k)=tic_ssa;

end
plot(snrin1,timeislr,snrin1,timegod,snrin1,timessa)