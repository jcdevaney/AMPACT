function [res, yinres, spec]=getVals(filename, midifile, audiofile, sr, hop)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [res, yinres]=getVals(filename, midifile, audiofile, sr, hop)
%
% Description: 
%   Gets values for DTW alignment and YIN analysis of specified audio 
%   signal and MIDI file
%
% Inputs:
%   filename
%   midifile, audiofile, sr, hop
%
% Outputs: 
%   res
%     res.on list of DTW predicted onset times in seconds
%     res.off list of DTW predicted offset times in seconds
%   yinres (below are the two elements that are used)
%     yinres.ap aperiodicty estimates for each frame
%     yinres.pwr power estimates for each frame
% 
% Dependencies:
%   de Cheveigné, A. 2002. YIN MATLAB implementation Available from:
%    http://audition.ens.fr/adc/sw/yin.zip
%   Toiviainen, P. and T. Eerola. 2006. MIDI Toolbox. Available from:
%    https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials...
%           /miditoolbox/
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% run the dyanamic time warping alignment
[res,spec] = runDTWAlignment(filename, midifile, 0.025);

% noramlize audio file
audiofile=audiofile/sqrt(mean(audiofile.^2));

% read MIDI file
nmat=readmidi(midifile);

% define parameters for YIN analysis
P.thresh = 0.01;
P.sr = sr;
P.hop = hop;
P.maxf0 = max(midi2hz(nmat(:,4)+2));
P.minf0 = min(midi2hz(nmat(:,4)-1));

% run YIN on audiofile
yinres=yin(audiofile,P);