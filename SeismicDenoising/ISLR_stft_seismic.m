function de_trace=ISLR_stft_seismic(in_trace,R,M,K,Nfft,k,lam1,lam2,mu,Nit,penalty_func)
N = length(in_trace); 
n = 0:N-1;
[AH, A, normA] = MakeTransforms('STFT',N,[R M K Nfft]);
% As = A(s);
Ay = A(in_trace);
% pen='pen_type';
[Ax, cost] = lrs_single(Ay,k,lam1,lam2,mu,penalty_func,Nit); 
de_trace = ipSTFT2(Ax,R,M,1,N);
de_trace=real(de_trace);



