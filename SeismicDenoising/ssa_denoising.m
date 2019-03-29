function [DenData]=ssa_denoising(NoisyData,dt,Rank,high_freq_cut)
%%% Denoising Using Singular Spectrum Analysis for a Linear Event  %%%
%%% Saman gholtashi,Amir Nazari - 94/02/02 %%%
clc 
%% Rank indicated in line 21 and frequency boundaries in line 36. input data substitute by DD in line 25.

%% Input Parameters
[N,NumCol]=size(NoisyData);
t=0:dt:(N-1)*dt;
FMat = zeros( N , NumCol );
FMatR = zeros( N , NumCol );
FMatI = zeros( N , NumCol );
Nf = 2 ^ nextpow2( N );

%% First and Last Samples of the FFT
FreqLow = 0;
FreqHigh = high_freq_cut;

IndexLow = floor( FreqLow * dt * Nf ) + 1; 
if IndexLow < 1, IndexLow = 1; end

IndexHigh = floor( FreqHigh * dt * Nf ) + 1;
if IndexHigh > floor( Nf / 2 ) + 1; IndexHigh = floor( Nf / 2 ) + 1; end

%% Transform to FX domain by Applying FFT
FFTMat = fft( NoisyData , Nf , 1 );
% FFTMat = fft( Data , Nf , 1 );

%% Singular Spectrum Analysis
for k = IndexLow : IndexHigh;
%     Temp = abs( FFTMat( k , : ) );
    TempR = real( FFTMat( k , : ) );
    TempI = imag( FFTMat( k , : ) );
%     FMatAbs( k , : ) = SSAFUNC( Temp , floor( length( Temp ) / 2 ) + 1 , Rank );
    FMatR( k , : ) = SSAFUNC( TempR , floor( length( TempR ) / 2 ) + 1 , Rank );
    FMatI( k , : ) = SSAFUNC( TempI , floor( length( TempI ) / 2 ) + 1 , Rank );
end

FMatPhase = angle( FFTMat( IndexLow : IndexHigh , : ) );
FMat = FMatR + 1i .* FMatI ;
% FMat = FMatAbs .* exp( 1i .* FMatPhase );

clear Temp k IndexHigh IndexLow FreqLow FreqHigh RickerParam
%% Honor symmetries
for k = Nf / 2 + 2 : Nf
    FMat( k , : ) = conj( FMat( Nf - k + 2 , : ) );
end
clear k Nf
%% Back to TX (the output) 
DenData = real( ifft( FMat , [] , 1 ) );
DenData = ( DenData( 1 : N , : ) );
% out_snr=snr(CleanData,DenData-CleanData)
