function cents=getCentVals(times,yinres)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cents=getCentVals(times,yinres)
%
% Description: Get cent values (in relation to A, 440 Hz) for each note
%
% Inputs:
%  times - onset and offset times
%  yinres - structure of YIN values
%
% Outputs:
%  cents - cell array of cent values for each note 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% index into f0 estimates in YIN structure with onset and offset times
for i = 1:length(times.ons)
    cents{i}=yinres.f0(round(times.ons(i)/32*yinres.sr):round(times.offs(i)/32*yinres.sr))*1200;
end