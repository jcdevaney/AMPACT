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