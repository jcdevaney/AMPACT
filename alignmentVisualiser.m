function alignmentVisualiser(trace,mid,spec,fig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alignmentVisualiser(trace,sig,sr,mid,highlight)
%
% Description: 
%  Plots a gross DTW alignment overlaid with the fine alignment
%  resulting from the HMM aligner on the output of YIN.  Trace(1,:)
%  is the list of states in the HMM, and trace(2,:) is the number of YIN
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

if ~exist('fig', 'var'), fig=1; end

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
figure(fig)
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


function plotFineAlign(stateType, occupancy, notes, stftHop)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotFineAlign(stateType, occupancy, notes, stftHop, highlight)
%
% Description: 
%  Plot the HMM alignment based on the output of YIN.  StateType is the 
%  list of states in the HMM, and occupancy is the number of YIN frames 
%  for which that state is occupied.  Notes is a list of midi note numbers 
%  that are played, should be one note for each [3] in stateType.  If the 
%  highlight vector is supplied, it should contain indices of the states 
%  to highlight by plotting an extra line at the bottom of the window.
%
% Inputs:
%  stateType - vector with a list of states
%  occupancy - vector indicating the time (in seconds) at which the states 
%              in stateType end
%  notes - vector of notes from MIDI file
%  stftHop - the hop size between frames in the spectrogram
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the 4 states: silence in red, beginning transient in green,
% steady state in blue, ending transient in green.

styles = {{'r+-', 'LineWidth', 2}, 
          {'g+-', 'LineWidth', 2}, 
          {'b+-', 'LineWidth', 2}};

cs = occupancy /stftHop;
segments = [cs(1:end-1); cs(2:end)]';

hold on

stateNote = max(1, cumsum(stateType == 3)+1);
for i=1:size(segments,1)
    plot(segments(i,:)', repmat(notes(stateNote(i)),2,1), styles{stateType(i+1)}{:})
end

hold off
