function [seq] = de_bruijn_sequence(r,l)
% generate de bruijn sequence:
% https://en.wikipedia.org/wiki/De_Bruijn_sequence

% r: alphabet size
% l: subsequence (pattern) length

global a;
a = zeros(1, r*l);
global sequence;
sequence = [];
db(1, 1, r, l);
seq = sequence;
end
