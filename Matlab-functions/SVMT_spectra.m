function [out] = SVMT_spectra(data,info,blocksize)
% =========================================================================
% [out] = SMVT_spectra(data, info, blocksize)
% =========================================================================
% Frequency analysis tool for measurement data measured with the SVMT 
% Toolbox / NI Hardware.
% The code is partly adapted from the TriggerHappyRealTimev40.m measurement
% script.
%
% =========================================================================
% INPUT: 
% =========================================================================
% data - matrix containing measurement data (# samples x Nchannels)
% info - info struct containing the information 
%                 info.fs - samplingfrequency
%                 info.calibration - vector containing calibration values
%                 (1 x Nchannels)
% blocksize - blocksize used for fourier transform. If not specified it
%                 defaults to 'inf'. 
%                 If specified as 'inf', the complete available signal is
%                 treated as one block.
% 
% =========================================================================
% OUTPUT: (All data output in single structure)
% =========================================================================
% f - Frequency vector for the single-sided spectra
%
% AS(:,i,j)  -  Matrix of the time-averaged double sided auto- and 
%               cross-spectra.
%               DS(:,i,i) gives the autospectrum of channel i.
%               DS(:,i,j) gives the cross-spectrum between channel i and j.
%               It contains the squared top-amplitudes.
%                   (blocksize x Nchannel x Nchannel)
%
% AD(:,i,j)  -  Matrix of the time-averaged single sided spectra. Same
%               structure as AD. It contains the squared rms-amplitudes.
%                   (Na x Nchannel x Nchannel)
%
% HS(:,i,j)  -  Matrix of all single-sided H1 estimate of the frequency 
%               responsefunctions. HS(:,i,j) gives the transfer function 
%               between channel i and j, i.e. the autospectrum of channel i 
%               is in the denominator. 
%                   (Na x Nchannel x Nchannel)
% 
% HD(:,i,j)  -  same as HS, but double sided 
%                   (blocksize x Nchannel x Nchannel)
% 
% gamma2(:,i,j)-Matrix of all coherence functions. gamma2(:,i,j)
%               gives the coherence function between channel i and j.
%                   (Na x Nchannel x Nchannel)

% =========================================================================
% Input data from measurement
% =========================================================================
fs = info.fs; % sampling frequency
C = info.calibration; % calibration values
if nargin < 3 % use default blocksize if not specified
    blocksize = inf;
end

% Some input data checking
if blocksize == inf
    blocksize = size(data,1);
elseif length(data(:,1)) < blocksize
    error('The blocklength exceeds the input data, please decrease blocklength or increase measurement time or sampling frequency')
end
if length(info.calibration) ~= size(data,2)
    error('The calibration values do not match the number of input channels. Please make sure the measurement data fits the info struct.')
end
    
% =========================================================================
% Initial setup
% =========================================================================
% Frequncy resolution
df = fs/blocksize;
% Building frequency axis
f = (0:blocksize-1)*df;
% Number of channels stored in the data matrix
Nchannel = size(data,2);
% Number of complete blocks contained in the data matrix
Nblocks = floor(length(data(:,1))/blocksize); 

% =========================================================================
% Calibration
% =========================================================================
data_c = zeros(size(data));
% applying calibration
for channel = 1:Nchannel
    data_c(:,channel) = data(:,channel) / C(channel);
end

% =========================================================================
% Windowing
% =========================================================================
% Setting up the window and scaling
window = hann(blocksize);
% this matrix contains the same window for each channel
window_matrix = window(:,ones(1,Nchannel));
% Energy-preserving scaling
windowscaling = sqrt(sum(window.^2)/blocksize);

% =========================================================================
% Averaging the autospectrum and cross spectrum
% =========================================================================
% loop through data signal
S = zeros(blocksize, Nchannel, Nchannel);
for Nblock = 1:Nblocks
    block = data_c((Nblock-1)*blocksize+1:Nblock*blocksize, 1:Nchannel);
    X1 = block .* window_matrix / windowscaling;
    % fourier transform
    Sx = fft(X1)/blocksize;
    
    % Calculating instantaneous double-sided auto- and cross-spectra
    for i1=1:Nchannel
        for i2=1:Nchannel
            S(:,i1,i2)=conj(Sx(:,i1)).*Sx(:,i2);
        end
    end
    
    % Averaging double sided auto- and cross-spectra
    if Nblock==1
        AD = S;
    else
        AD = AD - (AD - S)/Nblock;
    end
end

% =========================================================================
% Calculating the single sided rms spectra and its frequency vector
% =========================================================================
% Compute number of alias protected frequency components
Na = floor(blocksize/2.56) + 1;

AS(1,:,:) = AD(1,:,:);
AS(2:Na,:,:) = 2*AD(2:Na,:,:);
fa = f(1:Na);

% =========================================================================
% FRF Matrix HSxy (single-sided) and HDxy (double-sided)
% =========================================================================
% Preallocation of frequency response matrix
HS = zeros(Na,Nchannel,Nchannel);
% Calculating frequency response functions
for i1=1:Nchannel
    for i2=1:Nchannel
        % H1 estimator
        HS(:,i1,i2)  = AS(:,i1,i2) ./ AS(:,i1,i1);
        % H2 estimator
        % HS(:,i1,i2)  = AS(:,i2,i2) ./ AS(:,i2,i1);
    end
end

HD = zeros(blocksize,Nchannel,Nchannel);
% Calculating frequency response functions
for i1=1:Nchannel
    for i2=1:Nchannel
        % H1 estimator
        HD(:,i1,i2)  = AD(:,i1,i2) ./ AD(:,i1,i1);
        % H2 estimator
        % HD(:,i1,i2)  = AD(:,i2,i2) ./ AD(:,i2,i1);
    end
end

% =========================================================================
% Coherence Matrix gamma2xy
% =========================================================================
% Preallocation of coherence matrix
gamma2 = zeros(Na,Nchannel,Nchannel);
% Calculating coherence functions
for i1=1:Nchannel
    for i2=1:Nchannel
        gamma2(:,i1,i2)=AS(:,i1,i2).*AS(:,i2,i1)./AS(:,i1,i1)./AS(:,i2,i2);
    end
end
out.AS = AS;
out.AD = AD;
out.HS = HS;
out.HD = HD;
out.gamma2 = gamma2;
out.f = fa;