function [vibratoDepth, vibratoRate, noteDynamic, intervalSize, pp, nmat,cents]=getPitchVibratoDynamicsData(times,yinres,nmat)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [vibratoDepth, vibratoRate, noteDynamics, intervals]
%    =getPitchVibratoDynamicsData(times,yinres)
%
% Description: 
%
% Inputs:
%  times - 
%  yinres - 
%
% Outputs:
%  vibratoDepth - 
%  vibratoRate - 
%  noteDynamics - 
%  intervalSize - 
%  pp - 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1 : length(times.ons)
    cents{i}=yinres.f0(round(times.ons(i)/32*yinres.sr):round(times.offs(i)/32*yinres.sr));
    pp(i)=perceivedPitch(cents{i}, 1/yinres.sr*32, 100000);
    vibrato{i}=fft(cents{i});
    vibrato{i}(1)=0;
    vibrato{i}(round(end/2):end) = 0;
    [vibratoDepth(i) noteVibratOpos(i)] = max(abs(vibrato{i}));
    vibratoRate(i) = noteVibratOpos(i) * (44100/32) / length(vibrato{i});
    pwrs{i}=yinres.pwr(round(times.ons(i)/32*yinres.sr):round(times.offs(i)/32*yinres.sr));
    dynamicsVals{i}=10*log10(pwrs{i});
    noteDynamic(i)=mean(dynamicsVals{i});
end

nmat(:,5)=(noteDynamic+100)';

for i=1 : length(pp)-1
    intervalSize(i) = pp(i+1)*1200-pp(i)*1200;
end