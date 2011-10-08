function nmatNew=getTimingData(midifile, times)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nmat=getTimingData(midifile, times)
%
% Description: 
%
% Inputs:
%  midifile - 
%  times - 
%
% Outputs:
%  nmatNew - 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nmatOld=readmidi(midifile);
nmatOld(:,[1,2])=nmatOld(:,[1,2])/2;

nmatNew=nmatOld;
nmatNew(:,6:7)=[times.ons',times.offs'-times.ons'];
offset=nmatNew(1,6)-nmatOld(1,1);
nmatNew(:,6)=nmatNew(:,6)-offset;
nmatNew(:,[1,2])=nmatNew(:,[6,7]);