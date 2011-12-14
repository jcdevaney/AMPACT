function [coefs approx] = noteDct(x, Ndct, sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [coefs approx] = noteDct(x, Ndct, sr)
%
% Description: Compute the DCT of a signal and approximate it with the 
%              first Ndct coefficients  x is the signal  Ndct is the number 
%              of DCT coefficients to be calculated sr is the sampling rate 
%              of the signal
%
% Inputs:
%  x - signal to be analyzed
%  Ndct - number of DCT coefficients to be calculated
%  sr - sampling rate
%
% Outputs:
%  coefs - DCT coefficients
%  approx - reconstruction of X using the Ndct number of DCT coefficients
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate DCT coefficients using built-in dct function
coefsTmp = dct(x);
coefsTmp(min(end,Ndct)+1:end) = 0;

% Divide by square root of N so that everything is divded by N instead of
% the square root of N, because it is already divded by the sqrt of N
coefs = coefsTmp(1:min(Ndct,end)) / sqrt(length(coefsTmp));

% The sampling rate divided by the length of the signal is the lowest
% frequency represented by the DCT.  Multiplying by it makes the 1st
% coefficient into cents/second. For curves of constant slope, this makes
% the 1st coefficient approximately independent of the length of the
% signal. Multiplying by that frequency squared makes the 2nd coefficient into
% cents/second^2. For curves of constant 2nd derivative, this makes the 2nd
% coefficient approximately independent of the length of the signal, etc.
%
% For 2nd coefficient, multiple by -1 so that it represents positive slope   
if length(coefs)>1
    coefs(2:end)=coefs(2:end) .* (sr ./ length(x)) .^ [1:length(coefs)-1];
    coefs(2)=-coefs(2);
end

% reconstruct X using the DCT coefficients
approx = real(idct(coefsTmp));