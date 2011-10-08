function visualiser(trace,mid,spec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% visualiser(trace,sig,sr,mid,highlight)
%
% Description: 
%  Plots a gross DTW alignment overlaid with the fine alignment
%  resulting from the HMM aligner on the output of YIN.  Trace(1,:)
%  is the list of states in the hmm (currently ignored, assumed to
%  be 1,2,3,2,1,2,3,2...), and trace(2,:) is the number of YIN
%  frames for which that state is occupied.  Highlight is a list of 
%  notes for which the steady state will be highlighted.
%
% Inputs:
%  trace - 3-D matrix of a list of states (trace(1,:)), the times   
%          they end at (trace(2,:)), and the state indices (trace(3,:))
%  mid - midi file
%  spec - spectogram of audio file (from alignmidiwav.m)
%
% Dependencies:
%   Toiviainen, P. and T. Eerola. 2006. MIDI Toolbox. Available from:
%     https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials
%      /miditoolbox/
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fix for ending zeros that mess up the plot
if trace(2,end)==0
    trace=trace(:,1:end-1);
end
if trace(2, end-1)==0
    trace(2,end-1)=trace(2,end-2);
end

% hop size between frames
stftHop = 0.025;

% read midi file
nmat=readmidi(mid);

% plot spectogram of audio file
imagesc(20*log10(spec));
title(['Spectrogram with Aligned MIDI Notes Overlaid']); 
xlabel(['Time (.05s)']); 
ylabel(['Midinote']); 
axis xy;
caxis(max(caxis)+[-50 0])
colormap(1-gray)

% zoom in fundamental frequencies
notes = nmat(:,4)';
notes = (2.^((notes-105)/12))*440;
notes(end+1) = notes(end);
nlim = length(notes);

% plot alignment
plotFineAlign(trace(1,:), trace(2,:), notes(1:nlim), stftHop);
if size(trace,1) >= 3
    notenums = trace(3,2:end);
else
    nlim = length(notes);
    notenums = [reshape(repmat(1:nlim,4,1),1,[]) nlim];
end


