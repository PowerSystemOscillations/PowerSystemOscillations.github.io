function g = dessat(a,isat)
% vectorized describing funtion for saturation
% 1 if a<=isat

% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

b_idx = find(a>=isat);
g=ones(length(a),1);
if ~isempty(b_idx)
    wt = atan2(isat(b_idx),sqrt(a(b_idx).*a(b_idx)-isat(b_idx).*isat(b_idx)));
    g(b_idx) = (2/pi)*(wt +0.5*sin(2*wt));
end