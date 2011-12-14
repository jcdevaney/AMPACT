function nmatNew=getTimingData(midifile, times)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nmat=getTimingData(midifile, times)
%
% Description: Create a note matrix with performance timings
%
% Inputs:
%  midifile - name of midifile
%  times - note onset and offset times
%
% Outputs:
%  nmatNew - MIDI toolbox note matrix with performance timings
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read quantized MIDI file
nmatOld=readmidi(midifile);
nmatOld(:,[1,2])=nmatOld(:,[1,2])/2;

% Replace timing information in MIDI file with performance timings
nmatNew=nmatOld;
nmatNew(:,6:7)=[times.ons',times.offs'-times.ons'];
offset=nmatNew(1,6)-nmatOld(1,1);
nmatNew(:,6)=nmatNew(:,6)-offset;
nmatNew(:,[1,2])=nmatNew(:,[6,7]);